## dozctl: Manage Firecracker VMs with Automatic Downloading and CNI Networking

**dozctl** is a comprehensive command-line tool written in bash to streamline the management of Firecracker VMs. It simplifies the process of pulling VM images (kernels and rootfs), deploying VMs with CNI networking, and managing their lifecycle.

**Key Features:**

* **Automatic Downloading:**  dozctl simplifies VM setup by automatically downloading kernel and rootfs images based on configurations.
* **CNI Networking Integration:** Manages network configuration for VMs by integrating with CNI plugins, ensuring seamless network connectivity.
* **VM Lifecycle Management:** Provides functionalities to create, stop, and destroy Firecracker VMs, offering complete control over VM lifecycles.
* **Simplified Workflow:** Streamlines the overall workflow for deploying and managing Firecracker VMs, reducing complexity.
* **Error Handling & Dependency Checks:** Includes basic error handling and dependency checks to ensure smooth operation.

**Benefits:**

* **Faster VM Setup:** Automates VM image downloads, accelerating the VM deployment process.
* **Effortless Network Configuration:** Leverages CNI plugins for network management, eliminating manual configuration.
* **Efficient VM Management:** Provides a single tool for all VM lifecycle operations, enhancing management efficiency.
* **Reduced Complexity:** Simplifies Firecracker VM deployments, making them more accessible.

**Getting Started:**

1. Clone the dozctl repository (replace `<URL dozctl git>` with the actual URL).

   ```bash
   git clone <URL dozctl git>
