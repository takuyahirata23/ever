defmodule Ever.Repo.Migrations.CreateWorkspaceInvites do
  use Ecto.Migration

  def change do
    create table(:workspace_invites, primary_key: false) do
      add :id, :binary_id, primary_key: true, null: false
      add :inviter_id, references(:users, on_delete: :delete_all), null: false
      add :invitee_id, references(:users, on_delete: :delete_all), null: false
      add :workspace_id, references(:workspaces, on_delete: :delete_all), null: false
      add :accepted, :boolean, default: false, null: false

      timestamps()
    end

    create index(:workspace_invites, [:inviter_id, :invitee_id])
  end
end
