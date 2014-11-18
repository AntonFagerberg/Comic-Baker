defmodule ComicBaker.Router do
  use Phoenix.Router

  scope alias: ComicBaker do
    pipe_through :browser

    get  "/",                           UserController, :get_login
    get  "/login",                      UserController, :get_login
    post "/login",                      UserController, :post_login
    get  "/signup",                     UserController, :get_signup
    post "/signup",                     UserController, :post_signup
    get  "/logout",                     UserController, :logout

    get  "/library",                    ReaderController, :library
    post "/library/upload/single",      ReaderController, :upload
    post "/library/upload/multi",       ReaderController, :upload_multi
    get  "/library/book/:id/page/:img", ReaderController, :page
    get  "/library/book/:id/save/:img", ReaderController, :save_page
    get  "/library/book/:id/pages",     ReaderController, :page_urls
    get  "/library/book/:id/cover",     ReaderController, :cover
    get  "/library/book/:id/read",      ReaderController, :read

    get  "/settings",                   SettingsController, :settings
    post "/settings",                   SettingsController, :change_password
  end
end
