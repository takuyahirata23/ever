defmodule Ever.Workspaces.Workspace do
  use Ever.Schema
  import Ecto.Changeset

  schema "workspaces" do
    field :name, :string

    timestamps()
  end

  def workspace_changeset(workspace, attrs \\ %{}) do
    workspace
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_length(:name, min: 2, max: 30, message: "at least 2 characters")
  end
end
