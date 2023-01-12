## Options section
setopt correct                                                  # Auto correct mistakes
setopt extendedglob                                             # Extended globbing. Allows using regular expressions with *
setopt nocaseglob                                               # Case insensitive globbing
setopt rcexpandparam                                            # Array expension with parameters
setopt nocheckjobs                                              # Don't warn about running processes when exiting
setopt numericglobsort                                          # Sort filenames numerically when it makes sense
setopt nobeep                                                   # No beep
setopt appendhistory                                            # Immediately append history instead of overwriting
setopt histignorealldups                                        # If a new command is a duplicate, remove the older one
setopt autocd                                                   # if only directory path is entered, cd there.

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'       # Case insensitive tab completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"         # Colored completion (different colors for dirs/files/etc)
zstyle ':completion:*' rehash true                              # automatically find new executables in path
# Speed up completions
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
HISTFILE=~/.zhistory
HISTSIZE=1000
SAVEHIST=500
ZSH_PECO_HISTORY_DEDUP=1

if [ -e $HOME/.defaultapps ]; then
  source $HOME/.defaultapps
fi

# Bootstrap Antigen plugin manager
export ADOTDIR=${HOME}/.config/antigen
if ! [ -f ${ADOTDIR}/antigen.zsh ]; then
  mkdir -p ${ADOTDIR}
  curl -L git.io/antigen > ${ADOTDIR}/antigen.zsh
fi

source ${ADOTDIR}/antigen.zsh

antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle jimeh/zsh-peco-history

antigen apply

if ! command -v starship &> /dev/null; then
  curl -sS https://starship.rs/install.sh | sh
fi

