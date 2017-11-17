defmodule Takso.BookingControllerTest do
use Takso.ConnCase
alias Takso.{Taxi, Repo}

  test "POST /bookings (case available)", %{conn: conn} do
    [%{location: "Kaubamaja", status: "busy", username: "juhan85"},
    %{location: "Kaubamaja", status: "available", username: "peeter88"}]
    |> Enum.map(fn taxi -> Taxi.changeset(%Taxi{}, taxi) end)
    |> Enum.each(fn changeset -> Repo.insert!(changeset) end)
    conn = post conn, "/bookings", %{booking: [pickup_address: "Liivi 2", dropoff_address: "Lõunakeskus"]}
    conn1 = get conn, redirected_to(conn)
    assert html_response(conn1, 200) =~ ~r/Your taxi will arrive in \d+ minutes/
  end
  test "POST /bookings (case unavailable)", %{conn: conn} do
    [%{location: "Kaubamaja", status: "busy", username: "juhan85"},
    %{location: "Kaubamaja", status: "busy", username: "peeter88"}]
    |> Enum.map(fn taxi -> Taxi.changeset(%Taxi{}, taxi) end)
    |> Enum.each(fn changeset -> Repo.insert!(changeset) end)
    conn = post conn, "/bookings", %{booking: [pickup_address: "Liivi 2", dropoff_address: "Lõunakeskus"]}
    conn1 = get conn, redirected_to(conn)
    assert html_response(conn1, 200) =~ ~r/We apologize/
  end

end