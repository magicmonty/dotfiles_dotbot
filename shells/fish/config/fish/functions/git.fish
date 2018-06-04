abbr -a g git

abbr -a gci git commit
abbr -a gcim git commit --message
abbr -a gcima git commit --all message

abbr -a gs git status
abbr -a gst git status
abbr -a gstu git status --untracked-files=no

abbr -a amend git commit --amend --no-edit
abbr -a reword git commit --amend --message
abbr -a gu git reset HEAD~1
abbr -a grh git reset --hard

abbr -a ga git add
abbr -a gaa git add --all
abbr -a unstage git reset HEAD

abbr -a gco git checkout
abbr -a gb git branch
abbr -a gbr git branch
abbr -a gbrs git branch --all --verbose
abbr -a gp git push

abbr -a grv git remote --verbose

abbr -a gd git diff
abbr -a gdc git diff --staged
abbr -a gshow git diff --staged
abbr -a gdt git difftool
abbr -a gmt git mergetool
abbr -a unresolve git checkout --conflict=merge

abbr -a gll git log
abbr -a gl git log --oneline --max-count=15
abbr -a gld git log --oneline --max-count=15 --decorate
abbr -a ggl git log --graph --oneline --decorate --branches --all
abbr -a hist "git log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short"
abbr -a wdw git wdw
abbr -a most-changed git log --format=%n --name-only | grep -v '^$' | sort | uniq -c | sort --numeric-sort --reverse | head -n 50

abbr -a gcleanf git clean -xdf
abbr -a gpush git push

function git
  # inspired by thoughtbot/dotfiles
  if count $argv > /dev/null # alternative: set -q argv
    command git $argv
  else
    command git status -sb
  end
end
