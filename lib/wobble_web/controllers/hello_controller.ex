defmodule WobbleWeb.HelloController do
  use WobbleWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end
