defmodule ChatApi.ChatApi.Friend do
  use Ecto.Schema
  import Ecto.Changeset


  schema "friends" do
    belongs_to :user1, ChatApi.ChatApi.User
    belongs_to :user2, ChatApi.ChatApi.User

    timestamps()
  end

  @doc false
  def changeset(friend, attrs) do
    friend
    |> cast(attrs, [:user1_id, :user2_id])
    |> validate_required([])
  end
end
