{
  stdenvNoCC,
  fetchzip,
  installFonts,
  nix-update-script,
  lib,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "plangothic";
  version = "2.9.5795";

  outputs = [
    "out"
    "webfont"
  ];

  src = fetchzip {
    url = "https://github.com/Fitzgerald-Porthmouth-Koenigsegg/Plangothic_Project/releases/download/V${finalAttrs.version}/Plangothic-Super-V${finalAttrs.version}.zip";
    hash = "sha256-OxxQLff2YvnL57TmeMq28ozCr1TQOZ14jSGoAJ2Dj80=";
  };

  # otf/Plangothic.ttc and static/Plangothic.ttc share a name and only bundle
  # the P1/P2 faces that are already shipped as separate otf/ttf files
  postPatch = ''
    rm otf/Plangothic.ttc static/Plangothic.ttc
  '';

  nativeBuildInputs = [
    installFonts
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "V(.*)"
    ];
  };

  meta = {
    description = "CJK Unified Idegraphs extension font based on Source Han Sans";
    homepage = "https://github.com/Fitzgerald-Porthmouth-Koenigsegg/Plangothic_Project";
    changelog = "https://github.com/Fitzgerald-Porthmouth-Koenigsegg/Plangothic_Project/releases/tag/V${finalAttrs.version}";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      ulic-youthlic
    ];
  };
})
