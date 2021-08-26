#!/bin/bash
#
# truffleproc — hunt secrets in process memory // 2021 @controlplaneio

set -Eeuo pipefail

PID="${1:-1}"
TMP_DIR="$(mktemp -d)"
STRINGS_FILE="${TMP_DIR}/strings.txt"
RESULTS_FILE="${TMP_DIR}/results.txt"

CONTAINER_IMAGE="controlplane/build-step-git-secrets"
CONTAINER_SHA="sha256:51cfc58382387b164240501a482e30391f46fa0bed317199b08610a456078fe7"
CONTAINER="${CONTAINER_IMAGE}@${CONTAINER_SHA}"

main() {
  ensure_sudo

  echo "# coredumping pid ${PID}"

  coredump_pid

  echo "# extracting strings to ${TMP_DIR}"

  extract_strings_from_coredump

  echo "# finding secrets"

  find_secrets_in_strings || true

  echo "# results in ${RESULTS_FILE}"

  less -N -R "${RESULTS_FILE}"
}

ensure_sudo() {
  sudo touch /dev/null
}

coredump_pid() {
  cd "${TMP_DIR}"

  sudo grep -Fv ".so" "/proc/${PID}/maps" | awk '/ 0 /{print $1}' | (
    IFS="-"
    while read -r START END; do
      START_ADDRESS=$(printf "%llu" "0x${START}")
      END_ADDRESS=$(printf "%llu" "0x${END}")
      sudo gdb \
        --quiet \
        --readnow \
        --pid "${PID}" \
        -ex "dump memory ${PID}_mem_${START}.bin ${START_ADDRESS} ${END_ADDRESS}" \
        -ex "set confirm off" \
        -ex "set exec-file-mismatch off" \
        -ex quit od |& grep -E "^Reading symbols from"
    done | awk-unique
  )
}

extract_strings_from_coredump() {
  strings "${TMP_DIR}"/*.bin >"${STRINGS_FILE}"
}

find_secrets_in_strings() {
  local DATE MESSAGE
  DATE="($(date --utc +%FT%T.%3NZ))"
  MESSAGE="for pid ${PID}"

  cd "${TMP_DIR}"
  git init --quiet
  git add "${STRINGS_FILE}"
  git -c commit.gpgsign=false commit \
    -m "Coredump of strings ${MESSAGE}" -m "https://github.com/controlplaneio/truffleproc" \
    --quiet

  echo "# ${0} results ${MESSAGE} ${DATE} | @controlplaneio" >>"${RESULTS_FILE}"

  docker run -i -e IS_IN_AUTOMATION= \
    -v "$(git rev-parse --show-toplevel):/workdir:ro" \
    -w /workdir \
    "${CONTAINER}" \
    bash |& command grep -P '\e\[' | awk-unique >> "${RESULTS_FILE}"
}

awk-unique() {
  awk '!x[$0]++'
}

main "${@:-}"
