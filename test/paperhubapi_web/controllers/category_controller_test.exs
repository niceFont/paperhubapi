defmodule PaperhubapiWeb.CategoryControllerTest do
  use PaperhubapiWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/api/categories")
    assert json_response(conn, 200) == []
  end
end
