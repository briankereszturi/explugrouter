defmodule ExPlugRouter.Utils do
  import Plug.Conn
  
  require Logger

  def handle_error(conn, {:error, :bad_request, errors}),
    do: send_json(conn, 400, %{"errors" => errors})
  def handle_error(conn, {:error, :bad_request}),
    do: send_resp(conn, 400, "Bad Request")
  def handle_error(conn, {:error, :invalid}),
    do: send_resp(conn, 400, "Invalid json")
  def handle_error(conn, {:error, {:invalid, _, _}}),
    do: send_resp(conn, 400, "Invalid json")
  def handle_error(conn, {:error, :unauthorized}),
    do: send_resp(conn, 401, "Unauthorized")
  def handle_error(conn, {:error, :not_found}),
    do: send_resp(conn, 404, "Not Found")
  def handle_error(conn, {:error, :internal_server_error}),
    do: send_resp(conn, 500, "Internal Server Error")
  def handle_error(conn, e) do
    Logger.error "#{inspect e}"
    send_resp(conn, 500, "Internal Server Error")
  end

  def send_json(conn, status, serializable) do
    conn
      |> put_resp_header("content-type", "application/json")
      |> send_resp(status, Poison.encode!(serializable))
  end
  def send_json(conn, serializable) do
    send_json(conn, 200, serializable)
  end

  defp render_detail({message, values}) do
    Enum.reduce values, message, fn {k, v}, acc ->
      String.replace(acc, "%{#{k}}", to_string(v))
    end
  end

  def send_changeset_errors(conn, changeset) do
    errors = changeset.errors
      |> Enum.map(fn {k, v} -> ~s("#{k}" #{render_detail(v)}) end)

    handle_error(conn, {:error, :bad_request, errors})
  end
end
