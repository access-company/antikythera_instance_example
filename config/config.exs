# Copyright(c) 2015-2018 ACCESS CO., LTD. All rights reserved.

use Mix.Config

solomon_config_file = Path.expand(Path.join([__DIR__, "..", "deps", "solomon", "config", "config.exs"]))
if File.regular?(solomon_config_file) do
  import_config solomon_config_file
end

config :solomon, [solomon_instance_name: :solomon_instance_example]
