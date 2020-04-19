defmodule PaperhubapiWeb.Router do
  use PaperhubapiWeb, :router

  pipeline :api_pub do
    plug :cors
    plug :accepts, ["json"]
  end

  pipeline :api_priv do
    plug :cors
    plug :authorize
    plug :accepts, ["json"]
  end

  pipeline :image_priv do
    plug :cors
    plug :authorize
    plug :accepts, ["jpeg", "png"]
  end


  pipeline :image_pub do
    plug :cors
    plug :accepts, ["jpeg", "png"]
  end

  def authorize(conn, _opts) do
    uid = conn |> fetch_session() |> get_session(:uid)
    if is_nil(uid) do
      conn |> send_resp(403, "Unauthorized") |> halt()
    else
      conn
    end
  end

  def authenticate(conn, _opts) do
    token = List.first(get_req_header(conn, "api-key"))
    case token == "WOW" do
      true -> conn
      false -> conn |> json(%{"error" => "apikey missing"}) |> halt()
    end
  end

  def cors(conn, _opts) do
    conn |> register_before_send(fn conn ->
     conn
      |> put_resp_header("Access-Control-Allow-Origin", "http://localhost:8080")
      |> put_resp_header("Access-Control-Allow-Methods", "POST, GET, DELETE, OPTIONS")
      |> put_resp_header("Access-Control-Allow-Headers", "X-PINGOTHER,Content-Type,api-key,Authorization,Accept,Origin,User-Agent,DNT,Cache-Control,X-Mx-ReqToken,Keep-Alive,X-Requested-With,If-Modified-Since,X-CSRF-Token")
      |> put_resp_header("Access-Control-Allow-Credentials", "true")
      |> put_resp_header("Access-Control-Max-Age", "86400")
    end)
  end

  scope "/api/user", PaperhubapiWeb do
    pipe_through :api_pub

    post "/register", UserController, :register
    options "/register", UserController, :options
    post "/login", UserController, :login
    options "/login", UserController, :options
  end


  scope "/api/images", PaperhubapiWeb do
    pipe_through :image_pub

    get "/:page", ImageController, :get_all
    options "/:page", ImageController, :options
  end


  scope "/api/me", PaperhubapiWeb do
    pipe_through :api_pub

    options "/images/:page", ImageController, :options
    options "/images", ImageController, :options
    options "/session", UserController, :options
  end

  # PRIVATE ENDPOINTS

  scope "/api/images", PaperhubapiWeb do
    pipe_through :image_priv

    post "/", ImageController, :upload
    options "/", ImageController, :options
    get "/:page/:user", ImageController, :get
    options "/:page/:user", ImageController, :options
  end
  scope "/api/me", PaperhubapiWeb do
    pipe_through :api_priv

    get "/session", UserController, :session
    delete "/session", UserController, :logout
    get "/images/:page", ImageController, :get
    delete "/images", ImageController, :delete
  end
  # Other scopes may use custom stacks.
  # scope "/api", PaperhubapiWeb do
  #   pipe_through :api
  # end
end
