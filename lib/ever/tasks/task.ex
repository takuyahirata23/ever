defmodule Ever.Tasks.Task do
  use Ever.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :name, :string
    field :description, :string
    field :status, Ecto.Enum, values: [:todo, :in_progress, :done]

    belongs_to(:workspace, Ever.Workspaces.Workspace)
    belongs_to(:task_manager, Ever.Accounts.User)

    timestamps()
  end

  def changeset(task, attrs \\ %{}) do
    task
    |> cast(attrs, [:name, :description, :status, :task_manager_id, :workspace_id])
    |> validate_required([:name, :status, :task_manager_id, :workspace_id])
    |> validate_length(:name, min: 2)
    |> validate_inclusion(:status, [:todo, :in_progress, :done])
  end
end
