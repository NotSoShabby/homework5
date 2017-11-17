defmodule Takso.BookingTest do
  use Takso.ModelCase

  alias Takso.Booking

  test "Dropoff address must be there" do
    changeset = Booking.changeset(%Booking{}, %{pickup_address: "Liivi 2"})
    assert Keyword.has_key? changeset.errors, :dropoff_address
  end

  test "Pickup address must be there" do
    changeset = Booking.changeset(%Booking{}, %{dropoff_address: "Liivi 2"})
    assert Keyword.has_key? changeset.errors, :pickup_address
  end

  # test "Pickup and drop off addresses must be different" do
  #   changeset = Booking.changeset(%Booking{}, %{pickup_address: "Liivi 2", dropoff_address: "Liivi 2"})
  #   refute changeset.valid?
  # end
end
