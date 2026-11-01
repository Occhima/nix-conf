set -euo pipefail

out=$2
work=$(mktemp -d)
csv=$work/ocicl.csv
awk -F', ' '$1 != "nasdf" && $1 != "nyxt" && $1 !~ /^nyxt\//' "$1" > "$csv"
mkdir -p "$out"

cut -d, -f2 "$csv" | tr -d ' ' | sort -u | while read -r ref; do
  case $ref in
    git+*)
      url=${ref:4}
      url=$(printf '%s' "$url" | cut -d '#' -f 1)
      rev=${url##*@}
      url=${url%@*}
      dir=$out/$(basename "$url")-${rev:0:7}
      git init -q --bare "$work/$rev"
      git -C "$work/$rev" fetch -q --depth 1 "$url" "$rev"
      mkdir -p "$dir"
      git -C "$work/$rev" archive FETCH_HEAD | tar -x -C "$dir"
      ;;
    ghcr.io/*)
      repo=${ref:8}
      digest=$(printf '%s' "$repo" | cut -d @ -f 2)
      repo=${repo%@*}
      token=$(curl -fsS "https://ghcr.io/token?scope=repository:$repo:pull" | jq -r .token)
      auth="Authorization: Bearer $token"
      accept="Accept: application/vnd.oci.image.manifest.v1+json"
      manifest="https://ghcr.io/v2/$repo/manifests/$digest"
      layer=$(curl -fsSL -H "$auth" -H "$accept" "$manifest" | jq -r '.layers[0].digest')
      curl -fsSL -H "$auth" "https://ghcr.io/v2/$repo/blobs/$layer" | tar -xz -C "$out"
      ;;
    *)
      echo "unsupported ocicl source: $ref" >&2
      exit 1
      ;;
  esac
done

cut -d, -f3 "$csv" | tr -d ' ' | while read -r asd; do
  test -f "$out/$asd" || { echo "missing $asd" >&2; exit 1; }
done
