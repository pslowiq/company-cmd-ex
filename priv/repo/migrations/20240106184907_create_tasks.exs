defmodule CompanyCommander.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :name, :string
      add :description, :text
      add :finished, :boolean, default: false, null: false
      add :company_id, references(:companies, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:tasks, [:company_id])
  end
end
