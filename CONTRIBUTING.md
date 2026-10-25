# Contributing to Baliza 📡

Contributions are welcome! Whether reporting a bug, proposing an improvement, testing across different Linux distributions/kernels, or submitting patches, we appreciate your help in building a robust Linux Wi-Fi hotspot and driver ecosystem.

## How to Contribute

1. **Fork the Repository** on GitHub.
2. **Clone your fork**:
   ```bash
   git clone https://github.com/<your-username>/Baliza.git
   cd Baliza
   ```
3. **Create a Feature Branch**:
   ```bash
   git checkout -b feat/your-feature-name
   ```
4. **Make Your Changes**:
   - Keep scripts modular, POSIX-friendly, and well-documented.
   - For driver patches, place isolated `.patch` files in `patches/` and document them in `patches/README.md`.
   - Validate script syntax locally with:
     ```bash
     bash -n bin/baliza install.sh uninstall.sh
     ```
5. **Commit Your Changes**:
   - Use [Conventional Commits](https://www.conventionalcommits.org/):
     - `feat:` for new capabilities
     - `fix:` for bug fixes
     - `docs:` for documentation and technical report updates
     - `chore:` for build/maintenance
6. **Push and Open a Pull Request**:
   - Provide hardware details (`lsusb`, `uname -r`, distro) and test scenarios.
