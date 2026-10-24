# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/opt/homebrew/bin:/usr/local/bin:$PATH

export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"

# add Python
export PATH=~/Library/Python/3.8/bin:$PATH

# add Rancher Desktop
export PATH=$HOME/.rd/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"
HIST_STAMPS="%F %T"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git aws uv opentofu helm colored-man-pages colorize docker kubectl pip python virtualenv brew macos history z zsh-autosuggestions zsh-syntax-highlighting vi-mode gcloud mise)

source $ZSH/oh-my-zsh.sh

# User configuration

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='codium'
fi

export LESS='-XFR'

eval "$(/opt/homebrew/bin/rv shell init zsh)"
eval "$(/opt/homebrew/bin/rv shell completions zsh)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

alias secretCli="java -jar $HOME/bin/secrets-cli/secret-service-cli-0.0.407.jar"

alias v="codium"

# gcu() ("git clean up") 
gcu() {
  git for-each-ref --merged HEAD --format='%(refname:short)' refs/heads/ |
  grep -Ev '^(master|main|dev|develop)$' |
  while read -r branch; do
    [[ "$branch" == "$(git branch --show-current)" ]] && continue
    local wt=$(git worktree list --porcelain |
      awk -v b="refs/heads/$branch" '$1=="worktree"{p=$2} $1=="branch" && $2==b {print p}')
    if [[ -n "$wt" ]]; then
      git worktree remove -f -f "$wt" || continue
    fi
    git branch -d "$branch"
  done
}

ssh-add -A >/dev/null 2>&1

reload-ssh() {
  ssh-add -e /usr/local/lib/opensc-pkcs11-local.so
  ssh-add --apple-use-keychain -s /usr/local/lib/opensc-pkcs11-local.so
}

### Fix slowness of pastes with zsh-syntax-highlighting.zsh
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish
### Fix slowness of pastes

export EMAIL_ADDRESS=kipkoan@gmail.com

export DOCKER_DEFAULT_PLATFORM=linux/amd64

export PATH="$HOME/.local/bin:$PATH"
