defmodule Ever.Workspaces.WorkspaceInvite do
  use Ever.Schema
  import Ecto.Changeset

  schema "workspace_invited" do
    field :accepted, :boolean

    belongs_to(:workspace, Ever.Workspaces.Workspace)
    belongs_to(:inviter, Ever.Accounts.User)

    timestamps()
  end

  def changeset(workspace_invite, attrs \\ %{}) do
    workspace_invite
    |> cast(attrs, [:inviter_id, :invitee_id, :workspace_id, :accepted])
    |> validate_required([:inviter_id, :invitee_id, :workspace_id, :accepted])
  end
end
