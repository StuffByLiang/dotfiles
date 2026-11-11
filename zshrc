# ---- tmux autostart ----
# Must run BEFORE the p10k instant prompt (which hijacks the terminal during startup).
# Only in interactive iTerm shells, not inside tmux, not in VS Code / scripts.
# Attaches to an existing session or starts one. Detaching (Ctrl-a d) leaves you in a plain shell.
if [[ -o interactive && "$TERM_PROGRAM" == "iTerm.app" && -z "$TMUX" ]] && command -v tmux >/dev/null; then
  tmux attach 2>/dev/null || tmux new-session
fi

# Powerlevel10k instant prompt — keep near the top.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH="$HOME/.local/bin:$PATH"

# Homebrew (Apple Silicon)
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  tmux
  zsh-autosuggestions
  zsh-syntax-highlighting   # must be last
)

ZSH_TMUX_AUTOSTART=false   # handled at the top of this file instead
ZSH_TMUX_FIXTERM=false      # let ~/.tmux.conf decide the TERM

source $ZSH/oh-my-zsh.sh

export EDITOR=vim
export VISUAL=vim

# History
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS SHARE_HISTORY

# ---- fzf: Ctrl-R history search, Ctrl-T file picker, Alt-C cd into dir ----
if command -v fzf >/dev/null; then
  source <(fzf --zsh)
  if command -v rg >/dev/null; then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  fi
  export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
fi

# ---- zoxide: `z foo` jumps to a recent dir matching foo, `zi` picks with fzf ----
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
