defmodule Explugrouter do
  defmacro __using__(_opts) do
    quote do
      use Plug.Router
      use Plug.ErrorHandler

      import Explugrouter
      import Plug.Conn
      import Explugrouter.Utils

      require Logger

      @before_compile Explugrouter

      def handle_errors(conn, %{kind: _kind, reason: reason, stack: _stack}),
        do: handle_error(conn, reason)
    end
  end

  # Inject at the end of the calling module to catch all
  # unmatched routes.
  defmacro __before_compile__(_env) do
    quote do
      Plug.Router.match _ do
        handle_error(var!(conn), {:error, :not_found})
      end
    end
  end

  defmacro handle_result(block) do
    quote do
      case unquote(block) do
        %Plug.Conn{}=c -> send_resp(c, 200, "")
        :ok -> send_resp(var!(conn), 200, "")
        {:ok, data} -> send_json(var!(conn), %{data: data})
        e -> handle_error(var!(conn), e)
      end
    end
  end
end
