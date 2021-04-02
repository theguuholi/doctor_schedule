defmodule DoctorScheduleWeb.PageLiveTest do
  use DoctorScheduleWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias DoctorSchedule.UserFixture
  alias DoctorScheduleWeb.Auth.Guardian

  test "when init page", %{conn: conn} do
    user = UserFixture.create_user()

    conn =
      conn
      |> Guardian.Plug.sign_in(user)
      |> Plug.Test.init_test_session(current_user: user)

    {:ok, view, html} = live(conn, Routes.page_path(conn, :index))
    date = Date.utc_today()

    assert html =~ "Today"
    assert render(view) =~ "Today"
    assert html =~ "#{date.day}"
    assert render(view) =~ "#{date.day}"
  end

  test "when click in the next month", %{conn: conn} do
    user = UserFixture.create_user()

    conn =
      conn
      |> Guardian.Plug.sign_in(user)
      |> Plug.Test.init_test_session(current_user: user)

    {:ok, view, _html} = live(conn, Routes.page_path(conn, :index))
    month_name = Timex.now() |> Timex.shift(months: 1) |> Timex.format!("%B %Y", :strftime)
    assert render_click(view, "next-month") =~ month_name
  end

  test "when click in a specific day", %{conn: conn} do
    user = UserFixture.create_user()

    conn =
      conn
      |> Guardian.Plug.sign_in(user)
      |> Plug.Test.init_test_session(current_user: user)

    {:ok, view, _html} = live(conn, Routes.page_path(conn, :index))
    assert view |> element("li", "15") |> render_click() =~ "Day 15"
  end

  test "when click in the previous month", %{conn: conn} do
    user = UserFixture.create_user()

    conn =
      conn
      |> Guardian.Plug.sign_in(user)
      |> Plug.Test.init_test_session(current_user: user)

    {:ok, view, _html} = live(conn, Routes.page_path(conn, :index))
    month_name = Timex.now() |> Timex.shift(months: -1) |> Timex.format!("%B %Y", :strftime)
    assert render_click(view, "previous-month") =~ month_name
  end

  test "return to session when user is unauthenticated", %{conn: conn} do
    {:error, {_, %{to: to}}} = live(conn, "/")
    assert "/session" == to
  end
end
