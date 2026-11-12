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

ZSH_TMUX_AUTOSTART=false   # no auto-start; run `tmux` yourself
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

# ---- AI CLIs ----
alias claude='claude --dangerously-skip-permissions'
alias codex='codex --dangerously-bypass-approvals-and-sandbox'
export HF_TOKEN=$(security find-generic-password -s huggingface -w 2>/dev/null)   # token lives in Keychain

# grok
export PATH="$HOME/.grok/bin:$PATH"
fpath=(~/.grok/completions/zsh $fpath)
autoload -Uz compinit && compinit -C
