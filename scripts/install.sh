#!/bin/sh
# Links this checkout into Typst's local package directory, so decks can
# `#import "@local/lab-theme:<version>"`. Re-run after bumping the version.
set -eu

repo=$(cd "$(dirname "$0")/.." && pwd)
version=$(sed -n 's/^version = "\(.*\)"/\1/p' "$repo/typst.toml")

case "$(uname -s)" in
  Darwin) data="$HOME/Library/Application Support" ;;
  *) data="${XDG_DATA_HOME:-$HOME/.local/share}" ;;
esac

dir="$data/typst/packages/local/lab-theme"
mkdir -p "$dir"
ln -sfn "$repo" "$dir/$version"
echo "Linked $dir/$version -> $repo"
