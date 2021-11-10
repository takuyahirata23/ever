defmodule EverWeb.WorkspaceLive do
  use EverWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
        <section>
        workspace
        </section>
    """
  end
end
