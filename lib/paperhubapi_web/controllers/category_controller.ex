defmodule PaperhubapiWeb.CategoryController do
  use PaperhubapiWeb, :controller
  alias Paperhubapi.Repo
  import Ecto.Query

  def get_all(conn, _params) do
    categories = Repo.all(from c in "categories",
             select: %{"id" => c.id, "name" => c.name})
    conn |> json(categories)
  end

  def options(conn, _params) do
   conn
   |> send_resp(204, "")
  end
end
