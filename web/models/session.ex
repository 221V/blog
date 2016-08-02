defmodule Blog.Session do
  #use Blog.Web, :model
  alias Blog.User

  def login(params, repo) do
    user = repo.get_by(User, email: String.downcase(params["email"]))
    case authenticate(user, params["password"]) do
      true -> {:ok, user}
      _    -> :error
    end
  end

  defp authenticate(user, password) do
    case user do
      nil -> false
      _   -> Comeonin.Bcrypt.checkpw(password, user.crypted_password)
    end
  end
  
  def current_user(conn) do
    id = Plug.Conn.get_session(conn, :uid)
    if id, do: Blog.Repo.get(User, id)
  end
  
  #def logged_in?(conn), do: !!current_user(conn)
  def logged_in?(session_user) do
    case session_user do
      nil -> false
      _   -> true
    end
  end
  
end
