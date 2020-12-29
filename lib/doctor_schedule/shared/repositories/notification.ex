defmodule DoctorSchedule.Shared.Repositories.Notification do
  def create(notification), do: Mongo.insert_one(:mongo, "notifications", notification)
end
