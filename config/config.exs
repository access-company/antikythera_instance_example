# Copyright(c) 2015-2018 ACCESS CO., LTD. All rights reserved.

use Mix.Config

repo_parent_dir = Path.expand(Path.join([__DIR__, "..", ".."]))
deps_dir =
  case Path.basename(repo_parent_dir) do
    "deps" -> repo_parent_dir                                 # this antikythera instance project is used by a gear
    _      -> Path.expand(Path.join([__DIR__, "..", "deps"])) # this antikythera instance project is the toplevel mix project
  end

antikythera_config_file = Path.join([deps_dir, "solomon", "config", "config.exs"])
if File.regular?(antikythera_config_file) do
  import_config antikythera_config_file
end

config :solomon, [
  antikythera_instance_name: :antikythera_instance_example,
]
