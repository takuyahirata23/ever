defmodule EverWeb.Resolvers.Users do
  alias Ever.Accounts

  def read_users(_, _, _) do
    {:ok, Accounts.read_users()}
  end
end
