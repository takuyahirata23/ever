defmodule EverWeb.SidebarComponent do
  use EverWeb, :live_component

  alias Ever.Workspaces.Workspace
  alias Ever.Workspaces

  def mount(socket) do
    workspace_changeset = Workspace.workspace_changeset(%Workspace{})
    workspaces = Workspaces.read_workspaces()

    {:ok,
     assign(socket,
       show_modal: false,
       workspaces: workspaces,
       workspace_changeset: workspace_changeset
     )}
  end

  def render(assigns) do
    ~H"""
    <aside class="p-6 max-w-xs w-3/12">
    <h1>Ever</h1>
    <%= for workspace <- @workspaces do %>
      <p><%= workspace.name %></p>
      <% end %>
    <button phx-click="toggle-modal" phx-target={@myself}>Create Workspace</button>
    <%= if @show_modal do %>
    <div class="phx-modal" 
    phx-window-keydown="toggle-modal"
    phx-key="escape"
    phx-capture-click="toggle-modal"
    phx-target={@myself}
    >
    <div class="phx-modal-content w-1/2">
    <div  class="phx-modal-close" >
    <a href="#" phx-click="toggle-modal"
    phx-target={@myself}
    >
    &times;
    </a>
    </div>
    <p class="text-center font-medium text-2xl my-8">Register</p>
      <.form let={f} for={@workspace_changeset} action="#" phx_submit="submit" phx_target={@myself} %>
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
    IO.inspect(socket.assigns.flash)

    case Workspaces.create_workspace(workspace) do
      {:error, changeset} ->
        socket =
          socket
          |> put_flash(:error, "Sorry, please try it later.")
          |> assign(changeset: changeset)

        {:noreply, socket}

      {:ok, workspace} ->
        socket =
          socket
          |> put_flash(:info, "#Created {workspace.name}!")
          |> assign(show_modal: false)
          |> update(:workspaces, fn ws -> Enum.concat(ws, [workspace]) end)

        {:noreply, socket}
    end
  end
end
