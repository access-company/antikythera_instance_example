# Copyright(c) 2015-2018 ACCESS CO., LTD. All rights reserved.

use Mix.Config

# Limit port range to be used for ErlangVM-to-ErlangVM communications
config :kernel, [
  inet_dist_listen_min: 6000,
  inet_dist_listen_max: 7999,
]

# SASL logs are handled by :logger
config :sasl, [
  sasl_error_logger: false,
]

config :logger, [
  level:               :info,
  utc_log:             true,
  handle_sasl_reports: true,
  translators:         [{SolomonCore.ErlangLogTranslator, :translate}],
  backends:            [:console, SolomonCore.Alert.LoggerBackend],
  console: [
    format:   "$dateT$time+00:00 [$level$levelpad] $metadata$message\n",
    metadata: [:module],
  ],
]

config :raft_fleet, [
  per_member_options_maker: SolomonCore.AsyncJob.RaftOptionsMaker,
]

# Auxiliary variables
repo_parent_dir = Path.join([__DIR__, "..", ".."]) |> Path.expand()
deps_dir =
  case Path.basename(repo_parent_dir) do
    "deps" -> repo_parent_dir
    _      -> Path.join([__DIR__, "..", "deps"]) |> Path.expand()
  end
solomon_repo_tmp_dir = Path.join([deps_dir, "solomon", "tmp"])

repo_tmp_dir =
  case System.get_env("SOLOMON_COMPILE_ENV") do
    "local" -> [solomon_repo_tmp_dir, "local"     ]
    _       -> [solomon_repo_tmp_dir, :os.getpid()]
  end
  |> Path.join()

config :solomon, [
  # Name of the OTP application that runs as a solomon instance.
  solomon_instance_name: :solomon_instance_example,

  # Directory (which can be in a NFS volume) where solomon's configuration files, build artifacts, etc. are stored.
  solomon_root_dir: Path.join(repo_tmp_dir, "root"),

  # Directory where `SolomonLib.Tmpdir.make/2` creates temporary workspaces for gear implementations.
  gear_tmp_dir: Path.join(repo_tmp_dir, "gear_tmp"),

  # Directory where log/snapshot files of persistent Raft consensus groups are stored.
  raft_persistence_dir_parent: Path.join(repo_tmp_dir, "raft_fleet"),

  # URL of Content Delivery Network for static assets (such as CSS, JS, etc.).
  asset_cdn_endpoint: nil,

  # Pluggable modules that implement `SolomonEal.*.Behaviour` behaviours.
  eal_impl_modules: [
    infrastructure:  SolomonEal.Infrastructure.StandAlone,
    log_storage:     SolomonEal.LogStorage.FileSystem    ,
    metrics_storage: SolomonEal.MetricsStorage.Memory    ,
    alert_mailer:    SolomonEal.AlertMailer.MemoryInbox  ,
    asset_storage:   SolomonEal.AssetStorage.NoOp        ,
  ],

  # Platform-specific configurations used by some implementations of `SolomonEal.*.Behaviour`.
  aws_region: "ap-northeast-1",

  # Alert email settings.
  alert: [
    email: [
      from: "solomon@example.com",
    ],
  ],
]
