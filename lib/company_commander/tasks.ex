defmodule CompanyCommander.Tasks do
  @moduledoc """
  The Tasks context.
  """

  import Ecto.Query, warn: false
  alias CompanyCommander.Repo

  alias CompanyCommander.Tasks.Task

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
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end


  def create_preloaded_task(attrs \\ %{}) do
    case create_task(attrs) do
      {:ok, task} ->
        task
        |> Repo.preload(:users)
        |> Repo.preload(:time_logs)
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

  alias CompanyCommander.Tasks.TaskUser

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

end
