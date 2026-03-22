# tcode-appimage-nix-wrapper

Off the cuff nix flake for wrapping t3codes AppImage and exposes code-cli to it.

---

## 📦 Usage

### First Run

If you are not logged into codex run this first;

```bash
nix run .#login
```

### Already Authenticated

Run directly from the repository:

```bash
nix run github:daemonfire300/tcode-appimage-nix-wrapper#t3codes
```

Or locally:

```bash
nix run .#t3codes
```

---

## 🔧 Requirements

* Nix with flakes enabled (if you do not know what that means check out `nix + flakes`)


## 📜 License

MIT

---

## 🤝 Contributing

PRs welcome:

* for other platforms
* polish / refactor to this can go into nixpkgs
* CI builds (redundant once in nixpkgs)
