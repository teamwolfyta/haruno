#!/usr/bin/env -S nix shell nixpkgs#bash --command bash

set -o errexit -o nounset -o pipefail

commands=("git" "jq")
for cmd in "${commands[@]}"; do
  command -v "$cmd" &>/dev/null || {
    echo "Error: $cmd is not installed."
    exec /usr/bin/env -S nix shell nixpkgs#bash nixpkgs#curl nixpkgs#git nixpkgs#jq --command bash "$0" "$@"
  }
done

LOCAL_LIBRARY_PATH="$(dirname "$(realpath "$BASH_SOURCE")")/library.sh"
REMOTE_LIBRARY_URL="https://go.wolfyta.dev/yukino/library.sh"

if [[ -f "$LOCAL_LIBRARY_PATH" ]]; then
  source "$LOCAL_LIBRARY_PATH"
else
  TEMPORARY_FILE=$(mktemp)
  trap 'rm -f "$TEMPORARY_FILE"' EXIT
  curl -L -s "$REMOTE_LIBRARY_URL" -o "$TEMPORARY_FILE" || {
    echo "Error: Failed to download library from $REMOTE_LIBRARY_URL" >&2
    exit 1
  }
  source "$TEMPORARY_FILE"
fi

parse_common_arguments "$@"

print_banner
print_separator
echo

cat <<'EOF'
The entire disk will be formatted as follows:
  - 1GB boot partition (label: NIXBOOT)
  - 16GB swap partition (label: NIXSWAP)
  - Remaining space allocated to ZFS (pool name: zroot)

ZFS datasets to be created:
  - zroot/root          (mounted at / with an initial blank snapshot)
  - zroot/nix           (mounted at /nix)
  - zroot/tmp           (mounted at /tmp)
  - zroot/persist       (mounted at /persist)
  - zroot/persist/cache (mounted at /persist/cache)

**IMPORTANT**
Ensure the appropriate "fileSystems" entries are included in your NixOS configuration.
This script does not manage hardware settings or NixOS file system declarations.

Original script by @iynaix, refactored and significantly modified by @TeamWolfyta.
EOF

echo

if ! prompt_for_yes_or_no "Do you understand and accept this?"; then
  echo "Error: User did not accept. Exiting."
  exit 1
fi

print_banner
print_separator
echo

DISK=${DISK:-"/dev/vda"}
[[ ! -b "$DISK" ]] && DISK=$(prompt_for_drive_choice)

print_banner
print_separator
echo

BOOTDISK="${DISK}$(if [[ "$DISK" =~ "nvme" ]]; then echo "p3"; else echo "3"; fi)"
SWAPDISK="${DISK}$(if [[ "$DISK" =~ "nvme" ]]; then echo "p2"; else echo "2"; fi)"
ZFSDISK="${DISK}$(if [[ "$DISK" =~ "nvme" ]]; then echo "p1"; else echo "1"; fi)"

echo "The following partitions will be created on the disk:"
echo -e "\nBoot Partition: $BOOTDISK\nSwap Partition: $SWAPDISK\nZFS Partition: $ZFSDISK\n"

prompt_for_yes_or_no "Warning: This WILL format the disk! Are you sure?" || exit 1
echo

print_banner
print_separator
echo

echo -e "Boot Partition: $BOOTDISK\nSwap Partition: $SWAPDISK\nZFS Partition: $ZFSDISK\n"

if is_in_safe_mode; then
  echo "Info: Safe mode is enabled. Skipping disk formatting and partitioning."
  sleep 5
else
  echo "Info: Starting disk formatting and partitioning..."
  echo

  sudo blkdiscard -f "$DISK"
  sudo sgdisk --clear "$DISK"
  sudo sgdisk -n3:1M:+1G -t3:EF00 -n2:0:+16G -t2:8200 -n1:0:0 -t1:BF01 "$DISK"

  echo "Info: Notifying kernel of partition changes..."
  sudo sgdisk -p "$DISK" >/dev/null
  sleep 5

  echo "Info: Setting up filesystems and swap space..."
  sudo mkswap "$SWAPDISK" -L "NIXSWAP"
  sudo swapon "$SWAPDISK"
  sudo mkfs.fat -F 32 "$BOOTDISK" -n NIXBOOT

  sudo mount --mkdir "$BOOTDISK" /mnt/boot

  echo "Info: Creating ZFS pool and datasets..."
  sudo zpool create -f -o ashift=12 -o autotrim=on -O compression=zstd -O acltype=posixacl -O atime=off -O xattr=sa -O normalization=formD -O mountpoint=none zroot "$ZFSDISK"

  sudo zfs create -o mountpoint=legacy zroot/root
  sudo zfs snapshot zroot/root@blank
  sudo mount -t zfs zroot/root /mnt

  for dataset in nix tmp cache; do
    sudo zfs create -o mountpoint=legacy "zroot/$dataset"
    sudo mount --mkdir -t zfs "zroot/$dataset" "/mnt/$dataset"
  done
  echo

  if prompt_for_yes_or_no "Do you want to load from a persist snapshot?"; then
    echo
    SNAPSHOT_PATH=$(prompt_for_filepath "Enter the snapshot filepath:")
    sudo zfs receive -o mountpoint=legacy zroot/persist <"$SNAPSHOT_PATH"
  else
    sudo zfs create -o mountpoint=legacy zroot/persist
  fi
  sudo mount --mkdir -t zfs zroot/persist /mnt/persist
fi

print_banner
print_separator
echo

read -rp "Enter flake URL (default: github:TeamWolfyta/Yukino): " REPOSITORY
REPOSITORY="${REPOSITORY:-github:TeamWolfyta/Yukino}"
echo

read -rp "Enter GitHub repository ref (default: main): " GIT_REF
GIT_REF="${GIT_REF:-main}"
echo

HOST=$(if [[ "$REPOSITORY" == "github:TeamWolfyta/Yukino" ]]; then prompt_for_choice_from_list "Which host to install?" "${YUKINO_HOSTS[@]}"; else read -rp "Which host to install: "; fi)
echo

NIX_CONFIG=""

if prompt_for_yes_or_no "Would you like to login via GitHub?"; then
  echo
  read -r username access_token < <(prompt_for_access_token)
  NIX_CONFIG="extra-access-tokens = github.com=$access_token"
  echo "Info: Logged in as GitHub user: $username"
fi
echo

print_banner
print_separator
echo

echo -e "Repository: $REPOSITORY\nGit Ref: $GIT_REF\nHost: $HOST\nGitHub Login: ${username:-Not provided}\nPersist Snapshot: ${SNAPSHOT_PATH:-Not used}\nSafe Mode: $(is_in_safe_mode && echo "${GREEN}Enabled${RESET}" || echo "${RED}Disabled${RESET}")\n"

prompt_for_yes_or_no "Are these details correct?" || {
  echo "Error: Aborting installation. Please run the script again with correct details."
  exit 1
}

echo "Info: Starting NixOS installation..."
echo
if is_in_safe_mode; then
  echo "Info: Safe mode enabled. No actions will be executed."
  echo "Would run: NIX_CONFIG=\"$NIX_CONFIG\" sudo nixos-install --no-root-password --flake \"$REPOSITORY/$GIT_REF#$HOST\""
else
  NIX_CONFIG="$NIX_CONFIG" sudo nixos-install --no-root-password --flake "$REPOSITORY/$GIT_REF#$HOST"
fi
echo
