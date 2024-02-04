defmodule CompanyCommander.Companies do
  @moduledoc """
  The Companies context.
  """

  import Ecto.Query, warn: false
  alias CompanyCommander.Accounts
  alias CompanyCommander.Repo

  alias CompanyCommander.Companies.Company
  alias CompanyCommander.Accounts.User
  alias CompanyCommander.Companies.CompanyUser

  @doc """
  Returns the list of companies.

  ## Examples

      iex> list_companies()
      [%Company{}, ...]

  """
  def list_companies do
    Repo.all(Company)
  end

  @doc """
  Gets a single company.

  Raises `Ecto.NoResultsError` if the Company does not exist.

  ## Examples

      iex> get_company!(123)
      %Company{}

      iex> get_company!(456)
      ** (Ecto.NoResultsError)

  """
  def get_company!(id) do
    Repo.get!(Company, id)
  end


  def get_company_with_tasks!(id) do
    Repo.get!(Company, id) |> Repo.preload(:tasks)
  end

  @doc """
  Creates a company.

  ## Examples

      iex> create_company(%{field: value})
      {:ok, %Company{}}

      iex> create_company(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_company(attrs \\ %{}) do
    attrs = Map.put(attrs, "details", %{})
    case %Company{}
    |> Company.changeset(attrs)
    |> Repo.insert() do
      {:ok, company} ->
        for user_id <- attrs["user_ids"] do
          %CompanyUser{}
          |> CompanyUser.changeset(%{company_id: company.id, user_id: user_id})
          |> Repo.insert()
        end
        {:ok, company}
      {:error, changeset} -> {:error, changeset}
    end
  end

  @doc """
  Updates a company.

  ## Examples

      iex> update_company(company, %{field: new_value})
      {:ok, %Company{}}

      iex> update_company(company, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_company(%Company{} = company, attrs) do
    case company
    |> Company.changeset(attrs)
    |> Repo.update() do
      {:ok, company} ->
        delete_company_users(company.id)
        for user_id <- attrs["user_ids"] do
          %CompanyUser{}
          |> CompanyUser.changeset(%{company_id: company.id, user_id: user_id})
          |> Repo.insert()
        end
        {:ok, company}
      {:error, changeset} -> {:error, changeset}
    end
  end

  @doc """
  Deletes a company.

  ## Examples

      iex> delete_company(company)
      {:ok, %Company{}}

      iex> delete_company(company)
      {:error, %Ecto.Changeset{}}

  """
  def delete_company(%Company{} = company) do
    delete_company_users(company.id)
    # delete all tasks for company
    query = from(t in CompanyCommander.Tasks.Task,
      where: t.company_id == ^company.id,
      select: t)
    query
    |> Repo.all()
    |> Enum.each(&Repo.delete(&1))
    Repo.delete(company)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking company changes.

  ## Examples

      iex> change_company(company)
      %Ecto.Changeset{data: %Company{}}

  """
  def change_company(%Company{} = company, attrs \\ %{}) do
    Company.changeset(company, attrs)
  end


  @doc """
  Returns the list of company_users.

  ## Examples

      iex> list_company_users()
      [%CompanyUser{}, ...]

  """
  def list_company_users do
    Repo.all(CompanyUser)
  end

  @doc """
  Gets a single company_user.

  Raises `Ecto.NoResultsError` if the Company user does not exist.

  ## Examples

      iex> get_company_user!(123)
      %CompanyUser{}

      iex> get_company_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_company_user!(id), do: Repo.get!(CompanyUser, id)
  def get_company_user(company_id, user_id) do
    query = from(cu in CompanyUser,
      where: cu.company_id == ^company_id and cu.user_id == ^user_id,
      select: cu)
    query
    |> Repo.one()
  end
  def auth_company_for_user(company_id, user_id) do
    case get_company_user(company_id, user_id) do
      %CompanyUser{} -> true
      nil -> false
    end
  end

  @doc """
  Creates a company_user.

  ## Examples

      iex> create_company_user(%{field: value})
      {:ok, %CompanyUser{}}

      iex> create_company_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_company_user(attrs \\ %{}) do
    %CompanyUser{}
    |> CompanyUser.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a company_user.

  ## Examples

      iex> update_company_user(company_user, %{field: new_value})
      {:ok, %CompanyUser{}}

      iex> update_company_user(company_user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_company_user(%CompanyUser{} = company_user, attrs) do
    company_user
    |> CompanyUser.changeset(attrs)
    |> Repo.update()
  end

  def delete_company_users(company_id) do
    query = from(cu in CompanyUser,
      where: cu.company_id == ^company_id,
      select: cu)
    query
    |> Repo.all()
    |> Enum.each(&Repo.delete(&1))
  end

  @doc """
  Deletes a company_user.

  ## Examples

      iex> delete_company_user(company_user)
      {:ok, %CompanyUser{}}

      iex> delete_company_user(company_user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_company_user(%CompanyUser{} = company_user) do
    Repo.delete(company_user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking company_user changes.

  ## Examples

      iex> change_company_user(company_user)
      %Ecto.Changeset{data: %CompanyUser{}}

  """
  def change_company_user(%CompanyUser{} = company_user, attrs \\ %{}) do
    CompanyUser.changeset(company_user, attrs)
  end


  def get_companies_for_user(user_id) do
    user = Accounts.get_user!(user_id)
    if user.role == "admin" do
      list_companies()
    else
      query = from(c in Company,
        join: cu in CompanyUser, on: cu.company_id == c.id,
        where: cu.user_id == ^user_id,
        select: c)

      query
      |> Repo.all()
    end
  end

  def get_users_for_company(company_id) do
    query = from(u in User,
      join: cu in CompanyUser, on: cu.user_id == u.id,
      where: cu.company_id == ^company_id,
      select: u)

    ret = query
    |> Repo.all()
    ret
  end

  def make_user_options_for_company(company_id) do
    all_users = Accounts.list_users()
    company_users_user_ids = get_users_for_company(company_id)
    |> Enum.map(& &1.id)
    Enum.map(all_users, fn user ->
      selected = user.id in company_users_user_ids
      %{id: user.id, label: user.name, selected: selected}
    end)
  end

  def make_user_options_for_new_company() do
    all_users = Accounts.list_users()
    Enum.map(all_users, fn user ->
      %{id: user.id, label: user.name, selected: false}
    end)
  end

  def make_user_options_for_new_company_task(company_id) do
    get_users_for_company(company_id)
    |> Enum.map(fn user -> %{id: user.id, label: user.name, selected: false} end)
  end

end
