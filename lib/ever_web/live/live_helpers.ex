defmodule EverWeb.LiveHelpers do
  import Phoenix.LiveView
  alias Timex

  alias Ever.Accounts

  def assign_current_user(socket, session) do
    assign_new(socket, :current_user, fn ->
      Accounts.get_user_by_session_token(session["user_token"])
    end)
  end

  def format(time) do
    case Timex.format(time, "%Y-%m-%d", :strftime) do
      {:error, _} -> "N/A"
      {:ok, time} -> time
    end
  end
end
