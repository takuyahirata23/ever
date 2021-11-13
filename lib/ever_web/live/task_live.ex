defmodule EverWeb.TaskLive do
  use EverWeb, :live_view

  def mount(params, session, socket) do
    IO.inspect(params)
    IO.inspect(session)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
      <div>
        yo
      </div>
    """
  end
end
