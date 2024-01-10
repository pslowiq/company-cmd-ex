defmodule CompanyCommander.Tasks.TimeLog do
  use Ecto.Schema
  import Ecto.Changeset

  schema "time_logs" do
    field :start_time, :naive_datetime
    field :end_time, :naive_datetime
    field :task_id, :id
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(time_log, attrs) do
    time_log
    |> cast(attrs, [:start_time, :end_time])
    |> validate_required([:task_id, :user_id, :start_time, :end_time])
  end
end
