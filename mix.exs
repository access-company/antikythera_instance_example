# Copyright(c) 2015-2018 ACCESS CO., LTD. All rights reserved.

antikythera_dep = {:antikythera, [github: "access-company/antikythera", ref: "e5975644f76b4155e2db673ac024051f91e12e0a"]}

try do
  parent_dir = Path.expand("..", __DIR__)
  deps_dir =
    case Path.basename(parent_dir) do
      "deps" -> parent_dir                 # this antikythera instance project is used by a gear
      _      -> Path.join(__DIR__, "deps") # this antikythera instance project is the toplevel mix project
    end
  mix_common_file_path = Path.join([deps_dir, "antikythera", "mix_common.exs"])
  Code.require_file(mix_common_file_path)

  defmodule AntikytheraInstanceExample.Mixfile do
    use Mix.Project

    def project() do
      github_url = "https://github.com/access-company/antikythera_instance_example"
      [
        app:             :antikythera_instance_example,
        version:         Antikythera.MixCommon.version_with_last_commit_info("0.1.0"),
        start_permanent: Mix.env() == :prod,
        deps:            deps(),
        source_url:      github_url,
        homepage_url:    github_url,
      ] ++ Antikythera.MixCommon.common_project_settings()
    end

    def application() do
      [
        applications: [:antikythera | Antikythera.MixCommon.antikythera_runtime_dependency_applications(deps())],
      ]
    end

    defp deps() do
      [
        unquote(antikythera_dep),

        {:exsync          , "0.2.3", [only: :dev ]},
        {:meck            , "0.8.9", [only: :test]}, # required to run testgear tests
        {:websocket_client, "1.3.0", [only: :test]}, # required to run testgear tests (also essential for upgrade_compatibility_test)
      ]
    end
  end
rescue
  Code.LoadError ->
    defmodule AntikytheraInstanceInitialSetup.Mixfile do
      use Mix.Project

      def project() do
        [
          app:  :just_to_fetch_antikythera_as_a_dependency,
          deps: [unquote(antikythera_dep)],
        ]
      end
    end
end
