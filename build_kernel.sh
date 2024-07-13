#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# Define default kernel version (optional)
KERNEL_VERSION=${KERNEL_VERSION:-"5.10.218"}
INSTALL_DIR=${INSTALL_DIR:-"/srv/vm/filesystems/"}

# Define log file location (adjust path as needed)
LOG_FILE="/var/log/build_kernel.log"

# Function to log messages and exit with a message
log_error() {
  msg="$1"
  echo "[ERROR] $msg" >> "$LOG_FILE" 2>&1
  echo ">> Error: $msg" >&2  # Write error message to stderr
  exit 1
}

# Function to log informational messages
log_info() {
  msg="$1"
  echo "[INFO] $msg" >> "$LOG_FILE" 2>&1
  echo "$msg"
}

# Function to download the kernel source
download_kernel_source() {
  # Informative message
  log_info "Downloading kernel source version ${KERNEL_VERSION}"

  # Base URL for kernel source downloads
  local url_base="https://cdn.kernel.org/pub/linux/kernel"

  # Construct download URL (consider using URL construction tools for flexibility)
  local download_url="${url_base}/v5.x/linux-${KERNEL_VERSION}.tar.xz"

  # Download the kernel source archive with progress indicator
  curl -Lfo "linux-${KERNEL_VERSION}.tar.xz" "$download_url" 2>> "$LOG_FILE" || log_error "Failed to download kernel source"
}

# Function to extract the kernel source
extract_kernel_source() {
  log_info ">> Extracting kernel source"

  # Create directory for extracted source (consider using mktemp for temporary directory)
  mkdir -p "linux-${KERNEL_VERSION}" 2>> "$LOG_FILE" || log_error "Failed to create directory for extracted source"
  mkdir -p "${INSTALL_DIR}/linux-${KERNEL_VERSION}" 2>> "$LOG_FILE" || log_error "Failed to create directory for installed source"

  # Extract the archive with options for efficiency
  tar --skip-old-files --strip-components=1 -xf "linux-${KERNEL_VERSION}.tar.xz" -C ${INSTALL_DIR}/linux-${KERNEL_VERSION} 2>> "$LOG_FILE" || log_error "Failed to extract kernel source"
}

# Function to build the kernel
build_kernel() {
  log_info ">> Building the kernel"

  # Change directory to the extracted source
  cd ${INSTALL_DIR}/linux-${KERNEL_VERSION} || { log_error "Failed to change directory"; }

  # Configure the kernel (consider using specific configuration options)
  make defconfig 2>> "$LOG_FILE" || log_error "Failed to configure kernel"

  # Build the kernel using parallel jobs based on available processors
  make -j "$(nproc)" 2>> "$LOG_FILE" || log_error "Failed to build kernel"

  # (Optional) Handle kernel image placement outside the script
  # This script focuses on building, not deployment.
}

# Call the functions sequentially
download_kernel_source
extract_kernel_source
build_kernel

echo ">> Kernel build completed!" >> "$LOG_FILE"
echo ">> Kernel build completed!"
