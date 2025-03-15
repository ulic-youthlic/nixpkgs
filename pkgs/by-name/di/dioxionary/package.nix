{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  installShellFiles,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "dioxionary";
  version = "1.1.3";
  src = fetchFromGitHub {
    owner = "vaaandark";
    repo = "dioxionary";
    tag = "v${version}";
    hash = "sha256-v9YS5D58vjcMfgrVDN5oWWA0x1aqQk+/qALrq4Fz2iI=";
    # enable fetchSubmodules since the tests require dictionaries from the submodules
    fetchSubmodules = true;
  };

  cargoHash = "sha256-1pnayYG5Bz3d3bMCYZUzJDe2vpN+2jbvShHLY961FPI=";
  useFetchCargoVendor = true;

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];
  buildInputs = [ openssl.dev ];

  postInstall = ''
    installShellCompletion --cmd dioxionary \
      --bash <($out/bin/dioxionary completion bash) \
      --zsh <($out/bin/dioxionary completion zsh) \
      --fish <($out/bin/dioxionary completion fish)
  '';

  checkFlags = [
    # skip these tests since they require internet access
    "--skip=dict::online::test::look_up_online_by_chinese"
    "--skip=dict::online::test::look_up_online_by_english"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Rusty stardict. Enables terminal-based word lookup and vocabulary memorization using offline or online dictionaries";
    homepage = "https://github.com/vaaandark/dioxionary";
    changelog = "https://github.com/vaaandark/dioxionary/releases/tag/v${version}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ ulic-youthlic ];
    mainProgram = "dioxionary";
  };
}
