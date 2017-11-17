defmodule Takso.Allocation do
  use Takso.Web, :model

  schema "allocations" do
    field :status, :string
    belongs_to :taxi, Takso.Taxi, foreign_key: :taxi_id
    belongs_to :booking, Takso.Booking, foreign_key: :booking_id

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:status])
    |> validate_required([:status])
  end
end
