defmodule Blog.SessionController do
  use Blog.Web, :controller
  #alias Blog.User

  def new(conn, _params) do
    render(conn, "new.html")
  end
  
  def create(conn, %{"session" => session_params}) do
    case Blog.Session.login(session_params, Blog.Repo) do
      {:ok, user} ->
        #IO.inspect user
        conn
        |> put_session(:uid, user.id)
        |> put_flash(:info, "Logged in")
        |> redirect(to: "/")
      :error ->
        conn
        |> put_flash(:info, "Wrong email or password")
        |> render("new.html")
    end
  end
  
  def delete(conn, _) do
    conn
    |> delete_session(:uid)
    |> put_flash(:info, "Logged out")
    |> redirect(to: "/")
  end
  
end
