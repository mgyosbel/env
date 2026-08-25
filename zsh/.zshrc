# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export PATH=/opt/homebrew/bin:$PATH
export PATH=$HOME/bin:$HOME/.cargo/bin:/usr/local/bin:$HOME/.local/bin:/usr/bin:$HOME/dev/go/bin:$PATH
export PATH=$PATH:/opt/nvim-linux-x86_64/bin
export K9S_CONFIG_DIR=$HOME/.config/k9s
# Secrets/tokens are kept out of version control in ~/.zshrc.local
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/yosbel.martinez/.docker/completions $fpath)
# autoload -Uz compinit
# compinit
# End of Docker CLI completions
# B. Braun Zscaler proxy settings for Copilot CLI, git, curl, etc.
# export HTTP_PROXY="http://localhost:9000"
# export HTTPS_PROXY="http://localhost:9000"
# export NO_PROXY="docker.service.internal,localhost,127.0.0.1,.bbraun.ghe.com"
# export NODE_EXTRA_CA_CERTS=~/Downloads/zscaler-cacert.pem
# export NODE_TLS_REJECT_UNAUTHORIZED=0

export SOFTHSM2_CONF=/Users/yosbel.martinez/softhsm2/softhsm2.conf

export EDITOR=nvim
export PKG_CONFIG_PATH=/opt/homebrew/lib/pkgconfig:/opt/homebrew/share/pkgconfig:/usr/local/lib/pkgconfig:/usr/lib/pkgconfig:/opt/homebrew/Library/Homebrew/os/mac/pkgconfig/15

# --- fast cached tool init -------------------------------------------------
# Caches a tool's shell-init output to a file so we don't spawn the tool on
# every shell start. Regenerates automatically when the tool binary is newer
# than the cache. Usage: _load_cached <cache-name> <command> [args...]
ZSH_CACHE_DIR="$HOME/.cache/zsh"; [[ -d $ZSH_CACHE_DIR ]] || mkdir -p "$ZSH_CACHE_DIR"
_load_cached() {
  emulate -L zsh
  local name=$1; shift
  local bin=${commands[$1]:-$1}
  local f="$ZSH_CACHE_DIR/$name.zsh"
  if [[ ! -s $f || ( -n $bin && $bin -nt $f ) ]]; then
    "$@" >| "$f" 2>/dev/null
  fi
  source "$f" 2>/dev/null
}
_load_cached brew /opt/homebrew/bin/brew shellenv
# ---------------------------------------------------------------------------
# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# NATS / kubectl / kubie / fzf completions are loaded AFTER oh-my-zsh (which
# runs compinit and defines `compdef`). See the "completions" block below.
##################################################

#GOPATH
export GOPATH="$HOME/dev/go"
export GOPRIVATE=code.bbraun.io

# Colorize kubectl output via kubecolor. The kubectl completion + `compdef`
# wiring for kubecolor happens in the "completions" block after oh-my-zsh loads
# (compinit must run first, otherwise `compdef` errors out).

alias grafana-admin-user="kubectl get secret prometheus-stack-grafana -o jsonpath='{.data.admin-user}' -n monitoring | base64 --decode; echo"
alias grafana-admin-pass="kubectl get secret prometheus-stack-grafana -o jsonpath='{.data.admin-password}' -n monitoring | base64 --decode; echo"

## Utility aliases for going online and offline
alias offline="networksetup -setairportpower en0 off && sudo ifconfig en13 down"
alias online="networksetup -setairportpower en0 on && sudo ifconfig en13 up"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="fox"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

ZSH_DISABLE_COMPFIX=true        # skip slow compaudit

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git docker zsh-completions zsh-autosuggestions zsh-syntax-highlighting )

source $ZSH/oh-my-zsh.sh

# --- completions & tool wiring that require compinit (run by oh-my-zsh above) ---
# Generate kubectl completion with the REAL kubectl before aliasing it to kubecolor.
command -v nats    >/dev/null 2>&1 && _load_cached nats    nats --completion-script-zsh
command -v kubectl >/dev/null 2>&1 && _load_cached kubectl kubectl completion zsh
command -v kubie   >/dev/null 2>&1 && _load_cached kubie   kubie generate-completion
alias kubectl=kubecolor
alias k=kubecolor
command -v kubecolor >/dev/null 2>&1 && compdef kubecolor=kubectl
# ------------------------------------------------------------------------------

# Starship prompt (cached)
_load_cached starship starship init zsh


# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias python=python3
alias vim=nvim
alias tms='$HOME/.local/bin/tmux-sessionizer'
alias pip=pip3
alias cl="clear -x"
# source $HOME/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# kubie completions are loaded in the completions block above (after compinit).

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

command -v fzf >/dev/null 2>&1 && _load_cached fzf fzf --zsh

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="$HOME/.rbenv/bin:$PATH"
_load_cached rbenv rbenv init -

# opencode
export PATH=/Users/yosbel.martinez/.opencode/bin:$PATH

# bun completions
[ -s "/Users/yosbel.martinez/.bun/_bun" ] && source "/Users/yosbel.martinez/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH=/Users/yosbel.martinez/dev/pp/opencode/packages/opencode/node_modules/@opencode-ai/opencode-darwin-arm64/bin:$PATH
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"


# Colorize man pages 
export LESS_TERMCAP_mb=$'\e[1;31m'
export LESS_TERMCAP_md=$'\e[1;31m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[1;33;44m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[4;1;32m'
export LESS_TERMCAP_mr=$'\e[7m'
export LESS_TERMCAP_mh=$'\e[2m'
export LESS_TERMCAP_ZN=$'\e[74m'
export LESS_TERMCAP_ZV=$'\e[75m'
export LESS_TERMCAP_ZO=$'\e[73m'
export LESS_TERMCAP_ZW=$'\e[75m'
export MANPAGER='less'
export GROOF_NO_SGR=1

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/yosbel.martinez/obsidian-vault/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/yosbel.martinez/obsidian-vault/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/yosbel.martinez/obsidian-vault/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/yosbel.martinez/obsidian-vault/google-cloud-sdk/completion.zsh.inc'; fi

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform
