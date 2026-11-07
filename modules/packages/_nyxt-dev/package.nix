{
  src,
  lib,
  stdenv,
  stdenvNoCC,
  cacert,
  curl,
  git,
  jq,
  sbcl_2_6_8,
  cef-binary,
  cmake,
  wrapGAppsHook3,
  pkg-config,
  wayland,
  wayland-scanner,
  libx11,
  libxext,
  libxcb,
  libGL,
  gtk3,
  gsettings-desktop-schemas,
  libfixposix,
  openssl,
  sqlite,
  enchant,
  xdg-utils,
}:
let
  depsHash = "sha256-qdAzhx023Nelrg15N7I+ZYUZALqVz2Ipjv51bcQPOa4=";

  ocicl = stdenvNoCC.mkDerivation {
    name = "nyxt-dev-ocicl-${src.shortRev}";
    nativeBuildInputs = [
      cacert
      curl
      git
      jq
    ];
    buildCommand = "bash ${./fetch-ocicl.sh} ${src}/ocicl.csv $out";
    outputHashMode = "recursive";
    outputHash = depsHash;
  };

  cef = cef-binary.override {
    version = "150.0.22";
    gitRevision = "c1a097e";
    chromiumVersion = "150.0.7871.256";
    srcHashes.x86_64-linux = "sha256-3Rtcw6xu/mWex+jpsGd7pOQyFqL+/K/Vq8k0CDfjLZY=";
  };

  cefRuntime = [
    "libcl-cef.so"
    "cl-cef-helper"
    "chrome-sandbox"
    "libcef.so"
    "libEGL.so"
    "libGLESv2.so"
    "libvk_swiftshader.so"
    "libvulkan.so.1"
    "v8_context_snapshot.bin"
    "vk_swiftshader_icd.json"
    "chrome_100_percent.pak"
    "chrome_200_percent.pak"
    "resources.pak"
    "icudtl.dat"
  ];
in
stdenv.mkDerivation {
  pname = "nyxt-dev";
  version = "4-unstable-${src.shortRev}";
  inherit src;

  nativeBuildInputs = [
    cmake
    wrapGAppsHook3
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    sbcl_2_6_8
    libfixposix
    wayland
    libx11
    gtk3
    gsettings-desktop-schemas
  ];

  dontUseCmakeConfigure = true;
  hardeningDisable = [ "stackprotector" ];

  env = {
    LD_LIBRARY_PATH = lib.makeLibraryPath [
      openssl
      sqlite
      libfixposix
      enchant
      libGL
      libx11
      libxext
      libxcb
    ];
    NYXT_RENDERER = "cef";
  };

  preConfigure = ''
    export HOME=$TMPDIR
    export ASDF_OUTPUT_TRANSLATIONS="/:$PWD/.fasl/"

    cp -r ${ocicl} ocicl
    chmod -R u+w ocicl
    ocicl_dir() {
      awk -F', ' -v s="$1" '$1 == s { print $3; exit }' ocicl.csv | xargs dirname | sed "s|^|$PWD/ocicl/|"
    }

    clipboardDir=$(ocicl_dir cl-clipboard)
    make -C "$clipboardDir"

    # patch -d "$(ocicl_dir cl-cef)" -p1 < ${./cl-cef-main-frame-redirect.patch}
    cefBuild=$(ocicl_dir cl-cef)/build
    cmake -S "$(dirname "$cefBuild")" -B "$cefBuild" -DCEF_ROOT=${cef}
    cmake --build "$cefBuild" -j "$NIX_BUILD_CORES"
    export CL_CEF_LIBRARY=$cefBuild/libcl-cef.so

    export OCICL_DIR=$PWD/ocicl OCICL_CSV=$PWD/ocicl.csv

    nyxtLisp() {
      sbcl --dynamic-space-size 4096 --noinform --no-userinit --non-interactive \
        --eval '(require "asdf")' \
        --load ${./ocicl-registry.lisp} \
        --eval "(asdf:load-asd \"$PWD/libraries/nasdf/nasdf.asd\")" \
        --eval "(asdf:load-asd \"$PWD/nyxt.asd\")" \
        "$@"
    }
  '';

  buildPhase = ''
    runHook preBuild
    nyxtLisp \
      --eval '(asdf:load-system :nyxt/cef-application)' \
      --eval '(nyxt:prepare-relocatable-libraries)' \
      --eval '(asdf:make :nyxt/cef-application)'
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    PREFIX=$out nyxtLisp --eval '(asdf:make :nyxt/install)'

    appdir=$out/lib/nyxt
    install -Dm755 "$clipboardDir/libcl-clipboard.so" $appdir/usr/bin/libcl-clipboard.so
    mkdir -p $appdir/usr/lib/cef
    for name in ${lib.escapeShellArgs cefRuntime}; do
      cp "$cefBuild/$name" $appdir/usr/lib/cef/
    done
    cp -r "$cefBuild/locales" $appdir/usr/lib/cef/
    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --set APPDIR "$out/lib/nyxt"
      --set CL_CEF_LIBRARY "$out/lib/nyxt/usr/lib/cef/libcl-cef.so"
      --set CL_CLIPBOARD_LIBRARY "$out/lib/nyxt/usr/bin/libcl-clipboard.so"
      --prefix LD_LIBRARY_PATH : "$LD_LIBRARY_PATH"
      --prefix PATH : "${lib.makeBinPath [ xdg-utils ]}"
    )
  '';

  dontStrip = true;
  dontPatchELF = true;

  passthru = { inherit ocicl cef; };

  meta = {
    description = "Infinitely extensible web browser, master branch (CEF renderer)";
    mainProgram = "nyxt";
    homepage = "https://nyxt.atlas.engineer";
    license = lib.licenses.bsd3;
    platforms = [ "x86_64-linux" ];
  };
}
