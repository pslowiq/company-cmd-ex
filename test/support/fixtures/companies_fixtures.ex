defmodule CompanyCommander.CompaniesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CompanyCommander.Companies` context.
  """

  @doc """
  Generate a company.
  """
  def company_fixture(attrs \\ %{}) do
    {:ok, company} =
      attrs
      |> Enum.into(%{
        address: "some address",
        contact_info: "some contact_info",
        details: %{},
        domain: "some domain",
        name: "some name"
      })
      |> CompanyCommander.Companies.create_company()

    company
  end

  @doc """
  Generate a company_user.
  """
  def company_user_fixture(attrs \\ %{}) do
    {:ok, company_user} =
      attrs
      |> Enum.into(%{

      })
      |> CompanyCommander.Companies.create_company_user()

    company_user
  end
end
