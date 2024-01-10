defmodule CompanyCommanderWeb.TaskLiveTest do
  use CompanyCommanderWeb.ConnCase

  import Phoenix.LiveViewTest
  import CompanyCommander.TasksFixtures

  @create_attrs %{name: "some name", finished: true, description: "some description"}
  @update_attrs %{name: "some updated name", finished: false, description: "some updated description"}
  @invalid_attrs %{name: nil, finished: false, description: nil}

  defp create_task(_) do
    task = task_fixture()
    %{task: task}
  end

  describe "Index" do
    setup [:create_task]

    test "lists all task", %{conn: conn, task: task} do
      {:ok, _index_live, html} = live(conn, ~p"/task")

      assert html =~ "Listing Task"
      assert html =~ task.name
    end

    test "saves new task", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/task")

      assert index_live |> element("a", "New Task") |> render_click() =~
               "New Task"

      assert_patch(index_live, ~p"/task/new")

      assert index_live
             |> form("#task-form", task: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#task-form", task: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/task")

      html = render(index_live)
      assert html =~ "Task created successfully"
      assert html =~ "some name"
    end

    test "updates task in listing", %{conn: conn, task: task} do
      {:ok, index_live, _html} = live(conn, ~p"/task")

      assert index_live |> element("#task-#{task.id} a", "Edit") |> render_click() =~
               "Edit Task"

      assert_patch(index_live, ~p"/task/#{task}/edit")

      assert index_live
             |> form("#task-form", task: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#task-form", task: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/task")

      html = render(index_live)
      assert html =~ "Task updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes task in listing", %{conn: conn, task: task} do
      {:ok, index_live, _html} = live(conn, ~p"/task")

      assert index_live |> element("#task-#{task.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#task-#{task.id}")
    end
  end

  describe "Show" do
    setup [:create_task]

    test "displays task", %{conn: conn, task: task} do
      {:ok, _show_live, html} = live(conn, ~p"/task/#{task}")

      assert html =~ "Show Task"
      assert html =~ task.name
    end

    test "updates task within modal", %{conn: conn, task: task} do
      {:ok, show_live, _html} = live(conn, ~p"/task/#{task}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Task"

      assert_patch(show_live, ~p"/task/#{task}/show/edit")

      assert show_live
             |> form("#task-form", task: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#task-form", task: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/task/#{task}")

      html = render(show_live)
      assert html =~ "Task updated successfully"
      assert html =~ "some updated name"
    end
  end
end
