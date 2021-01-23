#!/usr/bin/env bash
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
while IFS= read -r line; do
  echo "$line"
  candidate="${line%\=*}"
  version="${line#*\=}"
  sdk install "$candidate" "$version"
  sdk default "$candidate" "$version"
  sdk use "$candidate" "$version"
done <".sdkmanrc"
until sdk env install; do
  sdk env
done
sdk current
