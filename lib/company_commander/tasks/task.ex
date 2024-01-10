defmodule CompanyCommander.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :name, :string
    field :finished, :boolean, default: false
    field :description, :string
    field :company_id, :id
    many_to_many :users, CompanyCommander.Accounts.User, join_through: CompanyCommander.Tasks.TaskUser
    has_many :time_logs, CompanyCommander.Tasks.TimeLog
    timestamps(type: :utc_datetime)

  end

  @doc false

  def changeset(task, attrs) do
    cs = task
    |> cast(attrs, [:name, :description, :finished, :company_id])
    |> validate_required([:name, :finished, :company_id])
    cs
  end
end
