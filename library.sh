set -euo pipefail

SAFE_MODE=0
YUKINO_HOSTS=("angela" "regina")

readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly RESET='\033[0m'

is_in_safe_mode() {
  [[ $SAFE_MODE -eq 1 ]]
}

parse_common_arguments() {
  for arg in "$@"; do
    [[ "$arg" == "--safe" ]] && SAFE_MODE=1 && break
  done
}

prompt_for_access_token() {
  local client_id="Iv23li2pI9tfnqmfLKDZ"
  local response device_code user_code verification_uri access_token username
  local interval=5 expires_in start_time

  response=$(curl -s -X POST "https://github.com/login/device/code" \
    -H "Accept: application/json" \
    -d "client_id=$client_id&scope=repo")

  device_code=$(echo "$response" | jq -r '.device_code')
  user_code=$(echo "$response" | jq -r '.user_code')
  verification_uri=$(echo "$response" | jq -r '.verification_uri')
  interval=$(echo "$response" | jq -r '.interval // 5')
  expires_in=$(echo "$response" | jq -r '.expires_in')

  echo "Please visit: $verification_uri" >&2
  echo "And enter the code: $user_code" >&2
  echo "This code will expire in $expires_in seconds." >&2

  start_time=$(date +%s)
  while true; do
    sleep "$interval"
    response=$(curl -s -X POST "https://github.com/login/oauth/access_token" \
      -H "Accept: application/json" \
      -d "client_id=$client_id&device_code=$device_code&grant_type=urn:ietf:params:oauth:grant-type:device_code")

    access_token=$(echo "$response" | jq -r '.access_token | select(.!=null)')
    [[ -n $access_token ]] && {
      echo "DEBUG: Access token received" >&2
      break
    }

    error=$(echo "$response" | jq -r '.error | select(.!=null)')
    if [[ -n $error && $error != "authorization_pending" ]]; then
      echo "Error: $error" >&2
      exit 1
    fi

    if (($(date +%s) - start_time >= expires_in)); then
      echo "Authentication timed out. Restarting the process..." >&2
      return $(prompt_for_access_token)
    fi
  done

  username=$(curl -s -H "Authorization: token $access_token" https://api.github.com/user | jq -r .login)

  [[ -z $username ]] && {
    echo "Failed to retrieve username." >&2
    exit 1
  }

  echo "$username $access_token"
}

print_banner() {
  clear
  cat <<'EOF'

  $$\     $$\          $$\       $$\\
  \$$\   $$  |         $$ |      \__|
   \$$\ $$  /$$\   $$\ $$ |  $$\ $$\ $$$$$$$\   $$$$$$\\
    \$$$$  / $$ |  $$ |$$ | $$  |$$ |$$  __$$\ $$  __$$\\
     \$$  /  $$ |  $$ |$$$$$$  / $$ |$$ |  $$ |$$ /  $$ |
      $$ |   $$ |  $$ |$$  _$$<  $$ |$$ |  $$ |$$ |  $$ |
      $$ |   \$$$$$$  |$$ | \$$\ $$ |$$ |  $$ |\$$$$$$  |
      \__|    \______/ \__|  \__|\__|\__|  \__| \______/

EOF

  local safe_mode_message=$(is_in_safe_mode && echo "${GREEN}SAFE-MODE ENABLED${RESET}" || echo "${RED}SAFE-MODE DISABLED${RESET}")

  echo "  ❄️  Yukino (雪乃), The Nix(OS) Flake that powers my system(s)."
  echo -e "     $safe_mode_message"
  echo
}

print_separator() {
  printf '%*s\n' "66" '' | tr ' ' '-'
}

prompt_yes_no() {
  local msg="$1" response
  while true; do
    read -rp "$msg (y/n): " response
    case "${response,,}" in
    y | yes) return 0 ;;
    n | no) return 1 ;;
    *) echo "Please answer yes or no." >&2 ;;
    esac
  done
}

prompt_for_filepath() {
  local msg="$1" filepath
  while true; do
    read -rp "$msg " filepath
    [[ -e "$filepath" ]] && {
      echo "$filepath"
      return 0
    } || echo "File does not exist. Please try again." >&2
  done
}

prompt_choice_from_list() {
  local msg="$1"
  shift
  local options=("$@") choice

  echo "$msg" >&2
  echo >&2

  for i in "${!options[@]}"; do
    printf "%d) %s\n" $((i + 1)) "${options[i]}" >&2
  done

  echo >&2

  while :; do
    read -rp "Select an option [1-${#options[@]}]: " choice
    if [[ "$choice" =~ ^[0-9]+$ ]] && ((choice >= 1 && choice <= ${#options[@]})); then
      echo "${options[choice - 1]}"
      return 0
    else
      echo "Invalid selection. Please try again." >&2
    fi
  done
}

prompt_drive_choice() {
  local drives drive_paths=() drive_descriptions=()

  mapfile -t drives < <(lsblk -d -n -o NAME,SIZE,TYPE | awk '{print "/dev/" $1 " - Size: " $2 " - Type: " $3}')

  for line in "${drives[@]}"; do
    drive_paths+=("$(echo "$line" | awk '{print $1}')")
    drive_descriptions+=("$line")
  done

  local selected_desc=$(prompt_choice_from_list "Available drives:" "${drive_descriptions[@]}")
  local selected_drive=$(echo "$selected_desc" | awk '{print $1}')

  for i in "${!drive_descriptions[@]}"; do
    [[ "${drive_descriptions[i]}" == "$selected_desc" ]] && {
      echo "${drive_paths[i]}"
      return 0
    }
  done

  echo "Error: Selected drive not found." >&2
  exit 1
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  echo "Error: This script should not be executed directly." >&2
  exit 1
fi
