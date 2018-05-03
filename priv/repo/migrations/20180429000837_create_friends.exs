defmodule ChatApi.Repo.Migrations.CreateFriends do
  use Ecto.Migration

  def change do
    create table(:friends) do
      add :user1_id, references(:users, on_delete: :nothing), null: false
      add :user2_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:friends, [:user1_id])
    create index(:friends, [:user2_id])
    create index(:friends, [:user1_id, :user2_id], unique: true)
  end
end
