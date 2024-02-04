defmodule CompanyCommander.Repo.Migrations.CreateTimeLogs do
  use Ecto.Migration

  def change do
    create table(:time_logs) do
      add :start_time, :naive_datetime
      add :end_time, :naive_datetime
      add :task_id, references(:tasks, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:time_logs, [:task_id])
    create index(:time_logs, [:user_id])
  end
end
