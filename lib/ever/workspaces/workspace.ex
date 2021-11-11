defmodule Ever.Workspaces.Workspace do
  use Ever.Schema
  import Ecto.Changeset

  schema "workspaces" do
    field :name, :string

    belongs_to(:workspace_manager, Ever.Accounts.User)

    has_many(:task, Ever.Tasks.Task)

    timestamps()
  end

  def changeset(workspace, attrs \\ %{}) do
    workspace
    |> cast(attrs, [:name, :workspace_manager_id])
    |> validate_required([:name, :workspace_manager_id])
    |> validate_length(:name, min: 2, max: 30, message: "at least 2 characters")
    |> unique_constraint(:name)
  end
end
