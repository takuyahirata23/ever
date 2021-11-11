defmodule Ever.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks, primary_key: false) do
      add :id, :binary_id, primary_key: true, null: false
      add :name, :text, null: false
      add :description, :text
      add :status, :string, null: false

      add :task_manager_id, references(:users, on_delete: :delete_all), null: false
      add :workspace_id, references(:workspaces, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:tasks, [:workspace_id])
  end
end
