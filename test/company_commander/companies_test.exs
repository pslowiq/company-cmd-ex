defmodule CompanyCommander.CompaniesTest do
  use CompanyCommander.DataCase

  alias CompanyCommander.Companies

  describe "companies" do
    alias CompanyCommander.Companies.Company

    import CompanyCommander.CompaniesFixtures

    @invalid_attrs %{name: nil, domain: nil, address: nil, details: nil, contact_info: nil}

    test "list_companies/0 returns all companies" do
      company = company_fixture()
      assert Companies.list_companies() == [company]
    end

    test "get_company!/1 returns the company with given id" do
      company = company_fixture()
      assert Companies.get_company!(company.id) == company
    end

    test "create_company/1 with valid data creates a company" do
      valid_attrs = %{name: "some name", domain: "some domain", address: "some address", details: %{}, contact_info: "some contact_info"}

      assert {:ok, %Company{} = company} = Companies.create_company(valid_attrs)
      assert company.name == "some name"
      assert company.domain == "some domain"
      assert company.address == "some address"
      assert company.details == %{}
      assert company.contact_info == "some contact_info"
    end

    test "create_company/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Companies.create_company(@invalid_attrs)
    end

    test "update_company/2 with valid data updates the company" do
      company = company_fixture()
      update_attrs = %{name: "some updated name", domain: "some updated domain", address: "some updated address", details: %{}, contact_info: "some updated contact_info"}

      assert {:ok, %Company{} = company} = Companies.update_company(company, update_attrs)
      assert company.name == "some updated name"
      assert company.domain == "some updated domain"
      assert company.address == "some updated address"
      assert company.details == %{}
      assert company.contact_info == "some updated contact_info"
    end

    test "update_company/2 with invalid data returns error changeset" do
      company = company_fixture()
      assert {:error, %Ecto.Changeset{}} = Companies.update_company(company, @invalid_attrs)
      assert company == Companies.get_company!(company.id)
    end

    test "delete_company/1 deletes the company" do
      company = company_fixture()
      assert {:ok, %Company{}} = Companies.delete_company(company)
      assert_raise Ecto.NoResultsError, fn -> Companies.get_company!(company.id) end
    end

    test "change_company/1 returns a company changeset" do
      company = company_fixture()
      assert %Ecto.Changeset{} = Companies.change_company(company)
    end
  end

  describe "company_users" do
    alias CompanyCommander.Companies.CompanyUser

    import CompanyCommander.CompaniesFixtures

    @invalid_attrs %{}

    test "list_company_users/0 returns all company_users" do
      company_user = company_user_fixture()
      assert Companies.list_company_users() == [company_user]
    end

    test "get_company_user!/1 returns the company_user with given id" do
      company_user = company_user_fixture()
      assert Companies.get_company_user!(company_user.id) == company_user
    end

    test "create_company_user/1 with valid data creates a company_user" do
      valid_attrs = %{}

      assert {:ok, %CompanyUser{} = company_user} = Companies.create_company_user(valid_attrs)
    end

    test "create_company_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Companies.create_company_user(@invalid_attrs)
    end

    test "update_company_user/2 with valid data updates the company_user" do
      company_user = company_user_fixture()
      update_attrs = %{}

      assert {:ok, %CompanyUser{} = company_user} = Companies.update_company_user(company_user, update_attrs)
    end

    test "update_company_user/2 with invalid data returns error changeset" do
      company_user = company_user_fixture()
      assert {:error, %Ecto.Changeset{}} = Companies.update_company_user(company_user, @invalid_attrs)
      assert company_user == Companies.get_company_user!(company_user.id)
    end

    test "delete_company_user/1 deletes the company_user" do
      company_user = company_user_fixture()
      assert {:ok, %CompanyUser{}} = Companies.delete_company_user(company_user)
      assert_raise Ecto.NoResultsError, fn -> Companies.get_company_user!(company_user.id) end
    end

    test "change_company_user/1 returns a company_user changeset" do
      company_user = company_user_fixture()
      assert %Ecto.Changeset{} = Companies.change_company_user(company_user)
    end
  end

  describe "companies" do
    alias CompanyCommander.Companies.Company

    import CompanyCommander.CompaniesFixtures

    @invalid_attrs %{name: nil, domain: nil, address: nil, contact_info: nil, details: nil}

    test "list_companies/0 returns all companies" do
      company = company_fixture()
      assert Companies.list_companies() == [company]
    end

    test "get_company!/1 returns the company with given id" do
      company = company_fixture()
      assert Companies.get_company!(company.id) == company
    end

    test "create_company/1 with valid data creates a company" do
      valid_attrs = %{name: "some name", domain: "some domain", address: "some address", contact_info: "some contact_info", details: %{}}

      assert {:ok, %Company{} = company} = Companies.create_company(valid_attrs)
      assert company.name == "some name"
      assert company.domain == "some domain"
      assert company.address == "some address"
      assert company.contact_info == "some contact_info"
      assert company.details == %{}
    end

    test "create_company/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Companies.create_company(@invalid_attrs)
    end

    test "update_company/2 with valid data updates the company" do
      company = company_fixture()
      update_attrs = %{name: "some updated name", domain: "some updated domain", address: "some updated address", contact_info: "some updated contact_info", details: %{}}

      assert {:ok, %Company{} = company} = Companies.update_company(company, update_attrs)
      assert company.name == "some updated name"
      assert company.domain == "some updated domain"
      assert company.address == "some updated address"
      assert company.contact_info == "some updated contact_info"
      assert company.details == %{}
    end

    test "update_company/2 with invalid data returns error changeset" do
      company = company_fixture()
      assert {:error, %Ecto.Changeset{}} = Companies.update_company(company, @invalid_attrs)
      assert company == Companies.get_company!(company.id)
    end

    test "delete_company/1 deletes the company" do
      company = company_fixture()
      assert {:ok, %Company{}} = Companies.delete_company(company)
      assert_raise Ecto.NoResultsError, fn -> Companies.get_company!(company.id) end
    end

    test "change_company/1 returns a company changeset" do
      company = company_fixture()
      assert %Ecto.Changeset{} = Companies.change_company(company)
    end
  end
end
