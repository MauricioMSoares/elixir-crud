defmodule ElixirCrudWeb.UserController do
  use ElixirCrudWeb, :controller

  alias ElixirCrud.Users
  alias ElixirCrud.Users.User

  action_fallback ElixirCrudWeb.FallbackController

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, :index, users: users)
  end

  def create(conn, _user_params) do
    user_params = conn.params

    with {:ok, %User{} = user} <- Users.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user.id}")
      |> render(:show, user: user)
    else
      {:error, reason} ->
        conn
        |> put_status(:bad_request)
        |> render(:error, reason: reason)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, :show, user: user)
  end

  def update(conn, %{"id" => id, "user" => _user_params}) do
    user_params = conn.params
    user = Users.get_user!(id)

    with {:ok, %User{} = updated_user} <- Users.update_user(user, user_params) do
      render(conn, :show, user: updated_user)
    else
      {:error, reason} ->
        conn
        |> put_status(:bad_request)
        |> render(:error, reason: reason)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)

    with {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
