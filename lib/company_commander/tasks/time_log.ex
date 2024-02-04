defmodule CompanyCommander.Tasks.TimeLog do
  use Ecto.Schema
  import Ecto.Changeset

  schema "time_logs" do
    field :start_time, :utc_datetime
    field :end_time, :utc_datetime
    field :task_id, :id
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(time_log, attrs) do
    time_log
    |> cast(attrs, [:user_id, :task_id, :start_time, :end_time])
    |> validate_required([:user_id, :task_id, :start_time])
  end
end
