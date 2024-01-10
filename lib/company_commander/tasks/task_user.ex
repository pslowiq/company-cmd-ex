defmodule CompanyCommander.Tasks.TaskUser do
  use Ecto.Schema
  import Ecto.Changeset

  schema "task_users" do

    field :task_id, :id
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task_user, attrs) do
    task_user
    |> cast(attrs, [:task_id, :user_id])
    |> validate_required([:task_id, :user_id])
  end
end
