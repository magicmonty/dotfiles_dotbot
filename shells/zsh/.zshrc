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

source $HOME/.defaultapps

WORDCHARS=${WORDCHARS//\/[&.;]}                                 # Don't consider certain characters part of the word

search_history () {
  local PECO_FLAGS=''
  if [[ $# -gt 0 ]]; then
    PECO_FLAGS="--query=\"$@\""
  fi

  cat ~/.zhistory | uniq | peco --layout=bottom-up $PECO_FLAGS | read from_peco

  if [ -n $from_peco ]; then
    eval $from_peco
  else
    eval $@
  fi
}

zle -N search_history_widget search_history
bindkey '^R' search_history_widget

## Keybindings section
bindkey -e
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

source ~/.bash_shortcuts

alias cp="cp -i"                                                # Confirm before overwriting something
alias df='df -h'                                                # Human-readable sizes
alias free='free -m'                                            # Show sizes in MB
alias gitu='git add . && git commit && git push'
alias vi='nvim'
alias v='nvim'
alias ls='exa'
alias la='exa -glah --git --color-scale'
alias ll='exa -glh --git --color-scale'
alias l='exa -lh --git --color-scale'
alias c.='code .'
alias e='emacsclient -nt'
alias ec='emacsclient -nc'
alias vimdiff='nvim -d'

## Git aliases
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
alias gb='git branch'
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

# aurman aliases
pclean() {
  sudo pacman -Sc
  yay -Sc
  yay -Rns $(yay -Qtdq) 2>/dev/null
  paccache -r
}

pupd() {
  notify-send -a 'Package Update' 'Upgrade started'
  neofetch
  yay -Syyuv --noconfirm --noeditmenu && notify-send -a 'Package Update' 'Update completed' || notify-send -a 'Package Update' -u critical 'Update failed'
  pkill -RTMIN+13 i3blocks
}
alias hc='herbstclient'
alias pinst='yay --noeditmenu --nodiffmenu --nocleanmenu --answerclean --sudoloop --needed -S'
alias psearch='yay -Ss'
alias puninst='yay -R'

# Theming section
autoload -U compinit colors zcalc
compinit -d
colors
source ${HOME}/.dotfiles/shells/zsh/spectrum.zsh

# enable substitution for prompt
setopt prompt_subst

# Prompt (on left side) similar to default bash prompt, or redhat zsh prompt with colors
# PROMPT="%(!.%{$fg[red]%}[%n@%m %1~]%{$reset_color%}# .%{$fg[green]%}[%n@%m %1~]%{$reset_color%}$ "
# Maia prompt
# PROMPT="%B%{$fg[cyan]%}%(4~|%-1~/.../%2~|%~)%u%b >%{$fg[cyan]%}>%B%(?.%{$fg[cyan]%}.%{$fg[red]%})>%{$reset_color%}%b " # Print some system information when the shell is first started
eval fg_gray='$FG[238]'
eval bg_gray='$BG[238]'
eval fg_red='$FG[001]'
eval bg_red='$BG[001]'
eval bg_white='$BG[015]'
eval fg_white='$FG[015]'

PROMPT='%(0?||%B%{$fg_red$bg_white%} %? %{$fg_white$bg_gray%}%b%f%k)%{$fg_white$bg_gray%} %(2~|%(3~|%(4~|%-2~/…/%B%2~|%-2~/%B%1~)|%-1~/%B%1~)|%B%~) %{$fg_gray%}%k%b%f '

## Prompt on right side:
#  - shows status of git when in git repository (code adapted from https://techanic.net/2012/12/30/my_git_prompt_for_zsh.html)
#  - shows exit status of previous command (if previous command finished with an error)
#  - is invisible, if neither is the case

# Modify the colors and symbols in these variables as desired.
GIT_PROMPT_SYMBOL=" "        # plus/minus     - clean repo
GIT_PROMPT_PREFIX=""
GIT_PROMPT_SUFFIX=""
GIT_PROMPT_AHEAD="NUM "    # A"NUM"         - ahead by "NUM" commits
GIT_PROMPT_BEHIND="NUM "   # B"NUM"         - behind by "NUM" commits
GIT_PROMPT_MERGING="⚡︎"      # lightning bolt - merge conflict
GIT_PROMPT_UNTRACKED="…"     # ellipsis       - untracked files
GIT_PROMPT_MODIFIED=" "     # pen            - tracked files modified
GIT_PROMPT_STAGED=" "       # eye            - staged changes present = ready for "git push"

parse_git_branch() {
  # Show Git branch/tag, or name-rev if on detached head
  ( git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD ) 2> /dev/null
}

parse_git_start() {
  local GIT_START="%F{green}%{$fg_gray%}%K{green}"

  if ! git diff --quiet 2> /dev/null; then
    GIT_START="%F{red}%B%F{white}%K{red}"
  fi
  if ! git diff --cached --quiet 2> /dev/null; then
    GIT_START="%F{yellow}%{$fg_gray%}%K{yellow}"
  fi

  echo $GIT_START
}

parse_git_state() {
  # Show different symbols as appropriate for various Git repository states
  # Compose this value via multiple conditional appends.
  local GIT_STATE=""
  local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_AHEAD" -gt 0 ]; then
    GIT_STATE=$GIT_STATE${GIT_PROMPT_AHEAD//NUM/$NUM_AHEAD}
  fi
  local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_BEHIND" -gt 0 ]; then
    GIT_STATE=$GIT_STATE${GIT_PROMPT_BEHIND//NUM/$NUM_BEHIND}
  fi
  local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
  if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MERGING
  fi
  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_UNTRACKED
  fi
  if ! git diff --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MODIFIED
  fi
  if ! git diff --cached --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_STAGED
  fi
  if [[ -n $GIT_STATE ]]; then
    echo "$GIT_PROMPT_PREFIX$GIT_STATE$GIT_PROMPT_SUFFIX"
  fi
}

git_prompt_string() {
  local git_where="$(parse_git_branch)"

  # If inside a Git repository, print its branch and state
    [ -n "$git_where" ] && echo "$(parse_git_start)$(parse_git_state)$GIT_PROMPT_PREFIX$GIT_PROMPT_SYMBOL${git_where#(refs/heads/|tags/)}$GIT_PROMPT_SUFFIX "
}

# Right prompt with exit status of previous command if not successful
 #RPROMPT="%{$fg[red]%} %(?..[%?])"
# Right prompt with exit status of previous command marked with ✓ or ✗
 #RPROMPT="%(?.%{$fg[green]%}✓ %{$reset_color%}.%{$fg[red]%}✗ %{$reset_color%})"


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
# Use syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Use history substring search
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

# bind UP and DOWN arrow keys to history substring search
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Apply different settigns for different terminals
case $(basename "$(cat "/proc/$PPID/comm")") in
  login)
    	RPROMPT="%{$fg[red]%} %(?..[%?])"
    	alias x='startx ~/.xinitrc'      # Type name of desired desktop after x, xinitrc is configured for it
    ;;
#  'tmux: server')
#        RPROMPT='$(git_prompt_string)'
#		## Base16 Shell color themes.
#		#possible themes: 3024, apathy, ashes, atelierdune, atelierforest, atelierhearth,
#		#atelierseaside, bespin, brewer, chalk, codeschool, colors, default, eighties,
#		#embers, flat, google, grayscale, greenscreen, harmonic16, isotope, londontube,
#		#marrakesh, mocha, monokai, ocean, paraiso, pop (dark only), railscasts, shapesifter,
#		#solarized, summerfruit, tomorrow, twilight
#		#theme="eighties"
#		#Possible variants: dark and light
#		#shade="dark"
#		#BASE16_SHELL="/usr/share/zsh/scripts/base16-shell/base16-$theme.$shade.sh"
#		#[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL
#		# Use autosuggestion
#		source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
#		ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
#  		ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
#     ;;
  *)
        RPROMPT='$(git_prompt_string)'
		# Use autosuggestion
		source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
		ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
  		ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
    ;;
esac

if [ -e /opt/dotnet ]; then
  export DOTNET_ROOT=/opt/dotnet
fi

if [ -e ~/.cargo/bin ]; then
  export MATES_DIR=~/.contacts/pagansoft
fi

if [ -e ~/.dotnet/tools ]; then
  export PATH=~/.dotnet/tools:$PATH
  export DOTNET_CLI_TELEMETRY_OPTOUT=1
fi


export DEFAULT_USER=mgondermann
if [ -e "$TMUX" ]; then
  export TERM=screen-256color
else
  export TERM=xterm-256color
fi

if [ -e ~/.gem/ruby/2.7.0/gems/tmuxinator-1.1.4/completion/tmuxinator.zsh ]; then
  source ~/.gem/ruby/2.7.0/gems/tmuxinator-1.1.4/completion/tmuxinator.zsh
  alias mux='tmuxinator'
fi

source /home/mgondermann/.config/broot/launcher/bash/br
