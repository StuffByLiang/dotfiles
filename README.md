# dotfiles

My macOS terminal setup: **zsh + Oh My Zsh + Powerlevel10k**, **tmux**, **vim**, **iTerm2**, **Karabiner-Elements**, plus fzf, zoxide and ripgrep.

## Install on a new Mac

```sh
# 1. Command line tools (git). Click "Install" in the popup.
xcode-select --install

# 2. Clone and run the installer
git clone https://github.com/StuffByLiang/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

`install.sh` is safe to re-run. It:

1. Installs Homebrew (asks for your password) and everything in `Brewfile`
2. Installs Oh My Zsh, Powerlevel10k, zsh-autosuggestions, zsh-syntax-highlighting
3. Symlinks `zshrc`, `p10k.zsh`, `tmux.conf`, `vimrc` and `karabiner/` into place. Existing files are moved to `~/.dotfiles-backup/<timestamp>/`
4. Installs vim plugins
5. Sets fast key repeat and turns off press-and-hold accents
6. Sets the iTerm font and Left Option = Esc+ (only if iTerm is closed)

**Then by hand:**

- Log out and back in so the key repeat setting applies
- Open **Karabiner-Elements** once and allow the driver and Input Monitoring in System Settings → Privacy & Security
- If iTerm was open during install: Settings → Profiles → Text → Font **MesloLGS NF**, and Keys → General → Left Option key **Esc+**

Because the files are symlinks, editing `~/.zshrc` edits the repo. Commit and push to save changes.

## Cheat sheet

### Keyboard
| Key | Does |
|---|---|
| Caps Lock tap / hold | Esc / Ctrl (Karabiner) |

### tmux (run `tmux` to start; prefix is `Ctrl-b`)
| Key | Does |
|---|---|
| `Opt -` / `Opt \|` | split top-bottom / side-by-side |
| `Opt h j k l` | move between panes |
| `Opt u i o p` | resize pane |
| `Opt 1`…`Opt 0` | go to window 1–10 |
| `Opt [` / `Opt ]` | previous / next window |
| `Opt n` | new window |
| `Opt ,` | rename window |
| `Opt z` | zoom pane |
| `Opt s` | scroll / copy mode (same as `Ctrl-b [`; `Opt s` or `q` to exit) |
| `Opt x` | type into all panes at once |
| `Opt w` | kill pane (asks first) |
| `Ctrl h j k l` | move across tmux panes *and* vim splits |
| `Ctrl-b r` | reload config |
| `Ctrl-b d` | detach |
| `Ctrl-b [` | copy mode |

**In scroll / copy mode (vim keys):** `h j k l` move, `Ctrl-u` / `Ctrl-d` half page, `g` / `G` top / bottom, `/` `?` search (`n` / `N` next / prev), `v` select, `V` select line, `Ctrl-v` block select, `y` copy to the macOS clipboard, `Esc` clear selection. The tmux command prompt (`Ctrl-b :`) also uses vim keys.

### Shell
| Key / command | Does |
|---|---|
| `Ctrl-R` | fuzzy-search history |
| `Ctrl-T` | fuzzy-pick a file into the command line |
| `Opt-C` | fuzzy-cd into a subfolder |
| `z foo` | jump to a recent folder matching "foo" |
| `zi` | pick a recent folder interactively |
| `rg pattern` | fast search in files |

### vim (leader is `Space`)
| Key | Does |
|---|---|
| `Space f` | find file |
| `Space /` | search text in project (ripgrep) |
| `Space b` | switch buffer |
| `Space w` / `Space q` | save / quit |
| `gcc` | toggle comment |
