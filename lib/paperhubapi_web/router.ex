defmodule PaperhubapiWeb.Router do
  use PaperhubapiWeb, :router

  pipeline :api do
    plug :cors
    plug :accepts, ["json"]
    #plug CORSPlug, [origin: "http://localhost:8000"]
    #plug :authenticate
  end

  pipeline :upload do
    plug :cors
    plug :authorize
    plug :accepts, ["jpeg", "png"]
    #plug :check_size
    #temp upload
    #check file content using api
    #upload to s3
    #save data to database
    #return signed url
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
    pipe_through :api

    post "/register", UserController, :register
    options "/register", UserController, :options
    post "/login", UserController, :login
    options "/login", UserController, :options
  end

  scope "/api/images", PaperhubapiWeb do
    pipe_through :upload

    get "/:page", ImageController, :get_all
    options "/:page", ImageController, :options
    post "/", ImageController, :upload
    options "/", ImageController, :options
  end

  scope "/api/me", PaperhubapiWeb do
    pipe_through :api

    get "/session", UserController, :session
    delete "/session", UserController, :logout
    options "/session", UserController, :options
  end

  # Other scopes may use custom stacks.
  # scope "/api", PaperhubapiWeb do
  #   pipe_through :api
  # end
end
