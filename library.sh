set -o errexit -o nounset -o pipefail

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
    [[ "$arg" == "--safe" ]] && {
      SAFE_MODE=1
      break
    }
  done
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

  echo -e "  ❄️  Yukino (雪乃), The Nix(OS) Flake that powers my system(s).\n     $(is_in_safe_mode && echo "${GREEN}SAFE-MODE ENABLED${RESET}" || echo "${RED}SAFE-MODE DISABLED${RESET}")\n"
}

print_separator() {
  printf '%*s\n' "66" '' | tr ' ' '-'
}

prompt_for_yes_or_no() {
  local msg="$1" response
  while true; do
    read -rp "$msg (y/n): " response
    case "${response,,}" in
    y | yes) return 0 ;;
    n | no) return 1 ;;
    *) echo "Error: Invalid response. Please answer yes or no." >&2 ;;
    esac
  done
}

prompt_for_filepath() {
  local msg="$1" filepath
  while true; do
    read -rp "$msg " filepath
    if [[ -e "$filepath" ]]; then
      echo "$filepath"
      return 0
    else
      echo "Error: File does not exist. Please try again." >&2
    fi
  done
}

prompt_for_choice_from_list() {
  local msg="$1" options=("${@:2}") choice
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
      echo "Error: Invalid selection. Please try again." >&2
    fi
  done
}

prompt_for_access_token() {
  local client_id="Iv23li2pI9tfnqmfLKDZ" response device_code user_code verification_uri access_token username
  local interval=5 expires_in start_time

  response=$(curl -s -X POST "https://github.com/login/device/code" -H "Accept: application/json" -d "client_id=$client_id&scope=repo")
  device_code=$(echo "$response" | jq -r '.device_code')
  user_code=$(echo "$response" | jq -r '.user_code')
  verification_uri=$(echo "$response" | jq -r '.verification_uri')
  interval=$(echo "$response" | jq -r '.interval // 5')
  expires_in=$(echo "$response" | jq -r '.expires_in')

  echo "Please visit: $verification_uri" >&2
  echo "And enter the code: $user_code" >&2
  echo "Note: This code will expire in $expires_in seconds." >&2

  start_time=$(date +%s)
  while true; do
    sleep "$interval"
    response=$(curl -s -X POST "https://github.com/login/oauth/access_token" -H "Accept: application/json" -d "client_id=$client_id&device_code=$device_code&grant_type=urn:ietf:params:oauth:grant-type:device_code")

    access_token=$(echo "$response" | jq -r '.access_token // empty')
    if [[ -n $access_token ]]; then
      echo "DEBUG: Access token received." >&2
      break
    fi

    local error_message
    error_message=$(echo "$response" | jq -r '.error // empty')
    if [[ "$error_message" == "slow_down" ]]; then
      echo "Warning: Rate limit exceeded. Waiting for a while before retrying..." >&2
      sleep $((interval * 2))
      continue
    elif [[ "$error_message" != "authorization_pending" ]]; then
      echo "Error: $error_message" >&2
      exit 1
    fi

    if (($(date +%s) - start_time >= expires_in)); then
      echo "Error: Authentication timed out. Restarting the process..." >&2
      return $(prompt_for_access_token)
    fi
  done

  username=$(curl -s -H "Authorization: token $access_token" https://api.github.com/user | jq -r .login)
  if [[ -z $username ]]; then
    echo "Error: Failed to retrieve username." >&2
    exit 1
  fi

  echo "$username $access_token"
}

prompt_for_drive_choice() {
  local drives drive_paths=() drive_descriptions=()
  mapfile -t drives < <(lsblk -d -n -o NAME,SIZE,TYPE | awk '{print "/dev/" $1 " - Size: " $2 " - Type: " $3}')

  for line in "${drives[@]}"; do
    drive_paths+=("$(echo "$line" | awk '{print $1}')")
    drive_descriptions+=("$line")
  done

  local selected_desc
  selected_desc=$(prompt_for_choice_from_list "Available drives:" "${drive_descriptions[@]}")
  local selected_drive
  selected_drive=$(echo "$selected_desc" | awk '{print $1}')

  for i in "${!drive_descriptions[@]}"; do
    if [[ "${drive_descriptions[i]}" == "$selected_desc" ]]; then
      echo "${drive_paths[i]}"
      return 0
    fi
  done

  echo "Error: Selected drive not found." >&2
  exit 1
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  echo "Error: This script should not be executed directly." >&2
  exit 1
fi
