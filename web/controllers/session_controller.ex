defmodule Takso.SessionController do
    use Takso.Web, :controller

    alias Takso.{Repo,User}
  
    def new(conn, _params) do
      render conn, "new.html"
    end

    def create(conn, %{"session" => %{"username" => username, "password" => password}}) do
      user = Repo.get_by(User, username: username)
      case Takso.Authentication.check_credentials(conn, user, password) do
        {:ok, conn} ->    
              conn
              |> Guardian.Plug.sign_in(user)
              |> put_flash(:info, "Welcome #{username}")
              |> redirect(to: page_path(conn, :index))
        {:error, conn} ->
              conn
              |> put_flash(:error, "Bad credentials")
              |> render("new.html")
      end    
    end
    
    def delete(conn, _) do
      conn
      |> Guardian.Plug.sign_out
      |> redirect(to: page_path(conn, :index))
    end

    def unauthorized(conn) do
      conn
      |> put_flash(:error, "Nothing to see there")
      |> redirect(to: page_path(conn, :index))
      |> halt
    end

    def unauthenticated(conn, _) do
      conn
      |> put_flash(:error, "You are not logged in")
      |> redirect(to: page_path(conn, :index))
      |> halt
    end

end