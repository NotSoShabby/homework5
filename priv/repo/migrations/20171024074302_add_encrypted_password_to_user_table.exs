defmodule Takso.Repo.Migrations.AddEncryptedPasswordToUserTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :encrypted_password, :string
      remove :password
    end
  end
end
