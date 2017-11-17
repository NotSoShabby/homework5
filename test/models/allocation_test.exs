defmodule Takso.AllocationTest do
  use Takso.ModelCase

  alias Takso.Allocation

  @valid_attrs %{status: "some status"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Allocation.changeset(%Allocation{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Allocation.changeset(%Allocation{}, @invalid_attrs)
    refute changeset.valid?
  end
end
