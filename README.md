# CompanyCommander

## Overview

The CompanyCommander CRM system is designed to centralize and streamline the management of client data and operational processes within a company. Its primary goal is to serve as a Single Source of Truth (SSOT) for client information and ongoing operations. The system offers distinct interfaces for employees and clients, ensuring that all parties have access to the relevant and current data they need.

## Features

### For Employees
- **User View:** Employees can select from a list of companies they are associated with.
- **Company View:**
  - **Manage Sources:** Employees can add, remove, and modify groups of company resources like notes, sheets, drives, figmas, and miro boards.
  - **Task Management:** Users can track, view, add, remove and change tasks in real-time.
  - **Automate some Tasks:** System should be able to automate some necessary hard work instead of employees doing it manually (e.g. scraping some data, sending emails, etc.)

  - **Marketing Channels:** View existing marketing channels. Integrate?
  - **Marketing Channel Insights:** View statistics and data of marketing channels.


### For Admins
- Inherits all features of the employee view.
- **Edit Marketing Channels:** Admins have the additional capability to edit and manage marketing channels.

### For Clients
- **Default View:** The system provides a client-oriented interface.
- **Manage Sources:** Clients can view, add, and change their company's sources.
- **Marketing Channel Insights:** Clients have access to view statistics and data of marketing channels.

### Models
- **User:** Details about system users including employees and clients.
- **Company:** Information about companies that use the system.
- **Task:** Information about tasks within the system, including status, assignment, and completion details.
- **TaskLog:** A log of all tasks within the system.

### Models references

- **User:**
  - **Company:** A user belongs to a company.
  - **Task:** A user can have many tasks.
- **Company:**
  - **User:** A company has many users.
  - **Task:** A company has many tasks.
- **Task:**
  - **User:** A task belongs to many users.
  - **Company:** A task belongs to a company.
- **Marketing Channel:**
  - **Company:** A marketing channel belongs to a company.

### Technologies

Phoenix with LiveView, Ecto, Hound/Wallaby?, Faker

## Getting Started with CompanyCommander

To begin using the CompanyCommander CRM:

1. **Setup:**
   - Configure the database in `config/dev.exs` and `config/test.exs`.
   - Install dependencies with `mix deps.get`.
   - Create, migrate and seed the database with `mix ecto.reset`.

2. **Starting the Server:**
   - Use `mix phx.server` to start the Phoenix endpoint. Alternatively, use `iex -S mix phx.server` for an interactive session.

3. **Accessing the Interface:**
   - Visit [`localhost:4000`](http://localhost:4000) from your browser to access the CRM interface.
