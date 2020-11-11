defmodule DoctorScheduleWeb.Api.SessionView do
  use DoctorScheduleWeb, :view
  alias DoctorScheduleWeb.Api.UserView

  def render("show.json", %{user: user, token: token}) do
    %{
      user: UserView.render("show.json", user: user),
      token: token
    }
  end
end
