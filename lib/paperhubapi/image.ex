defmodule Paperhubapi.Image do
  use Ecto.Schema
  import Ecto.Changeset

  schema "images" do
    field :url, :string
    belongs_to :user, Paperhubapi.User
    belongs_to :category, Paperhubapi.Category
    timestamps()
  end

  @doc false
  def changeset(image, attrs) do
    image
    |> cast(attrs, [:url, :user_id])
    |> validate_required([:url, :user_id])
  end
end
