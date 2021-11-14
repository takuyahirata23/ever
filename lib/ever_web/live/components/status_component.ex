defmodule EverWeb.StatusComponent do
  use Phoenix.Component

  def status(assigns) do
    ~H"""
      <span class="px-2 py-1 bg-blue-500 text-white rounded-md self-end capitalize">
        <%= @status %>
      </span>
    """
  end
end
