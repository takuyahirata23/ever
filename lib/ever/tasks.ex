defmodule Ever.Tasks do
  import Ecto.Query, warn: false

  alias Ever.Repo
  alias Ever.Tasks.Task

  def create_task(attrs) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end
end
