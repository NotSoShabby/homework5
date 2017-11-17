defmodule Takso.User do
  use Takso.Web, :model

  schema "users" do
    field :name, :string
    field :username, :string
    field :password, :string, virtual: true
    field :encrypted_password, :string
    field :role, :string
    has_many :bookings, Takso.Booking
    
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :username, :password, :role])
    |> validate_required([:name, :username, :password, :role])
    |> encrypt_password
  end

  def encrypt_password(changeset) do
    if changeset.valid? do
      IO.inspect(changeset)
      put_change(changeset, :encrypted_password, Comeonin.Pbkdf2.hashpwsalt(changeset.changes[:password]))
    else
      changeset
    end
  end
end
