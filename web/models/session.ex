defmodule Blog.Session do
  use Blog.Web, :model
  alias Blog.User

  def login(params, repo) do
    #user = if params["email"] =~ ~r/@/ do
      repo.get_by(User, email: String.downcase(params["email"]))
    #else
    #  get_user_by_nickname(repo, String.downcase(params["email"]))
    #end
    
    case authenticate(user, params["password"]) do
      true -> {:ok, user}
      _    -> :error
    end
  end
  
  defp get_user_by_nickname(repo, nickname) do
    #query = from u in "users",
    #      where: fragment("LOWER(\"nickname\")") == ^nickname,
    #      select: fragment("\"id\", \"nickname\", \"email\", \"crypted_password\", \"type\", \"inserted_at\", \"updated_at\"")
    #query |> first([]) |> repo.one
    
    #query = from u in "users",
    #      where: fragment("lower(?) = ?", u."nickname", ^nickname),
    #      select: fragment("u0.\"id\", u0.\"nickname\", u0.\"email\", u0.\"crypted_password\", u0.\"type\", u0.\"inserted_at\", u0.\"updated_at\"")
    #rez = repo.all(query)
    #IO.inspect rez
    
    #nickname = String.replace(nickname, ~r/[^\w-+\*]/, "")
    #rez = Ecto.Adapters.SQL.query(repo, "SELECT u0.\"id\", u0.\"nickname\", u0.\"email\", u0.\"crypted_password\", u0.\"type\", u0.\"inserted_at\", u0.\"updated_at\" FROM \"users\" AS u0 WHERE (LOWER(u0.\"nickname\") = '$1') LIMIT 1", [nickname])
    #IO.inspect rez
    
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
