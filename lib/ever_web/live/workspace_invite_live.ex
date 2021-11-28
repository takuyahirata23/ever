defmodule EverWeb.WorkspaceInviteLive do
  use EverWeb, :live_view
  import EverWeb.LiveHelpers

  def mount(%{"workspace_id" => id}, session, socket) do
    socket =
      socket
      |> assign_current_user(session)
      |> assign(workspace_id: id)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
      <div class="max-w-5xl w-11/12 mx-auto">
        <EverWeb.HeaderComponent.header current_user={@current_user} />
      </div>
    """
  end
end
