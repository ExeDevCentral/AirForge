# Contributing to rtl8188eu-hotspot-toolkit

Contributions are welcome! Whether reporting a bug, proposing an improvement, adding support for another Realtek/MediaTek chipset, or submitting a pull request, we appreciate your help in building a robust Linux Wi-Fi hotspot ecosystem.

## How to Contribute

1. **Fork the Repository** on GitHub.
2. **Clone your fork**:
   ```bash
   git clone https://github.com/<your-username>/rtl8188eu-hotspot-toolkit.git
   cd rtl8188eu-hotspot-toolkit
   ```
3. **Create a Feature Branch**:
   ```bash
   git checkout -b feat/your-feature-name
   ```
4. **Make Your Changes**:
   - Keep scripts modular, POSIX-friendly, and well-documented.
   - Follow the established color and formatting conventions.
   - Test locally with `bash -n bin/hotspot` and `install.sh`.
5. **Commit Your Changes**:
   - Use [Conventional Commits](https://www.conventionalcommits.org/):
     - `feat:` for new capabilities
     - `fix:` for bug fixes
     - `docs:` for documentation updates
     - `chore:` for build/maintenance
6. **Push and Open a Pull Request**:
   - Provide a clear summary of the changes and test scenarios.
