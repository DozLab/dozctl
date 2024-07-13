#!/usr/bin/env bash

## build_rootfs.sh builds an ext4 filesystem image from a Docker container.

set -o pipefail
set -o nounset
set -o errexit

# Define log file location (adjust path as needed)
LOG_FILE="/var/log/build_rootfs.log"

# Function to log messages and exit with a message
log_error() {
  msg="$1"
  echo "[ERROR] $msg" >> "$LOG_FILE" 2>&1
  rm -f $image_name
  echo ">> Error: $msg" >&2  # Write error message to stderr
  exit 1
}

# Function to log informational messages
log_info() {
  msg="$1"
  echo "[INFO] $msg" >> "$LOG_FILE" 2>&1
  echo "$msg"
}

# Get container name and target image name from arguments
container_name="$1"
FILESYSTEMS_DIR="/srv/vm/filesystems"
################################put a default value with the unique ID################################
image_name="${FILESYSTEMS_DIR}/${2}.ext4"

# Log script start
log_info "Script execution started."

# Create temporary directory
MOUNTDIR=$(mktemp -d) || log_error "Failed creating temporary directory"

# Create and format disk image # but note that disk size for k8 lab is 1200
qemu-img create -f raw "$image_name" 1200M 2>> "$LOG_FILE" || log_error "Failed creating disk image"
mkfs.ext4 "$image_name" 2>> "$LOG_FILE" || log_error "Failed formatting disk image"

# Mount the disk image
sudo mount "$image_name" "$MOUNTDIR" 2>> "$LOG_FILE" || log_error "Failed mounting disk image"

# Run container and capture ID
CONTAINER_ID=$(sudo docker run -d "$container_name" /bin/bash 2>> "$LOG_FILE") || log_error "Failed running container"

# Copy container filesystem and extract files
sudo docker cp "$CONTAINER_ID:/" "$MOUNTDIR" 2>> "$LOG_FILE" || log_error "Failed copying container content"
pushd images/files/
sudo tar cf - . | (cd "$MOUNTDIR" && sudo tar xvf -) 2>> "$LOG_FILE" || log_error "Failed extracting files"
popd

# Create directories (ROM, overlay)
sudo mkdir -p "$MOUNTDIR/rom" "$MOUNTDIR/overlay" 2>> "$LOG_FILE" || log_error "Failed creating directories"

# Set ownership of all files/directories
sudo chown root:root "$MOUNTDIR/"* 2>> "$LOG_FILE" || log_error "Failed setting ownership"

# Cleanup
sudo umount "$MOUNTDIR" 2>> "$LOG_FILE" || log_error "Failed unmounting disk image"
rm -rf "$MOUNTDIR" 2>> "$LOG_FILE" || log_error "Failed removing temporary directory"
sudo docker rm -f "$CONTAINER_ID" 2>> "$LOG_FILE" || log_error "Failed removing container"




####### it will have a function in here that make these changes into a file

log_info "Script execution completed successfully."

echo ">> Done"
