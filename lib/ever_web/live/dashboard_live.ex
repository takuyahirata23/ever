defmodule EverWeb.DashboardLive do
  use EverWeb, :live_view
  import EverWeb.LiveHelpers

  alias Ever.Workspaces

  def mount(_params, session, socket) do
    socket = assign_current_user(socket, session)

    status_count = Workspaces.read_workspace_stats(socket.assigns.current_user.id)

    socket = assign(socket, status_count: status_count)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <section class="flex">
      <%= live_component EverWeb.SidebarComponent, current_user: @current_user, id: "dashboard-sidebar" %>
      <div class="p-8 flex-1">
        <h1 class="text-3xl font-medium">Dashbaord</h1>
        <div class="mt-8">
          <h2 class="text-2xl font-medium">Tasks</h2>
          <ul class="grid grid-cols-3 gap-x-4 mt-4">
            <%= for status <- @status_count do %>
              <EverWeb.StatusComponent.status_count status={status} />
            <% end %>
          </ul>
        </div>
      </div>
    </section>
    """
  end
end
