defmodule EverWeb.WorkspaceLive do
  use EverWeb, :live_view

  import EverWeb.LiveHelpers

  alias Ever.Workspaces
  alias Ever.Tasks
  alias Ever.Tasks.Task

  def mount(%{"workspace_id" => id}, session, socket) do
    socket = assign_current_user(socket, session)
    workspace = Workspaces.read_workspace(id)

    task_changeset = Task.changeset(%Task{})

    {:ok,
     assign(socket,
       workspace: workspace,
       show_modal: false,
       task_changeset: task_changeset,
       workspace_id: id
     )}
  end

  def render(assigns) do
    ~H"""
    <section class="flex">
    <aside class="p-6 max-w-xs w-3/12" >
    <h1 class="font-bold text-3xl">
    <%= @workspace.name %>
    </h1>
    <div>
    <button 
    phx-click="toggle-modal" 
    class="p-2 bg-blue-500 rounded-md text-white text-sm"
    >
    Create Task
    </button>
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
              <p class="text-center font-medium text-2xl my-8">Task</p>
              <.form let={f} for={@task_changeset} action="#" phx_submit="submit" %>
                <div class="flex flex-col gap-y-6">
                  <div class="flex flex-col gap-y-1.5">
                    <%= label f, :name  %>
                    <%= text_input f, :name, required: true, class: "border border-black rounded-md p-2", autocomplete: "off" %>
                    <%= error_tag f, :name %>
                  </div>
                  <div class="flex flex-col gap-y-1.5">
                    <%= label f, :description  %>
                    <%= text_input f, :description, 
                      required: true, 
                      class: "border border-black rounded-md p-2",
                      autocomplete: "off"
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
        </aside>
        <div class="p-6">
        <%= if Enum.empty?(@workspace.tasks) == false do %>
        <ul>
          <%= for task <- @workspace.tasks do %>
            <li><%= task.name %></li>
          <% end %>
        </ul>
        <% else %>
          <p>No Tasks<p>
        <% end %>
        </div>
    </section>
    """
  end

  def handle_event("toggle-modal", _, socket) do
    {:noreply, update(socket, :show_modal, &(!&1))}
  end

  def handle_event("submit", %{"task" => task}, socket) do
    refs = %{
      "workspace_id" => socket.assigns.workspace_id,
      "task_manager_id" => socket.assigns.current_user.id
    }

    case Tasks.create_task(Map.merge(task, refs)) do
      {:error, task_changeset} ->
        {:noreply, assign(socket, task_changeset: task_changeset)}

      {:ok, task} ->
        tasks = Enum.concat(socket.assigns.workspace.tasks, [task])

        workspace = socket.assigns.workspace
        workspace = Map.replace(workspace, :tasks, tasks)

        {:noreply, assign(socket, show_modal: false, workspace: workspace)}
    end
  end

  defp get_status do
    [todo: :todo, "in progress": :in_progress, done: :done]
  end
end
