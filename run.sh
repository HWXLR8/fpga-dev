#!/usr/bin/env bash
set -euo pipefail

VIVADO_VERSION="2026.1"
INSTALL_DIR="${HOME}/xilinx-install"
LICENSE_DIR="${HOME}/xilinx-license"
PROJ_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/proj"
IMAGE_NAME="vivado-base:${VIVADO_VERSION}"

mkdir -p "${PROJ_DIR}"

docker run --rm -it \
    --network host \
    -v "${INSTALL_DIR}:/opt/Xilinx" \
    -v "${PROJ_DIR}:/proj" \
    -v "${LICENSE_DIR}:/root/.Xilinx" \
    -e XILINXD_LICENSE_FILE=/root/.Xilinx \
    "${IMAGE_NAME}" bash
