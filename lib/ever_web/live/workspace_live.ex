defmodule EverWeb.WorkspaceLive do
  use EverWeb, :live_view

  alias Ever.Workspaces

  def mount(%{"workspace_id" => id}, _session, socket) do
    workspace = Workspaces.read_workspace(id)

    {:ok, assign(socket, workspace: workspace)}
  end

  def render(assigns) do
    ~H"""
    <section>
    <h1 class="font-bold text-3xl">
    <%= @workspace.name %>
    </h1>
    </section>
    """
  end
end
