defmodule Paperhubapi.Repo.Migrations.CreateImages do
  use Ecto.Migration

  def change do
    create table(:images) do
      add :url, :string
      add :user_id, :integer

      timestamps()
    end

  end
end
