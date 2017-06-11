#=  vi-style command-line editing  ============================================
set -o vi


#=  use all identities with passphrases stored in keychain  ===================
/usr/bin/ssh-add -A &> /dev/null

#=  use same ssh_agent across multiple logins  ================================
if [[ -f /usr/local/bin/keychain ]]; then
  eval `/usr/local/bin/keychain -q --eval --agents ssh --inherit any id_rsa`
fi


#=  disable output flow control ===============================================
stty -ixon -ixoff

#=  Environment Variables  ====================================================
LC_ALL="en_US.utf-8" && export LC_ALL


#=  MySQl  ====================================================================
#PATH=$PATH:/usr/local/mysql/bin && export PATH
#DYLD_LIBRARY_PATH=/usr/local/mysql/lib:$DYLD_LIBRARY_PATH && export DYLD_LIBRARY_PATH


#=  Python  ===================================================================
# PYTHONPATH=/usr/local/lib/python2.7/site-packages:$PYTHONPATH && export PYTHONPATH


#=  Homebrew  =================================================================
if hash brew 2>/dev/null; then
  #=  Set HOMEBREW_PREFIX =======================================================
  brew_prefix=`brew --prefix` && export brew_prefix

  #=  Homebrew/bin  =============================================================
  PATH=/usr/local/bin:$PATH && export PATH

  #=  Homebrew/sbin  ============================================================
  PATH=/usr/local/sbin:$PATH && export PATH

  #=  Homebrew/bash-completion  =================================================
  if [[ -f $brew_prefix/etc/bash_completion ]]; then
    . $brew_prefix/etc/bash_completion
  fi

  #=  Homebrew/github_api_token =================================================
  if [[ -f ~/.homebrew_github_api_token ]]; then
    . ~/.homebrew_github_api_token
  fi

  #= Homebrew/coreutils  ========================================================
  #PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
  #MANPATH="$(brew --prefix coreutils)/libexec/gnuman:$MANPATH"
fi


#= AWS CLI Completion  ========================================================
complete -C aws_completer aws


#=  Editors  ==================================================================
EDITOR="vim" && export EDITOR
VISUAL="vim" && export VISUAL
SVN_EDITOR="vim" && export SVN_EDITOR
GIT_EDITOR="vim" && export GIT_EDITOR


#=  Terminal colours (after installing GNU coreutils)  ========================
NM="\[\033[0;38m\]" #means no background and white lines
HI="\[\033[0;37m\]" #change this for letter colors
HII="\[\033[0;32m\]" #change this for letter colors
SI="\[\033[0;33m\]" #this is for the current directory
IN="\[\033[0m\]"

PS1="$NM[$HI\u@$HII\h $SI\w$NM]\\\$$IN " && export PS1

if [[ "$TERM" != "dumb" ]]; then
  LS_OPTIONS='--color=auto' && export LS_OPTIONS
  GREP_OPTIONS='--color=auto' && export GREP_COLORS
  CLICOLOR=1 && export CLICOLOR
  if hash gdircolors 2>/dev/null; then
    eval `gdircolors ~/.dir_colors`
  fi
fi


#=  make history store more commands (1000000 bytes)  =========================
HISTSIZE=1000000 && export HISTSIZE
HISTFILESIZE=1000000 && export HISTFILESIZE
HISTTIMEFORMAT='%F %T  ' && export HISTTIMEFORMAT

#=  unify bash history across session exits, and update in realtime  ==========
shopt -s histappend
if [[ ! ${PROMPT_COMMAND} =~ 'history -a; history -n;' ]]; then
  PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND" && export PROMPT_COMMAND
fi


#=  store multi-line commands in history  =====================================
shopt -s cmdhist

#=  verify history before executing  ==========================================
shopt -s histverify

#=  customize what goes into history  =========================================
HISTCONTROL=ignoredups:ignorespace && export HISTCONTROL
HISTIGNORE="ls:ll:la:ls.:l.:man:[bf]g:history:history *:h:h *:clear:c:exit:e" && export HISTIGNORE

#=  z ("cd" jump history)  ====================================================
if [[ -f /usr/local/etc/profile.d/z.sh ]]; then
  . /usr/local/etc/profile.d/z.sh
fi


#=  Aliases  ==================================================================
if [[ -f ~/.aliases ]]; then
  source ~/.aliases
fi


#=  rbenv  ====================================================================
if which rbenv > /dev/null; then
  PATH=$HOME/.rbenv/bin:$PATH && export PATH
  eval "$(rbenv init -)"
fi


#=  pyenv  ====================================================================
if which pyenv > /dev/null; then
  eval "$(pyenv init -)";
fi
if which pyenv-virtualenv-init > /dev/null; then
  eval "$(pyenv virtualenv-init -)";
fi


#=  jenv  =====================================================================
if hash jenv 2>/dev/null; then
  export PATH="$HOME/.jenv/bin:$PATH"
  eval "$(jenv init -)"
fi

#=  Path  =====================================================================
PATH=$HOME/bin:$PATH && export PATH


#=  Prompt  ===================================================================
if [[ -f ~/.bash_prompt ]]; then
  source ~/.bash_prompt
fi


#=  Fix Lockups on Mac OS 10.11  ==============================================
#sudo pkill -9 notifyd


#=  Start TMUX on Login  ======================================================
if [[ -z $TMUX ]] && hash tmux 2>/dev/null; then
  tm $(date +%Y%m%d%H%M%S)
fi
