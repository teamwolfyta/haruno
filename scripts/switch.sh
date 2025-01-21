#!/usr/bin/env -S nix shell nixpkgs#bash --command bash
# shellcheck shell=bash

set -o errexit -o nounset -o pipefail

commands=("git" "jq")
for cmd in "${commands[@]}"; do
  command -v "$cmd" &>/dev/null || exec /usr/bin/env -S nix --extra-experimental-features "nix-command flakes" shell nixpkgs#bash nixpkgs#curl nixpkgs#git nixpkgs#jq --command bash "$0" "$@"
done

LOCAL_LIBRARY_PATH="$(dirname "$(realpath "${BASH_SOURCE[0]}")")/library.sh"
REMOTE_LIBRARY_URL="https://go.wolfyta.dev/yukino/library.sh"

if [[ -f $LOCAL_LIBRARY_PATH ]]; then
  # shellcheck source=/dev/null
  source "$LOCAL_LIBRARY_PATH"
else
  TEMPORARY_FILE=$(mktemp)
  trap 'rm -f "$TEMPORARY_FILE"' EXIT
  curl -L -s "$REMOTE_LIBRARY_URL" -o "$TEMPORARY_FILE" || {
    echo "Error: Failed to download library from $REMOTE_LIBRARY_URL" >&2
    exit 1
  }
  # shellcheck source=/dev/null
  source "$TEMPORARY_FILE"
fi

parse_common_arguments "$@"

print_banner
print_separator
echo

cat <<'EOF'
Something will be written here eventually, I just need this script now!
EOF

echo

if ! prompt_for_yes_or_no "Do you understand and accept this?"; then
  echo "Error: User did not accept. Exiting."
  exit 1
fi

print_banner
print_separator
echo

NIX_ACCESS_TOKENS=""

if prompt_for_yes_or_no "Would you like to login via GitHub?"; then
  echo
  read -r username access_token < <(prompt_for_access_token)
  NIX_ACCESS_TOKENS="github.com=$access_token"
  echo "Info: Logged in as GitHub user: $username"
fi
echo

read -rp "Enter flake URL (default: github:TeamWolfyta/Yukino): " REPOSITORY
REPOSITORY="${REPOSITORY:-github:TeamWolfyta/Yukino}"
echo

read -rp "Enter GitHub repository ref (default: main): " GIT_REF
GIT_REF="${GIT_REF:-main}"
echo

HOST=$(if [[ $REPOSITORY == "github:TeamWolfyta/Yukino" ]]; then prompt_for_choice_from_list "Which host to install?" "${YUKINO_HOSTS[@]}"; else read -rp "Which host to install: "; fi)
echo

print_banner
print_separator
echo

echo -e "Repository: $REPOSITORY\nGit Ref: $GIT_REF\nHost: $HOST\nGitHub Login: ${username:-Not provided}\nSafe Mode: $(is_in_safe_mode && echo "${GREEN}Enabled${RESET}" || echo "${RED}Disabled${RESET}")\n"

prompt_for_yes_or_no "Are these details correct?" || {
  echo "Error: Aborting installation. Please run the script again with correct details."
  exit 1
}

echo "Info: Starting NixOS installation..."
echo
if is_in_safe_mode; then
  echo "Info: Safe mode enabled. No actions will be executed."
  echo "Would run: sudo nixos-rebuild switch --option access-tokens \"$NIX_ACCESS_TOKENS\" --option tarball-ttl \"0\" --flake \"$REPOSITORY/$GIT_REF#$HOST\""
else
  sudo nixos-rebuild switch --option access-tokens "$NIX_ACCESS_TOKENS" --option tarball-ttl "0" --flake "$REPOSITORY/$GIT_REF#$HOST"
fi
echo
