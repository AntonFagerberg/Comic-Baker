defmodule ComicBaker.Router do
  use Phoenix.Router

  scope "/" do
    # Use the default browser stack.
    pipe_through :browser

    get "/", ComicBaker.PageController, :index, as: :pages
    resources "users", ComicBaker.UserController
  end

  # Other scopes may use custom stacks.
  # scope "/api" do
  #   pipe_through :api
  # end
end
