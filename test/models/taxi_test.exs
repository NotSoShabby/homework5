defmodule Takso.TaxiTest do
  use Takso.ModelCase

  alias Takso.Taxi

  @valid_attrs %{location: "some location", status: "some status", username: "some username"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Taxi.changeset(%Taxi{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Taxi.changeset(%Taxi{}, @invalid_attrs)
    refute changeset.valid?
  end
end
