# Define the image name and version
IMAGE?=dozman99/lab-vm-os  # Use a clear variable name and remove the ?:= operator

# Define build targets
TARGETS := kernel rootfs

# Declare phony targets
.PHONY: $(TARGETS) all

# Build the kernel
kernel:
    @echo "Building kernel"
    images/build_kernel.sh

# Build the rootfs using the defined image name
rootfs:
    @echo "Building rootfs for image: $(IMAGE)"
    images/build_rootfs.sh $(IMAGE) #my-rootfs-${uuid}

# Build both kernel and rootfs (default target)
all: $(TARGETS)