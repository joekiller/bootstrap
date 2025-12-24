#!/usr/bin/env bash
set -euo pipefail

USER_NAME="joe"
GITHUB_KEYS_URL="https://github.com/joekiller.keys"

if [[ "${EUID}" -ne 0 ]]; then
  SUDO="sudo"
else
  SUDO=""
fi

if ! id "${USER_NAME}" >/dev/null 2>&1; then
  ${SUDO} useradd --create-home --shell /bin/bash "${USER_NAME}"
fi

HOME_DIR=$(getent passwd "${USER_NAME}" | cut -d: -f6)
SSH_DIR="${HOME_DIR}/.ssh"
AUTHORIZED_KEYS="${SSH_DIR}/authorized_keys"

${SUDO} mkdir -p "${SSH_DIR}"
${SUDO} chmod 700 "${SSH_DIR}"

if command -v curl >/dev/null 2>&1; then
  ${SUDO} curl -fsSL "${GITHUB_KEYS_URL}" -o "${AUTHORIZED_KEYS}"
elif command -v wget >/dev/null 2>&1; then
  ${SUDO} wget -qO- "${GITHUB_KEYS_URL}" > "${AUTHORIZED_KEYS}"
else
  echo "Error: curl or wget is required to fetch SSH keys." >&2
  exit 1
fi
${SUDO} chmod 600 "${AUTHORIZED_KEYS}"
${SUDO} chown -R "${USER_NAME}:${USER_NAME}" "${SSH_DIR}"

SUDOERS_FILE="/etc/sudoers.d/${USER_NAME}"
${SUDO} sh -c "echo '${USER_NAME} ALL=(ALL) NOPASSWD:ALL' > '${SUDOERS_FILE}'"
${SUDO} chmod 440 "${SUDOERS_FILE}"

printf 'User %s configured with SSH keys and passwordless sudo.\n' "${USER_NAME}"
