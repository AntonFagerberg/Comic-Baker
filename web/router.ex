defmodule ComicBaker.Router do
  use Phoenix.Router

  scope "/" do
    # Use the default browser stack.
    pipe_through :browser

    get "/", ComicBaker.MainController, :main
    
    get "/library", ComicBaker.ReaderController, :get_library
    
    get "/signup", ComicBaker.UserController, :index
    post "/signup", ComicBaker.UserController, :create
    
    get "/login", ComicBaker.UserController, :get_login
    post "/login", ComicBaker.UserController, :post_login
    
    get "/upload_test", ComicBaker.UserController, :upload_test
    post "/upload_test", ComicBaker.UserController, :upload_test
  end

  # Other scopes may use custom stacks.
  # scope "/api" do
  #   pipe_through :api
  # end
end
