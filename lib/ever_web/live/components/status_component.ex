defmodule EverWeb.StatusComponent do
  use Phoenix.Component

  def status(assigns) do
    ~H"""
      <span class={"px-2 py-1 text-white rounded-md self-end capitalize " <> get_status_color(@status)}>
        <%= status_to_string(@status) %>
      </span>
    """
  end

  def status_count(assigns) do
    ~H"""
      <li class="p-6 flex flex-col gap-y-5 items-center rounded-lg shadow border border-gray-300">
        <span class="text-xl font-medium"><%= status_to_string(@status.status) %></span>
        <span class="text-lg font-medium"><%= @status.count %></span>
      </li>
    """
  end

  defp get_status_color(status) do
    case status do
      :todo -> "bg-yellow-500"
      :in_progress -> "bg-blue-500"
      :done -> "bg-green-500"
    end
  end

  def status_to_string(status) do
    case status do
      :todo -> "Todo"
      :in_progress -> "In Progress"
      :done -> "Done"
    end
  end
end
