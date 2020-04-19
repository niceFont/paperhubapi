defmodule Paperhubapi.Repo.Migrations.AddCategoriesReference do
  use Ecto.Migration

  def change do
    alter table(:images) do
      modify :user_id, references(:users, on_delete: :delete_all)
      add :category_id, references(:categories, on_delete: :nothing)
    end

  end
end
