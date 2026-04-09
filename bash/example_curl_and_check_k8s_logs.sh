#!/usr/bin/env bash

#######################################
# Usage / Help
#######################################
usage() {
  cat <<EOF
Usage: $(basename "$0") [options]

Description:
  Sends a test request with a generated correlation ID,
  prints the HTTP status code, and verifies Kubernetes logs
  across relevant components.

Options:
  -h, --help        Show this help message and exit
  --print-curl      Enable verbose curl output (-v):
                    - TLS / certificate negotiation
                    - Request and response headers
                    - Response body
  --print-logs      Print matching kubectl logs when found

Default behaviour:
  - Curl runs silently
  - Only the HTTP status code is printed
  - Log checks only report whether logs exist

Examples:
  ./script.sh
  ./script.sh --print-curl
  ./script.sh --print-logs
  ./script.sh --print-curl --print-logs
EOF
}

#######################################
# Configuration
#######################################
MICROSERVICE=hello
NAMESPACE=myns
CLUSTER_NAME=oidc-ext-sit-mt-co

#######################################
# Colours
#######################################
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
BLUE="\e[34m"
RESET="\e[0m"

#######################################
# Flags (disabled by default)
#######################################
PRINT_LOGS=false
PRINT_CURL=false

for arg in "$@"; do
  case "$arg" in
    -h|--help)
      usage
      exit 0
      ;;
    --print-logs)
      PRINT_LOGS=true
      ;;
    --print-curl)
      PRINT_CURL=true
      ;;
    *)
      echo -e "${YELLOW}Unknown option: ${arg}${RESET}"
      usage
      exit 1
      ;;
  esac
done


#######################################
# Generate Correlation ID
#######################################
CORRELATIONID="$(uuidgen)"
echo "CORRELATION ID: ${CORRELATIONID}"
echo ""

#######################################
# Curl request (single unified call)
#######################################
URL="https://host/api/v1"

echo -e "${GREEN}Sending request...${RESET}"
echo -e "${BLUE}...to ${URL}...${RESET}"

CURL_RESPONSE_FILE="$(mktemp)"
CURL_EXTRA_OPTS=""

# Toggle verbosity
if [[ "${PRINT_CURL}" == "true" ]]; then
  CURL_EXTRA_OPTS="-v"
else
  CURL_EXTRA_OPTS="-s"
fi

HTTP_STATUS="$(
  curl -k ${CURL_EXTRA_OPTS} \
    -o "${CURL_RESPONSE_FILE}" \
    -w "%{http_code}" \
    --request POST "${URL}" \
    --header 'Content-Type: application/xml' \
    --header "correlation-id: ${CORRELATIONID}" \
    --header 'Accept: application/xml' \
    --header "Date: $(LC_ALL=C date -u '+%a, %d %b %Y %H:%M:%S GMT')" \
    --data '<?xml version="1.0" encoding="UTF-8"?>
<tns:myRequest xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:tns="http://www.hmrc.gov.uk/eis/taxud-ufa/exception-message-upload/v1">
	<tns:att>hello content</tns:att>
	</tns:myRequest>
'
)"

if [[ "${HTTP_STATUS}" =~ ^2[0-9]{2}$ ]]; then
  echo -e "${GREEN}HTTP STATUS CODE: ${HTTP_STATUS}${RESET}"
else
  echo -e "${RED}HTTP STATUS CODE: ${HTTP_STATUS}${RESET}"
fi

rm -f "${CURL_RESPONSE_FILE}"

#######################################
# Helper: check logs for correlation id
#######################################

check_logs() {
  local label_selector="$1"
  local component_name="$2"

  echo ""
  echo -e "${GREEN}${component_name} LOGS${RESET}"

  # Capture logs safely (kubectl can legitimately fail)
  local logs
  logs="$(
    kubectl logs \
      -l "${label_selector}" \
      --all-containers=true \
      --ignore-errors=true \
      2>/dev/null \
    | grep "${CORRELATIONID}" --color=always || true
  )"

  echo "kubectl logs -l \"${label_selector}\" --all-containers=true --ignore-errors=true"
  if [[ -n "${logs}" ]]; then
    echo -e "${GREEN}The request ${CORRELATIONID} has logs${RESET}"
    [[ "${PRINT_LOGS}" == "true" ]] && echo "${logs}"
  else
    echo -e "${RED}The request ${CORRELATIONID} has no logs${RESET}"
  fi
}


#######################################
# External cluster log checks
#######################################
echo ""
kubectl config use-context "${CLUSTER_NAME}"
kubectl config set-context --current --namespace "${NAMESPACE}"

check_logs "app.kubernetes.io/name=hello" "MICROSERVICE"
check_logs "app.kubernetes.io/name=proxy" "PROXY"
