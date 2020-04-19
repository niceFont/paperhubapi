defmodule PaperhubapiWeb.UserController do
  use PaperhubapiWeb, :controller
  alias Paperhubapi.Repo
  alias Paperhubapi.User
  alias Paperhubapi.Helpers
  import Ecto.Query

  def logout(conn, _params) do
    conn
    |> fetch_session()
    |> clear_session()
    |> send_resp(204, "")
  end

  def session(conn, _params) do
    uid = conn |> fetch_session() |> get_session("uid")
    if(uid) do
      [{username, email}] = Repo.all(from u in "users",
      where: u.id == ^uid,
      select: {u.username, u.email})
      conn |> json(%{username: username, email: email})
    else
      conn |> send_resp(403, "")
    end

  end

  def register(conn, body) do
    hash = Helpers.hash_password(body["password"])
    user = Map.update(body, "password", nil, fn _ -> hash end)
    changeset = User.changeset(%User{}, user)

    case Repo.insert(changeset) do
      {:ok, _} ->
        conn |> json(%{"message" => "cool"})
      {:error, _} ->
        conn |> json(%{"error" => "error while saving data"})
    end
  end

  def login(conn, %{"username" => username, "password" => password}) do

    query = from u in "users",
            where: u.username == ^username,
            select: {u.password, u.id}
    result = Repo.all(query)

    if(result == []) do
      conn |> send_resp(403, "User does not exist")
    else
      [{hash, id}] = result
      case Helpers.password_match(password, hash) do
        true ->
          conn
          |> fetch_session()
          |> put_session(:uid, id)
          |> send_resp(200, "")
        false -> conn |> send_resp(400, "Password does not match this user")
      end
    end
  end

  def options(conn, _) do
    conn
    |> send_resp(204, "")
  end

end
