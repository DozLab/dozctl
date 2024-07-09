#!/usr/bin/env bash

## build_rootfs.sh builds an ext4 filesystem image from a Docker container.

set -o pipefail
set -o nounset
set -o errexit

# Function to handle errors and exit with a message
error_exit() {
  echo ">> Error: $1"
  exit 1
}

# Get container name and target image name from arguments
container_name="$1"
image_name="${2}.ext4"

# Create temporary directory
MOUNTDIR=$(mktemp -d) || error_exit "Failed creating temporary directory"

# Create and format disk image
qemu-img create -f raw "$image_name" 800M || error_exit "Failed creating disk image"
mkfs.ext4 "$image_name" || error_exit "Failed formatting disk image"

# Mount the disk image
sudo mount "$image_name" "$MOUNTDIR" || error_exit "Failed mounting disk image"

# Run container and capture ID
CONTAINER_ID=$(docker run -d "$container_name" /bin/bash) || error_exit "Failed running container"

# Copy container filesystem and extract files
sudo docker cp "$CONTAINER_ID:/" "$MOUNTDIR" || error_exit "Failed copying container content"
cd ./files/ && sudo tar cf - . | (cd "$MOUNTDIR" && sudo tar xvf -) || error_exit "Failed extracting files"

# Create directories (ROM, overlay)
sudo mkdir -p "$MOUNTDIR/rom" "$MOUNTDIR/overlay" || error_exit "Failed creating directories"

# Set ownership of all files/directories
sudo chown root:root "$MOUNTDIR/"* || error_exit "Failed setting ownership"

# Cleanup
sudo umount "$MOUNTDIR" || error_exit "Failed unmounting disk image"
rm -rf "$MOUNTDIR" || error_exit "Failed removing temporary directory"
docker rm -f "$CONTAINER_ID" || error_exit "Failed removing container"

echo ">> Done"
