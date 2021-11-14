defmodule EverWeb.HeaderComponent do
  use Phoenix.Component

  def header(assigns) do
    ~H"""
      <header class="flex py-6 justify-between items-center">
        <h1 class="font-bold text-3xl">Ever</h1>
        <span><%= @current_user.name %></span>
      </header>
    """
  end
end
