defmodule EverWeb.Context do
  @behaviour Plug

  import Plug.Conn

  alias Ever.Accounts

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  @doc """
  Return the person context baesd on the authorization header.
  """
  def build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         user <- Accounts.find_user_by_web_token(token) do
      %{current_user: user}
    else
      _ -> %{}
    end
  end
end
