#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# Define default kernel version (optional)
KERNEL_VERSION=${KERNEL_VERSION:-"5.10.218"}
INSTALL_DIR=${INSTALL_DIR:-"/srv/vm/filesystems/"}


# Function to download the kernel source
download_kernel_source() {
  # Informative message
  echo ">> Downloading kernel source version ${KERNEL_VERSION}"

  # Base URL for kernel source downloads
  local url_base="https://cdn.kernel.org/pub/linux/kernel"

  # Construct download URL (consider using URL construction tools for flexibility)
  local download_url="${url_base}/v5.x/linux-${KERNEL_VERSION}.tar.xz"

  # Download the kernel source archive with progress indicator
  curl -Lfo "linux-${KERNEL_VERSION}.tar.xz" "$download_url" || { echo "Failed to download kernel source"; exit 1; }
}

# Function to extract the kernel source
extract_kernel_source() {
  echo ">> Extracting kernel source"

  # Create directory for extracted source (consider using mktemp for temporary directory)
  mkdir -p "linux-${KERNEL_VERSION}"
  mkdir -p "${INSTALL_DIR}/linux-${KERNEL_VERSION}"

  # Extract the archive with options for efficiency
  tar --skip-old-files --strip-components=1 -xf "linux-${KERNEL_VERSION}.tar.xz" -C ${INSTALL_DIR}/linux-${KERNEL_VERSION} || { echo "Failed to extract kernel source"; exit 1; }
}

# Function to build the kernel
build_kernel() {
  echo ">> Building the kernel"

  # Change directory to the extracted source
  cd ${INSTALL_DIR}/linux-${KERNEL_VERSION} || { echo "Failed to change directory"; exit 1; }

  # Configure the kernel (consider using specific configuration options)
  make defconfig

  # Build the kernel using parallel jobs based on available processors
  make -j "$(nproc)"

  # (Optional) Handle kernel image placement outside the script
  # This script focuses on building, not deployment.
}

# Call the functions sequentially
download_kernel_source
extract_kernel_source
build_kernel

echo ">> Kernel build completed!"
