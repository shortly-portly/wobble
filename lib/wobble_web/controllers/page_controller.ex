defmodule WobbleWeb.PageController do
  use WobbleWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    conn
    |> put_root_layout("bare.html")
    |> render(:home)
  end
end
