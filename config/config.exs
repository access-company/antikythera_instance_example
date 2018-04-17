# Copyright(c) 2015-2018 ACCESS CO., LTD. All rights reserved.

use Mix.Config

repo_parent_dir = Path.expand(Path.join([__DIR__, "..", ".."]))
  deps_dir =
    case Path.basename(repo_parent_dir) do
      "deps" -> repo_parent_dir                                 # this solomon instance project is used by a gear
      _      -> Path.expand(Path.join([__DIR__, "..", "deps"])) # this solomon instance project is the toplevel mix project
    end

solomon_config_file = Path.join([deps_dir, "solomon", "config", "config.exs"])
if File.regular?(solomon_config_file) do
  import_config solomon_config_file
end

config :solomon, [solomon_instance_name: :solomon_instance_example]
