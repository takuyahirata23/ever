defmodule EverWeb.TaskLive do
  use EverWeb, :live_view

  import Ecto.Changeset

  alias EverWeb.LiveHelpers
  alias Ever.Tasks.Task

  alias Ever.Tasks

  def mount(%{"task_id" => task_id}, session, socket) do
    socket = LiveHelpers.assign_current_user(socket, session)
    task = Tasks.read_task(task_id)

    changeset = create_task_changeset(task)

    {:ok, assign(socket, show_modal: false, task: task, changeset: changeset)}
  end

  def render(assigns) do
    ~H"""
      <div class="max-w-5xl w-11/12 mx-auto">
          <EverWeb.HeaderComponent.header current_user={@current_user} />
        <div class="py-6">
          <div class="flex justify-between">
            <h2 class="text-2xl"><%= @task.name %></h2>
            <EverWeb.StatusComponent.status status={@task.status} />
          </div>
          <p class="mt-6"><%= @task.description %></p>
          <div class="flex gap-x-4 w-1/4 mt-24 ml-auto">
            <button phx-click="toggle-modal" class="py-1 px-2 bg-green-500 rounded-md text-white flex-1">Edit</button>
            <button phx-click="delete-task" class="py-1 px-2 bg-yellow-500 rounded-md text-white flex-1">Delete</button>
          </div>
        </div>
        <%= if @show_modal do %>
          <div class="phx-modal" 
            phx-window-keydown="toggle-modal"
            phx-key="escape"
            phx-capture-click="toggle-modal"
          >
            <div class="phx-modal-content w-1/2">
              <div class="phx-modal-close">
                <a href="#" phx-click="toggle-modal">
                  &times;
                </a>
              </div>
              <div>
              <p class="text-center font-medium text-2xl my-8">Edit Task</p>
              <.form let={f} for={@changeset} action="#" phx_submit="submit" %>
                <div class="flex flex-col gap-y-6">
                  <div class="flex flex-col gap-y-1.5">
                    <%= label f, :name  %>
                    <%= text_input f, :name, required: true, class: "border border-black rounded-md p-2", autocomplete: "off" %>
                    <%= error_tag f, :name %>
                  </div>
                  <div class="flex flex-col gap-y-1.5">
                    <%= label f, :description  %>
                    <%= textarea f, :description, 
                      required: true, 
                      class: "border border-black rounded-md p-2",
                      autocomplete: "off",
                      rows: 4
                    %>
                    <%= error_tag f, :description %>
                  </div>
                  <div class="flex flex-col gap-y-1.5">
                    <%= label f, :status  %>
                    <%= select f, :status, get_status(), class: "border border-black rounded-md p-2" %>
                  </div>
                  <div class="flex justify-center mt-6">
                    <%= submit "Create Task", class: "w-1/2 p-4 bg-blue-500 rounded-md text-white" %>
                  </div>
                </div>
              </.form>
              </div>
            </div>
          </div>
        <% end %>

      </div>
    """
  end

  def handle_event("toggle-modal", _, socket) do
    {:noreply, update(socket, :show_modal, fn x -> !x end)}
  end

  def handle_event("submit", %{"task" => task}, socket) do
    case Tasks.update_task(socket.assigns.task.id, task) do
      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, error_changeset} = apply_action(changeset, :update)

        {:noreply, assign(socket, changeset: error_changeset)}

      {:error, message} ->
        socket =
          socket
          |> put_flash(:error, message)
          |> assign(show_modal: false)

        clear_flash()

        {:noreply, socket}

      {:ok, task} ->
        changeset = create_task_changeset(task)

        socket =
          put_flash(socket, :info, "Updated!")
          |> assign(changeset: changeset, show_modal: false, task: task)

        clear_flash()

        {:noreply, socket}
    end
  end

  def handle_event("delete-task", _, socket) do
    case Tasks.delete_task(socket.assigns.task.id) do
      {:error} ->
        socket |> put_flash(:error, "Something went wrong...")

      {:ok, task} ->
        redirect(socket, to: "/dashboard/workspaces/#{task.workspace_id}")

        {:noreply,
         push_redirect(socket,
           to: Routes.live_path(socket, EverWeb.WorkspaceLive, task.workspace_id)
         )}
    end
  end

  def handle_info(:clear_flash, socket) do
    socket = socket |> clear_flash()
    {:noreply, socket}
  end

  defp get_status do
    [todo: :todo, "in progress": :in_progress, done: :done]
  end

  defp create_task_changeset(task) do
    Task.changeset(%Task{}, %{
      name: task.name,
      description: task.description,
      status: task.status
    })
  end

  defp clear_flash do
    :timer.send_after(3000, self(), :clear_flash)
  end
end
