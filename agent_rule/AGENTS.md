# Agent Instructions for [Jason Kuan/Senior Engineer]

## 👤 User Profile
- **Role:** Senior Software Engineer (Taiwan-based).
- **Environment:** NixOS (Immutable infrastructure), Neovim (Keyboard-centric workflow).
- **Preference:** High-precision, idiomatic code, and minimal bloat.

## 🛠 Tech Stack & Environment Rules
- **NixOS First:** Never suggest `sudo apt-get` or `pip install` globally. Always provide a `nix-shell` snippet or a Flake output.
- **Neovim Integration:** When discussing IDE features, focus on LSP servers, Lua configuration, and terminal-based workflows.
- **Pure Functions:** Prefer functional programming patterns and immutable data structures when applicable.

## 💻 Coding Standards
- **DRY & KISS:** Prioritize readability and maintainability.
- **Type Safety:** Always include types/interfaces (Rust, Go, C++, etc.) without being asked.
- **Documentation:** Use JSDoc, Rustdoc, or similar standards for public APIs.

## 🛠 Project Workflow
- **Standard Tooling:** Every project strictly includes `flake.nix` for environment orchestration and a `Makefile` for task automation.
- **Workflow Integration:** - When adding dependencies, suggest the corresponding Nix flake input or attribute.
    - When suggesting commands (build, test, deploy), encapsulate them into `Makefile` targets.
    - Assume the use of `nix develop` or `direnv` to enter the development shell.

## 🚀 Language-Specific Rules
- **Golang**: Follow standard project layouts. Use `Context` for concurrency control. Ensure rigorous error handling and idiomatic code (as per `effective go`).
- **Python**: Prefer modern syntax (3.10+). Strict use of Type Hints is required. Address dependency management via Nix-compatible tools like `poetry2nix` or `mach-nix`.
- **C++**: Focus on Modern C++ (C++17/20). Emphasize RAII and memory safety. Provide `CMakeLists.txt` or Nix derivations for build configurations.
- **Bash**: Write robust scripts with `set -euo pipefail`. Prioritize readability and use `shellcheck`-compliant patterns.

## 💬 Communication Style
- **Concise:** No fluff. Get straight to the technical solution.
- **Technical Depth:** Assume I understand OS-level concepts (kernel, systemd, nix-store).
- **Language:** Default to Traditional Chinese (Taiwan) for explanations, but keep technical terms in English.

## 🚫 Constraints
- Avoid bloated frameworks if a lightweight alternative exists.
- Do not suggest GUI-based tools unless they are strictly necessary.
- If a task involves system configuration, assume it must be managed via `/etc/nixos/` or Home Manager.
