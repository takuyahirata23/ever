defmodule Ever.Repo.Migrations.AddWorkspaceManagerToWorkspaces do
  use Ecto.Migration

  def change do
    alter table(:workspaces) do
      add :workspace_manager_id, references(:users, on_delete: :delete_all), null: false
    end

    create index(:workspaces, [:workspace_manager_id])
  end
end
