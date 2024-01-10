defmodule CompanyCommander.Companies.CompanyUser do
  use Ecto.Schema
  import Ecto.Changeset

  schema "company_users" do

    field :user_id, :id
    field :company_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(company_user, attrs) do
    company_user
    |> cast(attrs, [:user_id, :company_id])
    |> validate_required([:user_id, :company_id])
  end
end
