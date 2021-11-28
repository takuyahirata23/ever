defmodule Ever.Guardian do
  use Guardian, otp_app: :ever

  alias Ever.Accounts

  @doc false
  def subject_for_token(%{} = identity, _claims) do
    IO.inspect(identity)
    sub = to_string(identity.id)
    {:ok, sub}
  end

  @doc false
  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  @doc false
  def resource_from_claims(%{} = claims) do
    id = claims["sub"]
    resource = Accounts.get_user!(id)
    {:ok, resource}
  end

  @doc false
  def resource_from_claims(_claims) do
    {:error, :reason_for_error}
  end
end
