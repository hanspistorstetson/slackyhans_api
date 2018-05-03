defmodule ChatApiWeb.UserController do
  use ChatApiWeb, :controller
  import Ecto.Query
  alias ChatApi.ChatApi.User

  def create(conn, params) do
    changeset = User.registration_changeset(%User{}, params)

    case ChatApi.Repo.insert(changeset) do
      {:ok, user} ->
        {:ok, jwt, _claims} = ChatApi.Auth.Guardian.encode_and_sign(user)
        new_conn = ChatApi.Auth.Guardian.Plug.sign_in(conn, user)

        new_conn
        |> put_status(:created)
        |> render(ChatApiWeb.SessionView, "show.json", user: user, jwt: jwt)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ChatApiWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def rooms(conn, _pasrams) do
    current_user = ChatApi.Auth.Guardian.Plug.current_resource(conn)
    rooms = ChatApi.Repo.all(Ecto.assoc(current_user, :rooms))
    render(conn, ChatApiWeb.RoomView, "index.json", %{rooms: rooms})
  end

  def getUsers(conn, _params) do
    user = ChatApi.Auth.Guardian.Plug.current_resource(conn)
    query = Ecto.Query.from(u in ChatApi.ChatApi.User, where: u.email != ^user.email)
    users = ChatApi.Repo.all(query)
    query = (Ecto.assoc(user, :friends))

    ChatApi.ChatApi.User
    |> join(:inner, [u], c in assoc(u, :friends))
    |> ChatApi.Repo.all
    |> IO.inspect

    render(conn, ChatApiWeb.UserView, "index.json", %{users: users})
  end
end
