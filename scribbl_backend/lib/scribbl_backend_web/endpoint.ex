defmodule ScribblBackendWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :scribbl_backend

  def cors_origins do
    Application.get_env(:scribbl_backend, :cors_allowed_origins, ["http://localhost:3000"])
  end

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_scribbl_backend_key",
    signing_salt: "2gw+BEy6",
    same_site: "Lax"
  ]

  socket "/socket", ScribblBackendWeb.UserSocket,
  # skip origin verification for now
    websocket: [check_origin: false, timeout: 180_000],
    pubsub_server: ScribblBackend.PubSub


  socket "/live", Phoenix.LiveView.Socket,
    websocket: [connect_info: [session: @session_options]],
    longpoll: [connect_info: [session: @session_options]]

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :scribbl_backend,
    gzip: false,
    only: ScribblBackendWeb.static_paths()

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  # CORS Configuration
  plug CORSPlug,
    origin: &ScribblBackendWeb.Endpoint.cors_origins/0,
    methods: ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
    headers: ["Content-Type", "Authorization", "Accept", "Origin", "User-Agent", "DNT", "Cache-Control", "X-Mx-ReqToken", "Keep-Alive", "X-Requested-With", "If-Modified-Since"]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug ScribblBackendWeb.Router
end
