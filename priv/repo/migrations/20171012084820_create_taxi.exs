defmodule Takso.Repo.Migrations.CreateTaxi do
  use Ecto.Migration

  def change do
    create table(:taxis) do
      add :username, :string
      add :location, :string
      add :status, :string

      timestamps()
    end
  end
end
