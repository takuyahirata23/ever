defmodule EverWeb.Policies do
  use PolicyWonk.Policy
  use PolicyWonk.Enforce

  import Phoenix.Controller

  alias EverWeb.Router.Helpers, as: Routes
  alias Ever.Accounts.User

  def policy(assigns, :is_admin) do
    case is_admin(assigns.current_user) do
      true -> :ok
      _ -> {:error, :unauthorized}
    end
  end

  def policy_error(conn, :unauthorized) do
    conn
    |> redirect(to: Routes.user_session_path(conn, :new))
  end

  defp is_admin(%User{} = user) do
    user.is_admin
  end

  defp is_admin(_) do
    false
  end
end
