defmodule ParkingWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use ParkingWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:bad_request)
    |> put_view(ParkingWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(ParkingWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, :unauthorized_user}) do
    conn
    |> put_status(404)
    |> put_view(ParkingWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, msg}) when is_list(msg) do
    conn
    |> put_status(400)
    |> put_view(ParkingWeb.ChangesetView)
    |> render("error.json", errors: msg)
  end
end
