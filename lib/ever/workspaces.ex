defmodule Ever.Workspaces do
  import Ecto.Query, warn: false

  alias Ever.Repo
  alias Ever.Workspaces.Workspace

  def create_workspace(attrs) do
    %Workspace{}
    |> Workspace.changeset(attrs)
    |> Repo.insert()
  end

  def read_workspaces do
    Repo.all(Workspace)
  end
end
