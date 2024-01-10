defmodule CompanyCommander.Repo do
  use Ecto.Repo,
    otp_app: :company_commander,
    adapter: Ecto.Adapters.Postgres
end
