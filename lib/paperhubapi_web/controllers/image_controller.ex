defmodule PaperhubapiWeb.ImageController do
  use PaperhubapiWeb, :controller
  alias Paperhubapi.Repo
  alias Paperhubapi.Image
  import Ecto.Query

  def check_size(conn) do
      case read_body(conn, length: 4_000_000, read: 4_000_000) do
        {:ok, body, conn} ->
          {:ok, body, conn}
        {:more, _, _} ->
          {:user_error, "File too big"}
        {:error, _} ->
          {:error, "Error while reading File"}
      end
  end

  def check_image_content do

  end

  def upload_to_s3(uploadInfo) do
    name = UUID.uuid4()
    %{"file" => file, "type" => type} = uploadInfo
    with {:ok, bin} <- File.read(file.path),
        {:ok, _} <- ExAws.S3.put_object("paperhubbuck", "#{name}.#{type}", bin) |> ExAws.request
    do
      url = "https://paperhubbuck.s3.amazonaws.com/#{name}.#{type}"
      {:ok, url}
    else
      {:error, _} -> {:error, "Error while uploading to S3"}
      {:user_error, message} -> {:user_error, message}
    end
  end

  def save_to_db(conn, url, %{"type" => type, "width" => width, "height" => height, "category" => category}) do
    uid = conn |> fetch_session() |> get_session(:uid)
    {height, _} = Integer.parse(height)
    {width, _} = Integer.parse(width)
    {category, _} = Integer.parse(category)
    case Repo.insert(%Image{url: url, user_id: uid, type: type, height: height, width: width, category_id: category}) do
      {:ok, _} -> {:ok}
      {:error, message} ->
        IO.puts message
        {:error, "Error while inserting Image"}
    end
  end

  def upload(conn, params) do
    with {:ok, _, conn} <- check_size(conn),
          {:ok, url} <- upload_to_s3(params),
          {:ok} <- save_to_db(conn, url, params)
    do
      conn |> json(%{"url" => url})
    else
      {:error, message} ->
        IO.puts message
        conn |> send_resp(500, "Error while uploading Image.")
      {:user_error, message} -> conn |> send_resp(400, message)
    end
  end

  def get_all(conn, %{"page" => page}) do
    images = Repo.all(from i in "images",
                  limit: 25,
                  offset: 25 * ^page,
                  order_by: i.inserted_at,
                  select: i.url)
    conn |> json(%{images: images})
  end

  def get(conn, %{"page" => page}) do
    userID = conn |> fetch_session() |> get_session(:uid)

    images = Repo.all(from i in "images",
              where: i.user_id == ^userID,
              limit: 25,
              offset: 25 * ^page,
              select: %{id: i.id, url: i.url})

    conn |> json(%{images: images})
  end
  def get(conn, %{"page" => page, "user" => user}) do
    userID = Repo.all(from u in "users",
                      where: u.username == ^user,
                      select: u.id)
    images = Repo.all(from i in "images",
                      where: i.user_id == ^userID,
                      limit: 25,
                      offset: 25 * ^page,
                      select: %{id: i.id,url: i.url})

    conn |> json(%{images: images})
  end

  def delete(conn, %{"image" => imageID}) do
    image = Repo.get!(Image, imageID)
    case Repo.delete image do
      {:ok, _} -> conn |> send_resp(204, "")
      {:error, _} -> conn |> send_resp(500, "")
    end
  end

  def options(conn, _params) do
   conn
   |> send_resp(204, "")
  end

  def index(conn, _params) do
    json(conn, %{"hello" => "world"})
  end
end