# Don't consider certain characters part of the word
WORDCHARS=${WORDCHARS//\/[&.;]}

## Keybindings section
bindkey -e

## Search history via Peco
zle -N peco_select_history
bindkey '^r' peco_select_history

bindkey '^[[7~' beginning-of-line                               # Home key
bindkey '^[[H' beginning-of-line                                # Home key
if [[ "${terminfo[khome]}" != "" ]]; then
  bindkey "${terminfo[khome]}" beginning-of-line                # [Home] - Go to beginning of line
fi
bindkey '^[[8~' end-of-line                                     # End key
bindkey '^[[F' end-of-line                                     # End key
if [[ "${terminfo[kend]}" != "" ]]; then
  bindkey "${terminfo[kend]}" end-of-line                       # [End] - Go to end of line
fi
bindkey '^[[2~' overwrite-mode                                  # Insert key
bindkey '^[[3~' delete-char                                     # Delete key
bindkey '^[[C'  forward-char                                    # Right key
bindkey '^[[D'  backward-char                                   # Left key
bindkey '^[[5~' history-beginning-search-backward               # Page up key
bindkey '^[[6~' history-beginning-search-forward                # Page down key

# Navigate words with ctrl+arrow keys
bindkey '^[Oc' forward-word                                     #
bindkey '^[Od' backward-word                                    #
bindkey '^[[1;5D' backward-word                                 #
bindkey '^[[1;5C' forward-word                                  #
bindkey '^H' backward-kill-word                                 # delete previous word with ctrl+backspace
bindkey '^[[Z' undo                                             # Shift+tab undo last action

## Alias section

if [ -e ~/.bash_shortcuts ]; then
  source ~/.bash_shortcuts
fi

alias cp="cp -i"                                                # Confirm before overwriting something
alias df='df -h'                                                # Human-readable sizes
alias free='free -m'                                            # Show sizes in MB
alias gitu='git add . && git commit && git push'
alias vi='nvim'
alias v='nvim'
alias ls='exa'
alias la='exa -glah --color-scale'
alias ll='exa -glh --color-scale'
alias l='exa -lh --color-scale'
alias c.='code .'
alias e='emacsclient -nt'
alias ec='emacsclient -nc'
alias vimdiff='nvim -d'

## Git aliases
alias lg='lazygit'
alias g='git'
alias gci='git commit'
alias gcim='git commit --message'
alias gcima='git commit --all --message'
alias gs='git status'
alias gst='git status'
alias gstu='git status --untracked-files=no'
alias amend='git commit --amend --no-edit'
alias reword='git commit --amend --message'
alias gu='git reset HEAD~1'
alias grh='git reset --hard'
alias ga='git add'
alias gaa='git add --all'
alias unstage='git reset HEAD'
alias gco='git checkout'
alias gb='git branch --sort=-committerdate | fzf --header "Checkout Recent Branch" --preview "git diff --color=always {1} | delta" --pointer="" | xargs git checkout'
alias gbr='git branch'
alias gbrs='git branch --all -verbose'
alias gp='git push'
alias gpush='git push'
alias gpull='git pull'
alias gpf='git push --force-with-lease'
alias grv='git remote --verbose'
alias gd='git diff'
alias gdc='git diff --staged'
alias gshow='git diff --staged'
alias gdt='git difftool'
alias gmt='git mergetool'
alias unresolve='git checkout --conflict=merge'
alias gll='git log'
alias gl='git log --oneline --max-count=15'
alias gld='git log --oneline --max-count=15 --decorate'
alias ggl='git log --graph --oneline --decorate --branches --all'
alias hsit="git log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short"
alias wdw='git wdw'
alias most-changed="git log --format=%n --name-only | grep -v '^$' | sort | uniq -c |--numeric-sort --reverse | head -n 50"
alias gcleanf='git cleanf -xdf'
alias gv='vim -c "GV" -c "tabonly"'
alias gitv='vim -c "GV" -c "tabonly"'
alias gls="git log --graph --oneline --decorate --all --color=always | fzf --ansi +s --preview='git show --color=always {2}' --bind='ctrl-d:preview-page-down' --bind='ctrl-u:preview-page-up' --bind='enter:execute:git show --color=always {2} | less -R' --bind='ctrl-x:execute:git checkout {2} .'"


alias zz="z -" # Toggle last directory

# aurman aliases
pclean() {
  sudo pacman -Sc
  yay -Sc
  yay -Rns $(yay -Qtdq) 2>/dev/null
  paccache -r
}

pupd() {
  notify-send -a 'Package Update' 'Upgrade started'
  yay -Syyuv --noconfirm --noeditmenu && notify-send -a 'Package Update' 'Update completed' || notify-send -a 'Package Update' -u critical 'Update failed'
  pkill -RTMIN+13 i3blocks
}
alias pinst='yay --noeditmenu --nodiffmenu --nocleanmenu --answerclean --sudoloop --needed -S'
alias psearch='yay -Ss'
alias puninst='yay -R'

# Theming section
autoload -U compinit colors zcalc
compinit -d
colors
if [ -e ${HOME}/.dotfiles/shells/zsh/spectrum.zsh ]; then
  source ${HOME}/.dotfiles/shells/zsh/spectrum.zsh
fi

# enable substitution for prompt
setopt prompt_subst

eval fg_gray='$FG[238]'
eval bg_gray='$BG[238]'
eval fg_red='$FG[001]'
eval bg_red='$BG[001]'
eval bg_white='$BG[015]'
eval fg_white='$FG[015]'

# Color man pages
export LESS_TERMCAP_mb=$'\E[01;32m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;47;34m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;36m'
export LESS=-r


## Plugins section: Enable fish style features

# bind UP and DOWN arrow keys to history substring search
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

if [ -e /opt/android-sdk/cmdline-tools/latest/bin ]; then
  export PATH=$PATH:/opt/android-sdk/cmdline-tools/latest/bin
fi

if [ -e /opt/android-sdk/platform-tools ]; then
  export PATH=$PATH:/opt/android-sdk/platform-tools
fi

if [ -e /opt/dotnet ]; then
  export DOTNET_ROOT=/opt/dotnet
fi

if [ -e ~/.cargo/bin ]; then
  export PATH=~/.cargo/bin:$PATH
fi

if [ -e ~/.dotnet/tools ]; then
  export PATH=~/.dotnet/tools:$PATH
fi
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export ASPNETCORE_ENVIRONMENT=Development
_dotnet_zsh_complete()
{
  local completions=("$(dotnet complete "$words")")
  reply=( "${(ps:\n:)completions}" )
}
compctl -K _dotnet_zsh_complete dotnet

export DEFAULT_USER=mgondermann
if [ -e "$TMUX" ]; then
  export TERM=screen-256color
else
  if [ -e "$KITTY_PID" ]; then
    export TERM=xterm-256color
  fi
fi

if [ -e ~/.gem/ruby/2.7.0/gems/tmuxinator-1.1.4/completion/tmuxinator.zsh ]; then
  source ~/.gem/ruby/2.7.0/gems/tmuxinator-1.1.4/completion/tmuxinator.zsh
  alias mux='tmuxinator'
fi

source /home/mgondermann/.config/broot/launcher/bash/br

if command -v bat &> /dev/null; then
  alias cat=bat
elif command -v batcat &> /dev/null; then
  alias cat=batcat
fi

if [ -e ${HOME}/.local/share/gem/ruby/3.0.0/bin ]; then
  export PATH=${HOME}/.local/share/gem/ruby/3.0.0/bin:$PATH
fi

if [ -e ${HOME}/.local/share/nvim/mason/bin ]; then
  export PATH=$PATH:${HOME}/.local/share/nvim/mason/bin
fi

USE_POWERLINE=true

# Apply different settigns for different terminals
case $(basename "$(cat "/proc/$PPID/comm")") in

  login)
    source ~/.dotfiles/shells/zsh/zsh-fallback-prompt
    alias x='startx ~/.xinitrc'
    ;;
  *)
    if [[ $TERM == "linux" ]]; then
      # TTY does not have powerline fonts
      source ~/.dotfiles/shells/zsh/zsh-fallback-prompt
    elif [[ "$USE_POWERLINE" == "true" ]]; then
      # Use powerline
      if command -v starship &> /dev/null; then
        eval "$(starship init zsh)"
      elif command -v oh-my-posh &>/dev/null; then
        eval "$(oh-my-posh --init --shell zsh --config ~/.poshtheme.omp.json)"
      else
        source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
        [[ ! -f /usr/share/zsh/p10k.zsh ]] || source /usr/share/zsh/p10k.zsh
      fi
    else
      # Don't use powerline anyway
      source ~/.dotfiles/shells/zsh/zsh-fallback-prompt
    fi
    ;;
esac

alias luamake=/home/mgondermann/src/lua-language-server/3rd/luamake/luamake

# Add Windows Path, if run in WSL
if uname -r | grep -q 'microsoft'; then
  export PATH="$PATH:/mnt/c/Windows/System32:/mnt/c/Windows/SysWOW64/:/mnt/c/Windows/System32/WindowsPowerShell/v1.0"
fi

eval "$(/usr/bin/zoxide init zsh)"

