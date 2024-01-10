defmodule CompanyCommander.Companies.Company do
  use Ecto.Schema
  import Ecto.Changeset

  schema "companies" do
    field :name, :string
    field :domain, :string
    field :address, :string
    field :contact_info, :string
    field :details, :map
    many_to_many :users, CompanyCommander.Accounts.User, join_through: CompanyCommander.Companies.CompanyUser
    has_many :tasks, CompanyCommander.Tasks.Task

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [:name, :address, :contact_info, :domain, :details])
    |> validate_required([:name, :address, :contact_info, :domain])
  end
end
