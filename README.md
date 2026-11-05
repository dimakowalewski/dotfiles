# dotfiles

Minimal macOS command-line setup, managed with [GNU Stow](https://www.gnu.org/software/stow/).
Each tool has its own folder (a Stow "package") that mirrors the paths relative to `~`.

## What's inside

| Tool | Purpose | Config location after stowing |
| --- | --- | --- |
| [Ghostty](https://ghostty.org) | Terminal | `~/.config/ghostty/config` |
| [Starship](https://starship.rs) | Prompt | `~/.config/starship.toml` |
| zsh | Shell, plugins, aliases, history | `~/.zshrc` |
| [bat](https://github.com/sharkdp/bat) | `cat` with syntax highlighting | `~/.config/bat/config` |
| git | Global config and global ignore | `~/.config/git/config`, `~/.config/git/ignore` |
| Vim | Terminal editor (no plugin manager) | `~/.vimrc`, `~/.vim/colors/` |
| [mise](https://mise.jdx.dev) | Language runtimes and per-project env | `~/.config/mise/config.toml` |
| [pgcli](https://www.pgcli.com) | Postgres client with autocomplete | `~/.config/pgcli/config` |
| [fd](https://github.com/sharkdp/fd) | Fast `find` replacement | `~/.config/fd/ignore` |

Other tools installed via the Brewfile and wired up in `.zshrc`:

- **zsh-autosuggestions** and **zsh-syntax-highlighting**: suggestions and colors while typing (syntax-highlighting is sourced last)
- **fzf**: fuzzy finder (`Ctrl+R` history, `Ctrl+T` files, `Alt+C` directories). Uses `fd` as its file source, so it skips `.git` and git-ignored paths
- **zoxide**: smarter `cd` (`z foo`, `zi foo`)
- **eza**: modern `ls`, aliased to `ls`, `ll`, `lt`
- **glow**: renders Markdown in the terminal (`glow README.md`, `glow -p` for a pager, `glow` alone to browse the current directory); aliased to `md` as `glow -p`
- **jq**: JSON processor for pipes and API responses (`curl ... | jq .`)
- **Colima**, **docker** and **docker-compose**: CLI-only container setup (Colima runs the Linux VM, no Docker Desktop)
- **lazygit**: terminal UI for git: stage hunks, commit, rebase, browse history (`lazygit`)
- **lazydocker**: terminal UI for containers, logs and stats (`lazydocker`)

## Layout

```
dotfiles/
├── Brewfile
├── fd/.config/fd/ignore
├── ghostty/.config/ghostty/config
├── starship/.config/starship.toml
├── bat/.config/bat/config
├── git/.config/git/config
├── git/.config/git/ignore
├── mise/.config/mise/config.toml
├── pgcli/.config/pgcli/config
├── vim/.vimrc
├── vim/.vim/colors/catppuccin_*.vim
└── zsh/.zshrc
```

Inside each package folder, the path mirrors where the file should end up relative to `~`.
Stow drops the package name and links the rest into the home directory.

## Setting up a new Mac

1. Install Homebrew:

   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. Clone the repo:

   ```bash
   git clone <repo-url> ~/dotfiles
   cd ~/dotfiles
   ```

3. Install everything from the Brewfile (includes `stow` and the Ghostty cask):

   ```bash
   brew bundle
   ```

4. Preview, then create the symlinks:

   ```bash
   stow -n -v fd ghostty starship bat git mise pgcli vim zsh -t ~   # dry run
   stow fd ghostty starship bat git mise pgcli vim zsh -t ~
   ```

5. Install the runtimes mise manages (versions come from `~/.config/mise/config.toml`):

   ```bash
   mise install
   ```

6. Start the container engine and point Docker at the Compose plugin:

   ```bash
   colima start
   ```

   Then add this to `~/.docker/config.json` (create it if missing) so `docker compose` works:

   ```json
   { "cliPluginsExtraDirs": ["/opt/homebrew/lib/docker/cli-plugins"] }
   ```

   If `lazydocker` can't reach the daemon, export the Colima socket in `~/.zshrc`
   (replace `default` with the profile name if you use a named profile):

   ```bash
   export DOCKER_HOST="unix://$HOME/.colima/default/docker.sock"
   ```

7. Create the folders Vim uses for undo, swap and backup files (referenced in `.vimrc`):

   ```bash
   mkdir -p ~/.vim/undo ~/.vim/swap ~/.vim/backup
   ```

8. Create the notes folder:

    ```bash
    mkdir ~/notes
    ```

9. Open a new terminal, or run `source ~/.zshrc`.

If Stow reports "existing target is not owned by stow", move or delete the existing file at that location and run it again.

## Day-to-day

- Edit configs in `~/dotfiles`. The symlinks mean the changes apply immediately.
- Reload Ghostty with `Cmd+Shift+,`. Reload the shell with `source ~/.zshrc`.
- After installing a new tool, compare the installed state with the Brewfile instead of overwriting it, so the file stays curated:

  ```bash
  brew bundle dump --file=/tmp/Brewfile --force
  diff ~/dotfiles/Brewfile /tmp/Brewfile
  ```

  Copy over only the lines you want, then commit:

  ```bash
  cd ~/dotfiles && git add -A && git commit -m "Update Brewfile" && git push
  ```

  To list installed packages that aren't in the Brewfile: `brew bundle cleanup --file=~/dotfiles/Brewfile`
  (add `--force` to actually remove them).

- To remove a package's links: `stow -D <package>`.

## Notes

- **Secrets:** never commit tokens, API keys, or `.env` files. Machine-specific or private settings go in `~/.zshrc.local`, which `.zshrc` sources if it exists and which is not tracked.
- **Git identity:** set `user.name` and `user.email` in the git config. Keep the repo private if they're included.
- **Ghostty via Homebrew:** if Ghostty was installed manually first, adopt it with `brew install --cask --adopt ghostty`. macOS may need App Management permission for the terminal you run it from.
- **Vim plugins:** none are tracked in this repo. Plugins, if any, are cloned into `~/.vim/pack/plugins/start/` by hand.
- **Vim theme:** the [Catppuccin](https://github.com/catppuccin/vim) colorschemes are vendored in `vim/.vim/colors/` (single files, no plugin needed). `.vimrc` uses Latte in light mode and Frappé in dark mode, like Zed, and follows the macOS appearance live by checking `defaults read -g AppleInterfaceStyle` every few seconds. Change `g:theme_light` / `g:theme_dark` in `.vimrc` to pick other flavors. To update the themes, copy `colors/*.vim` from a fresh clone of that repo.
- **mise:** keep a global default Node in `~/.config/mise/config.toml` (`mise use -g node@lts`). Without one, the `npm` shim fails outside a project, and `brew bundle dump` errors out because it runs `npm list -g`.
- **Docker:** `~/.docker/config.json` is not tracked, because it can hold registry credentials after `docker login`. Stop the VM with `colima stop` when not in use to free RAM; `brew services start colima` starts it at login.
- **lazygit:** reads the same global git config, so settings like the pager (e.g. delta) carry over. Its config is optional; on macOS it defaults to `~/Library/Application Support/lazygit/`, so set `XDG_CONFIG_HOME="$HOME/.config"` in `.zshrc` (or `LG_CONFIG_FILE`) if you want it under `~/.config/lazygit/`. Press `?` inside for keybindings.
- **glow:** renders Markdown only for reading; use `bat` when you want the raw source with syntax highlighting. Its config is optional (`glow config` creates `glow.yml`; the location varies by OS, so check the path it prints before stowing it).
- **pgcli:** `~/.pgpass` (mode `600`) holds database passwords and is not tracked. Don't put passwords in DSN aliases inside the stowed `config`. Give each project's Postgres a different host port (5432, 5433, ...) so they can run side by side.
- **fd:** `~/.config/fd/ignore` lists patterns skipped everywhere, even outside git repos (`.DS_Store`, `node_modules`, `.git`).
- **zoxide data** lives in `~/Library/Application Support/zoxide` and is machine-specific, so it isn't in this repo.
