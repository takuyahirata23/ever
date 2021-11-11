defmodule Ever.Workspaces do
  import Ecto.Query, warn: false

  alias Ever.Repo
  alias Ever.Workspaces.Workspace

  def create_workspace(attrs) do
    %Workspace{}
    |> Workspace.changeset(attrs)
    |> Repo.insert()
  end

  def read_workspaces(manager_id) when is_binary(manager_id) do
    Workspace
    |> where([w], w.workspace_manager_id == ^manager_id)
    |> Repo.all()
  end

  def read_workspace(workspace_id) when is_binary(workspace_id) do
    Repo.get!(Workspace, workspace_id)
  end
end
