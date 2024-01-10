defmodule CompanyCommander.TasksTest do
  use CompanyCommander.DataCase

  alias CompanyCommander.Tasks

  describe "tasks" do
    alias CompanyCommander.Tasks.Task

    import CompanyCommander.TasksFixtures

    @invalid_attrs %{name: nil, finished: nil, description: nil}

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Tasks.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Tasks.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      valid_attrs = %{name: "some name", finished: true, description: "some description"}

      assert {:ok, %Task{} = task} = Tasks.create_task(valid_attrs)
      assert task.name == "some name"
      assert task.finished == true
      assert task.description == "some description"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      update_attrs = %{name: "some updated name", finished: false, description: "some updated description"}

      assert {:ok, %Task{} = task} = Tasks.update_task(task, update_attrs)
      assert task.name == "some updated name"
      assert task.finished == false
      assert task.description == "some updated description"
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Tasks.update_task(task, @invalid_attrs)
      assert task == Tasks.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Tasks.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Tasks.change_task(task)
    end
  end

  describe "task_users" do
    alias CompanyCommander.Tasks.TaskUser

    import CompanyCommander.TasksFixtures

    @invalid_attrs %{}

    test "list_task_users/0 returns all task_users" do
      task_user = task_user_fixture()
      assert Tasks.list_task_users() == [task_user]
    end

    test "get_task_user!/1 returns the task_user with given id" do
      task_user = task_user_fixture()
      assert Tasks.get_task_user!(task_user.id) == task_user
    end

    test "create_task_user/1 with valid data creates a task_user" do
      valid_attrs = %{}

      assert {:ok, %TaskUser{} = task_user} = Tasks.create_task_user(valid_attrs)
    end

    test "create_task_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_task_user(@invalid_attrs)
    end

    test "update_task_user/2 with valid data updates the task_user" do
      task_user = task_user_fixture()
      update_attrs = %{}

      assert {:ok, %TaskUser{} = task_user} = Tasks.update_task_user(task_user, update_attrs)
    end

    test "update_task_user/2 with invalid data returns error changeset" do
      task_user = task_user_fixture()
      assert {:error, %Ecto.Changeset{}} = Tasks.update_task_user(task_user, @invalid_attrs)
      assert task_user == Tasks.get_task_user!(task_user.id)
    end

    test "delete_task_user/1 deletes the task_user" do
      task_user = task_user_fixture()
      assert {:ok, %TaskUser{}} = Tasks.delete_task_user(task_user)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_task_user!(task_user.id) end
    end

    test "change_task_user/1 returns a task_user changeset" do
      task_user = task_user_fixture()
      assert %Ecto.Changeset{} = Tasks.change_task_user(task_user)
    end
  end

  describe "task" do
    alias CompanyCommander.Tasks.Task

    import CompanyCommander.TasksFixtures

    @invalid_attrs %{name: nil, finished: nil, description: nil}

    test "list_task/0 returns all task" do
      task = task_fixture()
      assert Tasks.list_task() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Tasks.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      valid_attrs = %{name: "some name", finished: true, description: "some description"}

      assert {:ok, %Task{} = task} = Tasks.create_task(valid_attrs)
      assert task.name == "some name"
      assert task.finished == true
      assert task.description == "some description"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      update_attrs = %{name: "some updated name", finished: false, description: "some updated description"}

      assert {:ok, %Task{} = task} = Tasks.update_task(task, update_attrs)
      assert task.name == "some updated name"
      assert task.finished == false
      assert task.description == "some updated description"
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Tasks.update_task(task, @invalid_attrs)
      assert task == Tasks.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Tasks.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Tasks.change_task(task)
    end
  end
end
