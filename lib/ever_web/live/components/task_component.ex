defmodule EverWeb.TaskComponent do
  use Phoenix.Component

  def link_card(assigns) do
    ~H"""
      <div class="flex flex-col gap-y-4">
        <p class="font-medium text-xl"><%= @task.name %></p>
        <p class="truncate"><%= @task.description %></p>
      </div>
    """
  end
end
