defmodule Takso.Repo.Migrations.CreateAllocation do
  use Ecto.Migration

  def change do
    create table(:allocations) do
      add :status, :string
      add :taxi_id, references(:taxis)
      add :booking_id, references(:bookings)

      timestamps()
    end

    create index(:allocations, [:taxi_id])
    create index(:allocations, [:booking_id])
  end
end
