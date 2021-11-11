defmodule EverWeb.WorkspaceLive do
  use EverWeb, :live_view

  alias Ever.Workspaces

  def mount(%{"workspace_id" => id}, _session, socket) do
    workspace = Workspaces.read_workspace(id)

    {:ok, assign(socket, workspace: workspace, show_modal: false)}
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
                 hiii
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
end
