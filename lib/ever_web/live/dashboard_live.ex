defmodule EverWeb.DashboardLive do
  use EverWeb, :live_view
  import EverWeb.LiveHelpers

  def mount(_params, session, socket) do
    {:ok, assign_current_user(socket, session)}
  end

  def render(assigns) do
    ~H"""
    <section class="flex">
      <%= live_component EverWeb.SidebarComponent, current_user: @current_user, id: "dashboard-sidebar" %>
    <div class="p-6">
      <h1>dashbaord</h1>
    </div>
    </section>
    """
  end
end
