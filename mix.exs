# Copyright(c) 2015-2022 ACCESS CO., LTD. All rights reserved.

antikythera_dep = {:antikythera, [github: "access-company/antikythera", ref: "dfbe7466ce9cf2076a4fe0ca18e52f27b8a78d79"]}

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

    # Here we strictly enforce Erlang/OTP version during evaluations of `mix.exs`.
    # Elixir version is also checked using `:elixir` key in `project/0`.
    # Although these version checks are not mandatory for antikythera instances,
    # this way an antikythera instance can control Erlang/Elixir versions used in its gear projects.
    versions =
      File.read!(Path.join(__DIR__, ".tool-versions"))
      |> String.split("\n", trim: true)
      |> Map.new(fn line ->
        [n, v | _] = String.split(line, [" ", "-"], trim: true)
        {n, v}
      end)
    @elixir_version Map.fetch!(versions, "elixir")

    case System.argv() do
      ["deps" <> _ | _] -> :ok # `deps.*` command may resolve incorrect Erlang/OTP version (if any) so we shouldn't interrupt it.
      _                 ->
        otp_version         = Map.fetch!(versions, "erlang")
        otp_version_path    = Path.join([:code.root_dir(), "releases", System.otp_release(), "OTP_VERSION"])
        current_otp_version = File.read!(otp_version_path) |> String.trim_trailing()
        if current_otp_version != otp_version do
          Mix.raise("Incorrect Erlang/OTP version! required: '#{otp_version}', used: '#{current_otp_version}'")
        end
    end

    def project() do
      github_url = "https://github.com/access-company/antikythera_instance_example"
      base_settings = Antikythera.MixCommon.common_project_settings() |> Keyword.replace!(:elixir, @elixir_version)
      [
        app:             :antikythera_instance_example,
        version:         Antikythera.MixCommon.version_with_last_commit_info("0.1.0"),
        start_permanent: Mix.env() == :prod,
        deps:            deps(),
        source_url:      github_url,
        homepage_url:    github_url,
      ] ++ base_settings
    end

    def application() do
      [
        applications: [:antikythera | Antikythera.MixCommon.antikythera_runtime_dependency_applications(deps())],
      ]
    end

    defp deps() do
      [
        unquote(antikythera_dep),

        {:exsync          , "0.2.4" , [only: :dev ]},
        {:meck            , "0.8.13", [only: :test]}, # required to run testgear tests
        {:websocket_client, "1.3.0" , [only: :test]}, # required to run testgear tests (also essential for upgrade_compatibility_test)
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
