defmodule Parking.AuthPipeline do
  use Guardian.Plug.Pipeline,
      otp_app: :parking,
      error_handler: Parking.ErrorHandler,
      module: Parking.Guardian

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end

