defmodule Parking.Authentication do
  alias Parking.Guardian
  import Plug.Conn

  def check_credentials(user, plain_text_password) do
    if user && Pbkdf2.verify_pass(plain_text_password, user.hashed_password) do
      {:ok, user}
    else
      {:error, :unauthorized_user}
    end
  end

  def login(conn, user) do
    {:ok, jwt, _} = Guardian.encode_and_sign(user)
    conn
    |> put_resp_header("Authorization", "Bearer "<>jwt)
  end

  # def logout(conn) do
  #   conn
  #   |> Guardian.Plug.sign_out()
  # end

  def load_current_user(conn) do
    Guardian.Plug.current_resource(conn)
  end
end

