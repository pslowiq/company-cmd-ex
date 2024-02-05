alias CompanyCommander.Repo
alias CompanyCommander.Companies.Company
alias CompanyCommander.Companies.CompanyUser
alias CompanyCommander.Accounts.User
alias CompanyCommander.Accounts
alias CompanyCommander.Tasks.Task
alias CompanyCommander.Tasks.TaskUser

company1 = %Company{
  name: "Company A",
  address: "123 A Street",
  contact_info: "contact@companya.com",
  domain: "companya.com",
  details: %{
    "company_size" => "small",
    "industry" => "software"
  }
}

company2 = %Company{
  name: "Company B",
  address: "123 B Street",
  contact_info: "b@contact.com",
  domain: "contact.com",
  details: %{
    "company_size" => "medium",
    "industry" => "software"
  }
}

company3 = %Company{
  name: "Company C",
  address: "133231 C Street",
  contact_info: "c@contact.com",
  domain: "company-c.com",
  details: %{
    "company_size" => "medium",
    "industry" => "software"
  }
}

company1 = Repo.insert!(company1)
company2 = Repo.insert!(company2)
company3 = Repo.insert!(company3)

user1 = %User{name: "Piotr Słowik", email: "pslowiq@gmail.com", hashed_password: Accounts.hash_password("password123"), role: "admin"}
user2 = %User{name: "Jane Smith", email: "jane@example.com", hashed_password: Accounts.hash_password("password123"), role: "user"}
user3 = %User{name: "Raper Traper", email: "raper@example.com", hashed_password: Accounts.hash_password("password123"), role: "user"}
user4 = %User{name: "Will Zmit", email: "will@example.com", hashed_password: Accounts.hash_password("password123"), role: "user"}
user5 = %User{name: "Joanna Krupa", email: "krupa@example.com", hashed_password: Accounts.hash_password("password123"), role: "user"}

user1 = Repo.insert!(user1)
user2 = Repo.insert!(user2)
user3 = Repo.insert!(user3)
user4 = Repo.insert!(user4)
user5 = Repo.insert!(user5)


company_user1 = %CompanyUser{user_id: user1.id, company_id: company1.id}
company_user2 = %CompanyUser{user_id: user1.id, company_id: company2.id}
company_user3 = %CompanyUser{user_id: user2.id, company_id: company1.id}
company_user4 = %CompanyUser{user_id: user2.id, company_id: company2.id}
company_user5 = %CompanyUser{user_id: user3.id, company_id: company2.id}
company_user6 = %CompanyUser{user_id: user3.id, company_id: company1.id}
company_user7 = %CompanyUser{user_id: user4.id, company_id: company3.id}
company_user8 = %CompanyUser{user_id: user5.id, company_id: company3.id}

Repo.insert!(company_user1)
Repo.insert!(company_user2)
Repo.insert!(company_user3)
Repo.insert!(company_user4)
Repo.insert!(company_user5)
Repo.insert!(company_user6)
Repo.insert!(company_user7)
Repo.insert!(company_user8)

task1 = %Task{name: "Task 1", description: "Task 1 description", company_id: company1.id}
task2 = %Task{name: "Task 2", description: "Task 2 description", company_id: company1.id}
task3 = %Task{name: "Task 3", description: "Task 3 description", company_id: company1.id}
task4 = %Task{name: "Task 4", description: "Task 4 description", company_id: company2.id}
task5 = %Task{name: "Task 5", description: "Task 4 description", company_id: company3.id}
task6 = %Task{name: "Task 6", description: "Task 4 description", company_id: company3.id}

task1 = Repo.insert!(task1)
task2 = Repo.insert!(task2)
task3 = Repo.insert!(task3)

task_user1 = %TaskUser{user_id: user1.id, task_id: task1.id}
task_user2 = %TaskUser{user_id: user1.id, task_id: task2.id}
Repo.insert!(task_user1)
Repo.insert!(task_user2)
