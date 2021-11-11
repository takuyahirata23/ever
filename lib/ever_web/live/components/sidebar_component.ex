defmodule EverWeb.SidebarComponent do
  use EverWeb, :live_component

  alias Ever.Workspaces.Workspace
  alias Ever.Workspaces

  def mount(socket) do
    changeset = Workspace.changeset(%Workspace{})

    {:ok,
     assign(socket,
       show_modal: false,
       changeset: changeset
     )}
  end

  def update(assigns, socket) do
    workspaces = Workspaces.read_workspaces(assigns.current_user.id)

    {:ok, assign(socket, workspaces: workspaces, current_user_id: assigns.current_user.id)}
  end

  def render(assigns) do
    ~H"""
      <aside class="p-6 max-w-xs w-3/12">
        <h1 class="font-bold text-3xl">Ever</h1>
        <h2 class="font-medium text-lg mb-2 mt-6">Workspaces</h2>
        <ul>
          <%= for workspace <- @workspaces do %>
            <li><%= live_redirect workspace.name, to: Routes.live_path(@socket, EverWeb.WorkspaceLive, workspace.id)  %></li>
          <% end %>
        </ul>
        <div class="flex mt-5">
          <button phx-click="toggle-modal"
            phx-target={@myself}
            class="p-2 bg-blue-500 rounded-md text-white text-sm"
          >
            Create Workspace
          </button>
        </div>

        <%= if @show_modal do %>
          <div class="phx-modal" 
            phx-window-keydown="toggle-modal"
            phx-key="escape"
            phx-capture-click="toggle-modal"
            phx-target={@myself}
          >
            <div class="phx-modal-content w-1/2">
              <div class="phx-modal-close">
                <a href="#" phx-click="toggle-modal"
                  phx-target={@myself}
                >
                  &times;
                </a>
              </div>
              <p class="text-center font-medium text-2xl my-8">Register</p>
              <.form let={f} for={@changeset} action="#" phx_submit="submit" phx_target={@myself} %>
                <div class="flex flex-col gap-y-6">
                  <div class="flex flex-col gap-y-1.5">
                    <%= label f, :name  %>
                    <%= text_input f, :name, required: true, class: "border border-black rounded-md p-2", autocomplete: "off" %>
                    <%= error_tag f, :name %>
                  </div>
                  <div class="flex justify-center mt-6">
                    <%= submit "Create Workspace", class: "w-1/2 p-4 bg-blue-500 rounded-md text-white" %>
                  </div>
                </div>
              </.form>
            </div>
          </div>
        <% end %>
      </aside>
    """
  end

  def handle_event("toggle-modal", _, socket) do
    {:noreply, update(socket, :show_modal, &(!&1))}
  end

  def handle_event("submit", %{"workspace" => workspace}, socket) do
    case Workspaces.create_workspace(
           Map.put(workspace, "workspace_manager_id", socket.assigns.current_user_id)
         ) do
      {:error, changeset} ->
        socket =
          socket
          |> assign(changeset: changeset)

        {:noreply, socket}

      {:ok, workspace} ->
        socket =
          socket
          |> assign(show_modal: false)
          |> update(:workspaces, fn ws -> Enum.concat(ws, [workspace]) end)

        {:noreply, socket}
    end
  end
end
