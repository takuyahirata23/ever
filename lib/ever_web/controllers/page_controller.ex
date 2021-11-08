defmodule EverWeb.PageController do
  use EverWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
