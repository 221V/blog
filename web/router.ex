defmodule Blog.Router do
  use Blog.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
	plug Blog.Plug.Locale, "en"
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Blog do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    #resources "/posts", PostController do
    #  post "/comment", PostController, :add_comment
    #end
    
    resources "/posts", PostController
    post "/posts/:post_id/comment", PostController, :add_comment
    
    #resources "/registrations", RegistrationController, only: [:new, :create]
    get "/registration", RegistrationController, :new
    post "/registration", RegistrationController, :create
    
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete
    
  end

  # Other scopes may use custom stacks.
  # scope "/api", Blog do
  #   pipe_through :api
  # end
end
