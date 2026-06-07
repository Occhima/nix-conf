{ lib, buildNpmPackage, nodejs_24, makeWrapper, fetchFromGitHub, fetchurl }:

# Slopped derivation, but hey.... it works !
let
  version = "0.2.52";

  # Published npm tarball.  Ships pre-built dist/ plus the bundled
  # runtime-workspace.tgz that carries @earendil-works/* and the companion
  # plugin packages.  We reuse both instead of rebuilding from source.
  npmTarball = fetchurl {
    url = "https://registry.npmjs.org/@companion-ai/feynman/-/feynman-${version}.tgz";
    hash = "sha512-f6HypxyRb8pBXB7ZnE0+9AlL0TTsowqxwb2irCSvW9H6o3jwt9zDU2SwrizKm3o0q4mq5MXYeTSb0kuWgZX6gQ==";
  };
in
buildNpmPackage {
  pname = "feynman";
  inherit version;

  # GitHub source only contributes package-lock.json (for reproducible
  # node_modules) and scripts/lib (loaded by patch-embedded-pi.mjs).
  # dist/ and runtime-workspace.tgz come from the npm tarball.
  src = fetchFromGitHub {
    owner = "companion-inc";
    repo = "feynman";
    rev = "ac56c9913cbf6bf122fb33ebe58984daa082232f";
    hash = "sha256-+TZEFIGDaW9qAoeya8f5Db275eaV4nAdLIt9NupN0FI=";
  };

  # nodejs_24 matches the Node version that produced the upstream
  # runtime-workspace.tgz (nodeAbi 137).  Using a different major makes
  # workspaceMatchesRuntime always fail after extraction, which makes feynman
  # fall back to `npm install` and prune the bundled @earendil-works/* deps.
  nodejs = nodejs_24;
  nativeBuildInputs = [ makeWrapper ];

  npmDepsHash = "sha256-cpNXLT0CvFPp3mGvtL/Cc4OiuHaBTX1vKcS5oOuE8zw=";

  # preinstall checks the host Node version; prepack/build run tsc.  Neither
  # is needed when we ship the npm tarball's pre-built dist/.
  npmInstallFlags = [ "--ignore-scripts" "--legacy-peer-deps" ];
  dontNpmBuild = true;

  postPatch = ''
    substituteInPlace scripts/patch-embedded-pi.mjs \
      --replace-fail \
        'ensurePackageWorkspace();' \
        'if (!process.env.FEYNMAN_SKIP_WORKSPACE_SETUP) ensurePackageWorkspace();' \
      --replace-fail \
        'const workspaceRoot = resolve(appRoot, ".feynman", "npm", "node_modules");' \
        'const workspaceRoot = resolve(feynmanHome, "npm", "node_modules");' \
      --replace-fail \
        'const workspaceDir = resolve(appRoot, ".feynman", "npm");' \
        'const workspaceDir = resolve(feynmanHome, "npm");' \
      --replace-fail \
        'const workspaceSetupLockDir = resolve(appRoot, ".feynman", ".workspace-setup.lock");' \
        'const workspaceSetupLockDir = resolve(feynmanHome, ".workspace-setup.lock");' \
      --replace-fail \
        'mkdirSync(resolve(appRoot, ".feynman"), { recursive: true });' \
        'mkdirSync(feynmanHome, { recursive: true });' \
      --replace-fail \
        '"-C", resolve(appRoot, ".feynman")' \
        '"-C", feynmanHome' \
      --replace-fail \
        'const PRUNE_VERSION = 6;' \
        'const PRUNE_VERSION = 6;
    function writeIfChanged(p, content, enc) { try { if (readFileSync(p, enc) === content) return; } catch {} writeFileSync(p, content, enc); }' \
      --replace-fail \
        'writeFileSync(entryPath, cliSource, "utf8")' \
        'writeIfChanged(entryPath, cliSource, "utf8")' \
      --replace-fail \
        'writeFileSync(terminalPath, terminalSource, "utf8")' \
        'writeIfChanged(terminalPath, terminalSource, "utf8")' \
      --replace-fail \
        'writeFileSync(interactiveThemePath, themeSource, "utf8")' \
        'writeIfChanged(interactiveThemePath, themeSource, "utf8")' \
      --replace-fail \
        'writeFileSync(editorPath, editorSource, "utf8")' \
        'writeIfChanged(editorPath, editorSource, "utf8")'
  '';

  postBuild = ''
    tar -xzf ${npmTarball} --strip-components=1 \
      package/dist package/.feynman/runtime-workspace.tgz

    FEYNMAN_HOME=$TMPDIR/feynman-home FEYNMAN_SKIP_WORKSPACE_SETUP=1 \
      ${nodejs_24}/bin/node scripts/patch-embedded-pi.mjs
  '';

  installPhase = ''
    runHook preInstall

    local pkg=$out/lib/node_modules/@companion-ai/feynman
    mkdir -p "$pkg" "$out/bin"

    cp -r dist bin scripts metadata logo.mjs logo.d.mts package.json package-lock.json node_modules "$pkg/"
    cp -r .feynman extensions prompts skills "$pkg/"

    makeWrapper "${nodejs_24}/bin/node" "$out/bin/feynman" \
      --add-flags "$pkg/bin/feynman.js" \
      --prefix PATH : "${nodejs_24}/bin"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Research-first CLI agent built on Pi and alphaXiv";
    homepage = "https://github.com/companion-inc/feynman";
    license = licenses.mit;
    mainProgram = "feynman";
    platforms = platforms.unix;
  };
}
