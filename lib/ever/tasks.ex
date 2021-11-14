defmodule Ever.Tasks do
  import Ecto.Query, warn: false
  import Ecto.Changeset

  alias Ever.Repo
  alias Ever.Tasks.Task

  def create_task(attrs) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  def read_task(task_id) when is_binary(task_id) do
    Repo.get_by(Task, id: task_id)
  end

  def update_task(task_id, params) do
    case read_task(task_id) do
      nil ->
        {:error, "Task not found"}

      task ->
        changeset = Task.changeset(task, params)

        case changeset.valid? do
          false -> {:error, changeset}
          true -> Repo.update(changeset)
        end
    end
  end

  def delete_task(task_id) when is_binary(task_id) do
    case read_task(task_id) do
      nil ->
        {:error, "Task not found"}

      task ->
        Repo.delete(task)
    end
  end
end
