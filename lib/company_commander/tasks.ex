  defmodule CompanyCommander.Tasks do
    @moduledoc """
    The Tasks context.
    """

    import Ecto.Query, warn: false
    alias CompanyCommander.Repo

    alias CompanyCommander.Tasks.Task
    alias CompanyCommander.Tasks.TaskUser
    alias CompanyCommander.Companies

    @doc """
    Returns the list of tasks.

    ## Examples

        iex> list_tasks()
        [%Task{}, ...]

    """
    def list_tasks do
      Repo.all(Task)
    end

    @doc """
    Gets a single task.

    Raises `Ecto.NoResultsError` if the Task does not exist.

    ## Examples

        iex> get_task!(123)
        %Task{}

        iex> get_task!(456)
        ** (Ecto.NoResultsError)

    """
    def get_task!(id), do: Repo.get!(Task, id)

    @doc """
    Creates a task.

    ## Examples

        iex> create_task(%{field: value})
        {:ok, %Task{}}

        iex> create_task(%{field: bad_value})
        {:error, %Ecto.Changeset{}}

    """
    def create_task(attrs \\ %{}) do

      task = %Task{}
      |> Task.changeset(attrs)
      |> Repo.insert()

      case task do
        {:ok, task} ->
          for user_id <- attrs["user_ids"] do
            %TaskUser{}
            |> TaskUser.changeset(%{task_id: task.id, user_id: user_id})
            |> Repo.insert()
          end
          {:ok, task}
        {:error, changeset} -> {:error, changeset}
      end

    end


    def create_preloaded_task(attrs \\ %{}) do
      case create_task(attrs) do
        {:ok, task} ->
          {:ok, task
          |> Repo.preload(:users)
          |> Repo.preload(:time_logs)}
        {:error, changeset} ->
          {:error, changeset}
      end
    end

    @doc """
    Updates a task.

    ## Examples

        iex> update_task(task, %{field: new_value})
        {:ok, %Task{}}

        iex> update_task(task, %{field: bad_value})
        {:error, %Ecto.Changeset{}}

    """
    def update_task(%Task{} = task, attrs) do
      task
      |> Task.changeset(attrs)
      |> Repo.update()
    end

    def remove_task_users(task) do
      query = from(tu in TaskUser,
        where: tu.task_id == ^task.id,
        select: tu)
      query
      |> Repo.all()
      |> Enum.map(fn tu -> delete_task_user(tu) end)
    end

    def update_task_and_preload(%Task{} = task, attrs) do
      case task
      |> Task.changeset(attrs)
      |> Repo.update() do
        {:ok, task} ->

          remove_task_users(task)

          for user_id <- attrs["user_ids"] do
            %TaskUser{}
            |> TaskUser.changeset(%{task_id: task.id, user_id: user_id})
            |> Repo.insert()
          end
          {:ok, task
          |> Repo.preload(:users)}
        {:error, changeset} ->
          {:error, changeset}
      end
    end

    @doc """
    Deletes a task.

    ## Examples

        iex> delete_task(task)
        {:ok, %Task{}}

        iex> delete_task(task)
        {:error, %Ecto.Changeset{}}

    """
    def delete_task(%Task{} = task) do
      Repo.delete(task)
    end

    @doc """
    Returns an `%Ecto.Changeset{}` for tracking task changes.

    ## Examples

        iex> change_task(task)
        %Ecto.Changeset{data: %Task{}}

    """
    def change_task(%Task{} = task, attrs \\ %{}) do
      Task.changeset(task, attrs)
    end


    @doc """
    Returns the list of task_users.

    ## Examples

        iex> list_task_users()
        [%TaskUser{}, ...]

    """
    def list_task_users do
      Repo.all(TaskUser)
    end

    @doc """
    Gets a single task_user.

    Raises `Ecto.NoResultsError` if the Task user does not exist.

    ## Examples

        iex> get_task_user!(123)
        %TaskUser{}

        iex> get_task_user!(456)
        ** (Ecto.NoResultsError)

    """
    def get_task_user!(id), do: Repo.get!(TaskUser, id)

    def get_task_users(task_id) do
      query = from(tu in TaskUser,
        where: tu.task_id == ^task_id,
        select: tu)
      query
      |> Repo.all()
    end

    def auth_user_for_task(task_id, user_id) do
      query = from(tu in TaskUser,
        where: tu.task_id == ^task_id and tu.user_id == ^user_id,
        select: tu)
      result = query
      |> Repo.one()

      case result do
        nil -> false
        %TaskUser{} -> true
      end
    end

    @doc """
    Creates a task_user.

    ## Examples

        iex> create_task_user(%{field: value})
        {:ok, %TaskUser{}}

        iex> create_task_user(%{field: bad_value})
        {:error, %Ecto.Changeset{}}

    """
    def create_task_user(attrs \\ %{}) do
      %TaskUser{}
      |> TaskUser.changeset(attrs)
      |> Repo.insert()
    end

    @doc """
    Updates a task_user.

    ## Examples

        iex> update_task_user(task_user, %{field: new_value})
        {:ok, %TaskUser{}}

        iex> update_task_user(task_user, %{field: bad_value})
        {:error, %Ecto.Changeset{}}

    """
    def update_task_user(%TaskUser{} = task_user, attrs) do
      task_user
      |> TaskUser.changeset(attrs)
      |> Repo.update()
    end

    @doc """
    Deletes a task_user.

    ## Examples

        iex> delete_task_user(task_user)
        {:ok, %TaskUser{}}

        iex> delete_task_user(task_user)
        {:error, %Ecto.Changeset{}}

    """
    def delete_task_user(%TaskUser{} = task_user) do
      Repo.delete(task_user)
    end

    @doc """
    Returns an `%Ecto.Changeset{}` for tracking task_user changes.

    ## Examples

        iex> change_task_user(task_user)
        %Ecto.Changeset{data: %TaskUser{}}

    """
    def change_task_user(%TaskUser{} = task_user, attrs \\ %{}) do
      TaskUser.changeset(task_user, attrs)
    end

    @doc """
    Returns the tasks for a company.

    ## Examples

        iex> get_tasks_for_company(123)
        [%Task{}, ...]

    """

    def get_tasks_for_company(company_id) do
      query = from t in Task,
        where: t.company_id == ^company_id,
        preload: [:users]

      Repo.all(query)
    end

    @doc """
    Returns the list of tasks.

    ## Examples

        iex> list_tasks()
        [%Task{}, ...]

    """
    def list_task do
      Repo.all(Task)
    end

    alias CompanyCommander.Tasks.TimeLog

  @doc """
  Returns the list of time_logs.

  ## Examples

      iex> list_time_logs()
      [%TimeLog{}, ...]

  """
  def list_time_logs do
    Repo.all(TimeLog)
  end

  @doc """
  Gets a single time_log.

  Raises `Ecto.NoResultsError` if the TimeLog does not exist.

  ## Examples

      iex> get_time_log!(123)
      %TimeLog{}

      iex> get_time_log!(456)
      ** (Ecto.NoResultsError)

  """
  def get_time_log!(id), do: Repo.get!(TimeLog, id)


  @doc """
  Creates a time_log.

  ## Examples

      iex> create_time_log(%{field: value})
      {:ok, %TimeLog{}}

      iex> create_time_log(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_time_log(attrs \\ %{}) do
    %TimeLog{}
    |> TimeLog.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a time_log.

  ## Examples

      iex> update_time_log(time_log, %{field: new_value})
      {:ok, %TimeLog{}}

      iex> update_time_log(time_log, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_time_log(%TimeLog{} = time_log, attrs) do
    time_log
    |> TimeLog.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a time_log.

  ## Examples

      iex> delete_time_log(time_log)
      {:ok, %TimeLog{}}

      iex> delete_time_log(time_log)
      {:error, %Ecto.Changeset{}}

  """
  def delete_time_log(%TimeLog{} = time_log) do
    Repo.delete(time_log)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking time_log changes.

  ## Examples

      iex> change_time_log(time_log)
      %Ecto.Changeset{data: %TimeLog{}}

  """
  def change_time_log(%TimeLog{} = time_log, attrs \\ %{}) do
    TimeLog.changeset(time_log, attrs)
  end

  def get_time_logs_for_task(task_id) do
    query = from tl in TimeLog,
      where: tl.task_id == ^task_id,
      select: tl
    query
    |> Repo.all()
  end

  def check_if_user_is_tracking_time(task_id, user_id) do
    query = from tl in TimeLog,
      where: tl.task_id == ^task_id and tl.user_id == ^user_id and is_nil(tl.end_time),
      select: tl
    result = query
    |> Repo.one()

    case result do
      nil -> false
      %TimeLog{} -> true
    end
  end

  def start_tracking_time(task_id, user_id) do
    %TimeLog{task_id: task_id, user_id: user_id, start_time: DateTime.utc_now() |> DateTime.truncate(:second)}
    |> TimeLog.changeset(%{})
    |> Repo.insert()
  end

  def stop_tracking_time(task_id, user_id) do
    query = from tl in TimeLog,
      where: tl.task_id == ^task_id and tl.user_id == ^user_id and is_nil(tl.end_time),
      select: tl
    result = query
    |> Repo.one()

    case result do
      {:error, _} -> {:error, "No time log found"}
      %TimeLog{} = time_log ->
        time_log
        |> TimeLog.changeset(%{end_time: DateTime.utc_now() |> DateTime.truncate(:second)})
        |> Repo.update()
      end
  end

  def make_user_options_for_task(task_id) do
    company_id = get_task!(task_id).company_id
    company_users = Companies.get_users_for_company(company_id)
    task_users = get_task_users(task_id)
    Enum.map(company_users, fn user ->
      selected = Enum.member?(task_users, user)
      %{id: user.id, name: user.name, selected: selected}
    end)
  end

  def make_user_options_for_new_task(task_id, company_id) do
    company_users = Companies.get_users_for_company(company_id)
    task_users_ids = get_task_users(task_id)
    |> Enum.map(fn tu -> tu.user_id end)
    Enum.map(company_users, fn user ->
      selected = user.id in task_users_ids
      %{id: user.id, label: user.name, selected: selected}
    end)
  end

  def make_user_options_for_task(task_id, company_id) do
    current_task_users_ids = get_task_users(task_id)
    |> Enum.map(fn tu -> tu.user_id end)
    company_users = Companies.get_users_for_company(company_id)

    Enum.map(company_users, fn user ->
      selected = user.id in current_task_users_ids
      %{id: user.id, label: user.name, selected: selected}
    end)
  end

end
