defmodule EverWeb.WorkspaceLive do
  use EverWeb, :live_view

  import Ecto.Changeset
  import EverWeb.LiveHelpers

  alias Ever.Workspaces
  alias Ever.Tasks
  alias Ever.Tasks.Task
  alias EverWeb.LiveHelpers

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
    <aside class="p-8 max-w-xs w-3/12" >
    <%= live_patch "<- Back", to: Routes.live_path(@socket, EverWeb.DashboardLive) %>
    <h1 class="font-bold text-3xl mt-4">
    <%= @workspace.name %>
    </h1>
    <div>
    <button 
    phx-click="toggle-modal" 
    class="py-2 px-4 bg-blue-500 rounded-md text-white text-sm block mt-4"
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
              <p class="text-center font-medium text-2xl my-6 ">Create Task</p>
              <.form let={f} for={@task_changeset} action="#" phx_submit="submit" %>
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
        </aside>
        <div class="p-8">
        <%= if Enum.empty?(@workspace.tasks) == false do %>
        <ul class="grid grid-cols-2 gap-6">
          <%= for task <- @workspace.tasks do %>
          <li class="p-6  rounded-lg shadow border border-gray-300">
            <%= live_patch to: Routes.live_path(@socket, EverWeb.TaskLive,  task.workspace_id,  task.id), class: "flex flex-col gap-y-4 cursor-pointer" do %>
              <EverWeb.TaskComponent.link_card task={task} />
            <% end %>
            <div class="mt-5 flex justify-between items-center">
              <span class="text-sm">Crated at <%= LiveHelpers.format_time(task.inserted_at) %></span>
              <div class="flex justify-end">
                <form phx-change="status-update">
                  <input name="task_id" value={task.id} type="hidden">
                  <div class="flex flex-col gap-y-1.5 border-b-2 border-blue-500">
                    <select name="status"  class="pb-1 px-2">
                      <%= options_for_select(get_status(), task.status)  %>
                    </select>
                  </div>
                </form>
              </div>
            </div>
          </li>
          <% end %>
        </ul>
        <% else %>
          <p>No Tasks<p>
        <% end %>
        </div>
    </section>
    """
  end

  def handle_event("status-update", %{"task_id" => task_id, "status" => status}, socket) do
    case Tasks.update_status(task_id, status) do
      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, error_changeset} = apply_action(changeset, :update)

        {:noreply, assign(socket, changeset: error_changeset)}

      {:error, message} ->
        socket =
          socket
          |> put_flash(:error, message)

        {:noreply, socket}

      {:ok, task} ->
        tasks =
          Enum.map(socket.assigns.workspace.tasks, fn x ->
            case x.workspace_id == task.id do
              true -> task
              false -> x
            end
          end)

        workspace = Map.replace(socket.assigns.workspace, :tasks, tasks)

        socket =
          socket
          |> put_flash(:info, "Status updated!")
          |> assign(workspace: workspace)

        {:noreply, socket}
    end

    {:noreply, socket}
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
    [Todo: :todo, "In Progress": :in_progress, Done: :done]
  end
end
