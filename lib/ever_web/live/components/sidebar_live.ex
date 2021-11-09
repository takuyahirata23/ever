defmodule EverWeb.SidebarComponent do
  use EverWeb, :live_component

  def render(assigns) do
    ~H"""
    <aside class="p-6 max-w-xs w-3/12">
      <h1>Ever</h1>
    </aside>
    """
  end
end
