defmodule CompanyCommander.Repo.Migrations.CreateCompanyUsers do
  use Ecto.Migration

  def change do
    create table(:company_users) do
      add :user_id, references(:users, on_delete: :nothing)
      add :company_id, references(:companies, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:company_users, [:user_id])
    create index(:company_users, [:company_id])
  end
end
