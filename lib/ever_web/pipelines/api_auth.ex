defmodule EverWeb.Pipelines.ApiAuth do
  alias EverWeb.Pipelines.ApiAuth.ErrorHandler

  use Guardian.Plug.Pipeline,
    otp_app: :ever,
    error_handler: ErrorHandler,
    module: Ever.Guardian

  # If there is a session token, validate it
  plug(Guardian.Plug.VerifySession, claims: %{"typ" => "access"})

  # If there is an authorization header, validate it
  plug(Guardian.Plug.VerifyHeader, realm: "Bearer", claims: %{"typ" => "access"})

  # Load the identity if either of the verifications works
  plug(Guardian.Plug.LoadResource, allow_blank: true)

  plug(Guardian.Plug.EnsureAuthenticated, claims: %{"typ" => "access"})
end

defmodule EverWeb.Pipelines.ApiAuth.ErrorHandler do
  import Plug.Conn

  def auth_error(conn, {type, _resource}, _opts) do
    body = Jason.encode!(%{error: to_string(type)})
    send_resp(conn, 401, body)
  end
end
