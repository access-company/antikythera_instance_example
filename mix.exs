# Copyright(c) 2015-2018 ACCESS CO., LTD. All rights reserved.

solomon_dep = {:solomon, [git: "git@github.com:access-company/solomon.git", ref: "f5aff8048db501983e875a6690b0b872f69287ab"]}

try do
  parent_dir = Path.expand("..", __DIR__)
  deps_dir =
    case Path.basename(parent_dir) do
      "deps" -> parent_dir                 # this solomon instance project is used by a gear
      _      -> Path.join(__DIR__, "deps") # this solomon instance project is the toplevel mix project
    end
  mix_common_file_path = Path.join([deps_dir, "solomon", "mix_common.exs"])
  Code.require_file(mix_common_file_path)

  defmodule SolomonInstanceExample.Mixfile do
    use Mix.Project

    def project() do
      github_url = "https://github.com/access-company/solomon_instance_example"
      [
        app:             :solomon_instance_example,
        version:         Solomon.MixCommon.version_with_last_commit_info("0.1.0"),
        start_permanent: Mix.env() == :prod,
        deps:            deps(),
        source_url:      github_url,
        homepage_url:    github_url,
      ] ++ Solomon.MixCommon.common_project_settings()
    end

    def application() do
      [
        applications: [:solomon | Solomon.MixCommon.solomon_runtime_dependency_applications(deps())],
      ]
    end

    defp deps() do
      [
        unquote(solomon_dep),

        {:meck            , "0.8.9" , [only: :test]}, # required to run testgear tests
        {:websocket_client, "1.3.0" , [only: :test]}, # required to run testgear tests (also essential for upgrade_compatibility_test)
      ]
    end
  end
rescue
  Code.LoadError ->
    defmodule SolomonInstanceInitialSetup.Mixfile do
      use Mix.Project

      def project() do
        [
          app:  :just_to_fetch_solomon_as_a_dependency,
          deps: [unquote(solomon_dep)],
        ]
      end
    end
end
