defmodule Takso.Booking do
  use Takso.Web, :model

  schema "bookings" do
    field :pickup_address, :string
    field :dropoff_address, :string
    field :status, :string
    belongs_to :user, Takso.User

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:pickup_address, :dropoff_address, :status])
    |> validate_required([:pickup_address, :dropoff_address])
  end
end
