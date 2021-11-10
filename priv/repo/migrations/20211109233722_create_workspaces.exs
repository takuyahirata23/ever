defmodule Ever.Repo.Migrations.CreateWorkspaces do
  use Ecto.Migration

  def change do
    create table(:workspaces, primary_key: false) do
      add :id, :binary_id, primary_key: true, null: false
      add :name, :string, null: false

      timestamps()
    end

    create unique_index(:workspaces, [:name])
  end
end
