defmodule CompanyCommander.TasksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CompanyCommander.Tasks` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        description: "some description",
        finished: true,
        name: "some name"
      })
      |> CompanyCommander.Tasks.create_task()

    task
  end

  @doc """
  Generate a task_user.
  """
  def task_user_fixture(attrs \\ %{}) do
    {:ok, task_user} =
      attrs
      |> Enum.into(%{

      })
      |> CompanyCommander.Tasks.create_task_user()

    task_user
  end
end
