defmodule Blog.PostController do
  use Blog.Web, :controller

  alias Blog.Post
  alias Blog.Comment
  
  plug :scrub_params, "post" when action in [:create, :update]
  plug :scrub_params, "comment" when action in [:add_comment]

  def index(conn, _params) do
    posts = Post
    |> Post.count_comments
    |> Repo.all
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    sess_user = Blog.Session.current_user(conn)
    if Blog.Session.logged_in?(sess_user) do
        if sess_user.type == 9 do
          changeset = Post.changeset(%Post{})
          render(conn, "new.html", changeset: changeset)
        else
          put_status(conn, 403)
          |> render(Blog.ErrorView, "403.html", %{})
        end
    else
      put_status(conn, 403)
      |> render(Blog.ErrorView, "403.html", %{})
    end
  end

  def create(conn, %{"post" => post_params}) do
    
    sess_user = Blog.Session.current_user(conn)
    if Blog.Session.logged_in?(sess_user) do
      if sess_user.type == 9 do
        
        changeset = Post.changeset(%Post{}, post_params)

        if changeset.valid? do
          Repo.insert(changeset)

          conn
          |> put_flash(:info, "Post created successfully.")
          |> redirect(to: post_path(conn, :index))
        else
          render(conn, "new.html", changeset: changeset)
        end
        
      else
        put_status(conn, 403)
        |> render(Blog.ErrorView, "403.html", %{})
      end
    else
      put_status(conn, 403)
      |> render(Blog.ErrorView, "403.html", %{})
    end
  end
  
  def show(conn, %{"id" => id}) do
    sess_user = Blog.Session.current_user(conn)
    sess_user_logged = Blog.Session.logged_in?(sess_user)
    
    post = Repo.get(Post, id) |> Repo.preload([:comments])
    changeset = Comment.changeset(%Comment{})
    #IO.inspect changeset
    render(conn, "show.html", post: post, changeset: changeset, sess_user: sess_user, sess_user_logged: sess_user_logged)
  end

  def edit(conn, %{"id" => id}) do
    sess_user = Blog.Session.current_user(conn)
    if Blog.Session.logged_in?(sess_user) do
      if sess_user.type == 9 do
    
        post = Repo.get!(Post, id)
        changeset = Post.changeset(post)
        render(conn, "edit.html", post: post, changeset: changeset)
      else
        put_status(conn, 403)
        |> render(Blog.ErrorView, "403.html", %{})
      end
    else
      put_status(conn, 403)
      |> render(Blog.ErrorView, "403.html", %{})
    end
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    
    sess_user = Blog.Session.current_user(conn)
    if Blog.Session.logged_in?(sess_user) do
      if sess_user.type == 9 do
        
        post = Repo.get!(Post, id)
        changeset = Post.changeset(post, post_params)

        if changeset.valid? do
          Repo.update(changeset)
        
          conn
          |> put_flash(:info, "Post updated successfully.")
          |> redirect(to: post_path(conn, :index))
        else
          render(conn, "edit.html", post: post, changeset: changeset)
        end
        
      else
        put_status(conn, 403)
        |> render(Blog.ErrorView, "403.html", %{})
      end
    else
        put_status(conn, 403)
        |> render(Blog.ErrorView, "403.html", %{})
    end
    
    
  end

  def delete(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)
    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: post_path(conn, :index))
  end
  
  def add_comment(conn, %{"comment" => comment_params, "post_id" => post_id}) do
    
    sess_user = Blog.Session.current_user(conn)
    sess_user_logged = Blog.Session.logged_in?(sess_user)
    if sess_user_logged do
    
    IO.inspect comment_params
    
      changeset = Comment.changeset(%Comment{}, Map.put(Map.put(comment_params, "name", sess_user.email), "post_id", post_id))
      post = Repo.get(Post, post_id) |> Repo.preload([:comments])

      if changeset.valid? do
        Repo.insert(changeset)

        conn
        |> put_flash(:info, "Comment added.")
        |> redirect(to: post_path(conn, :show, post))
      else
        render(conn, "show.html", post: post, changeset: changeset, sess_user: sess_user, sess_user_logged: sess_user_logged)
      end
    
    else
      put_status(conn, 403)
      |> render(Blog.ErrorView, "403.html", %{})
    end
    
  end
  
end
