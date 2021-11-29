defmodule EverWeb.Admin.DashboardLive do
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
      <div class="p-8 flex-1">
        <h1 class="text-3xl font-medium">Dashbaord</h1>
      </div>
    </section>
    """
  end
end
