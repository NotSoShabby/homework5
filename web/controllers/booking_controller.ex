defmodule Takso.BookingController do
  use Takso.Web, :controller
  import Ecto.Query, only: [from: 2]
  import Canary.Plugs
  alias Ecto.{Changeset,Multi}
  alias Takso.{Taxi,Booking,Repo,Allocation}

  plug :authorize_resource, model: Booking, non_id_actions: [:summary]

  def index(conn, _params) do
    bookings = Repo.all(from b in Booking, where: b.user_id == ^conn.assigns.current_user.id)
    render conn, "index.html", bookings: bookings
  end
  
  def new(conn, _params) do
    render conn, "new.html", changeset: Booking.changeset(%Booking{})
  end

  def summary(conn, _params) do
    query = from t in Taxi,
            join: a in Allocation, on: t.id == a.taxi_id,
            group_by: t.username,
            where: a.status == "accepted",
            select: {t.username, count(a.id)}
    render conn, "summary.html", tuples: Repo.all(query)
  end

  def create(conn, %{"booking" => booking_params}) do
    user = conn.assigns.current_user

    struct = build_assoc(user, :bookings, Enum.map(booking_params, fn({key, value}) -> {String.to_atom(key), value} end))
    changeset = Booking.changeset(struct)
                |> Changeset.put_change(:status, "open")

    booking = Repo.insert!(changeset)

    query = from t in Taxi, where: t.status == "available", select: t
    available_taxis = Repo.all(query)
    if length(available_taxis) > 0 do
      taxi = List.first(available_taxis)

      allocation_changeset =
        Allocation.changeset(%Allocation{}, %{status: "accepted"})
        |> Changeset.put_change(:booking_id, booking.id) 
        |> Changeset.put_change(:taxi_id, taxi.id)

      Multi.new
      |> Multi.insert(:allocation, allocation_changeset)
      |> Multi.update(:taxi, Taxi.changeset(taxi) |> Changeset.put_change(:status, "busy"))
      |> Multi.update(:booking, Booking.changeset(booking) |> Changeset.put_change(:status, "allocated"))
      |> Repo.transaction

      conn
      |> put_flash(:info, "Your taxi will arrive in 5 minutes")
      |> redirect(to: booking_path(conn, :index))
    else
      Booking.changeset(booking) |> Changeset.put_change(:status, "rejected")
      |> Repo.update

      conn
      |> put_flash(:error, "We apologize, we cannot serve your request in this moment")
      |> redirect(to: booking_path(conn, :index))
    end
  end
end
