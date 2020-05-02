defmodule Paperhubapi.Repo.Migrations.Metainfo do
  use Ecto.Migration

  def change do
    alter table(:images) do
      add :height, :integer
      add :width, :integer
      add :type, :string
    end
  end
end
