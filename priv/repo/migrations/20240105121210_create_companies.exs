defmodule CompanyCommander.Repo.Migrations.CreateCompanies do
  use Ecto.Migration

  def change do
    create table(:companies) do
      add :name, :string
      add :address, :string
      add :contact_info, :string
      add :domain, :string
      add :details, :map

      timestamps(type: :utc_datetime)
    end
  end
end
