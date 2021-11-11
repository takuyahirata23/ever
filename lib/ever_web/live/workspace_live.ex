defmodule EverWeb.WorkspaceLive do
  use EverWeb, :live_view

  alias Ever.Workspaces
  alias Ever.Tasks.Task

  def mount(%{"workspace_id" => id}, _session, socket) do
    workspace = Workspaces.read_workspace(id)
    task_changeset = Task.changeset(%Task{})

    {:ok, assign(socket, workspace: workspace, show_modal: false, task_changeset: task_changeset)}
  end

  def render(assigns) do
    ~H"""
    <section>
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
              <.form let={f} for={@task_changeset} action="#" phx_submit="submit"  %>
                <div class="flex flex-col gap-y-6">
                  <div class="flex flex-col gap-y-1.5">
                    <%= label f, :name  %>
                    <%= text_input f, :name, required: true, class: "border border-black rounded-md p-2", autocomplete: "off" %>
                    <%= error_tag f, :name %>
                  </div>
                  <div class="flex flex-col gap-y-1.5">
                    <%= label f, :description  %>
                    <%= text_input f, :name, required: true, class: "border border-black rounded-md p-2", autocomplete: "off" %>
                    <%= error_tag f, :name %>
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
    </section>
    """
  end

  def handle_event("toggle-modal", _, socket) do
    {:noreply, update(socket, :show_modal, &(!&1))}
  end

  def handle_event("submit", params, socket) do
    IO.inspect(params)
    {:noreply, socket}
  end
end
