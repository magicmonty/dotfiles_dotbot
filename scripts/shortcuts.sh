#!/bin/bash

# Config locations
folders="$HOME/.dotfiles/scripts/folders"
configs="$HOME/.dotfiles/scripts/configs"

# Output locations
bash_shortcuts="$HOME/.bash_shortcuts"
fish_shortcuts="$HOME/.config/fish/shortcuts.fish"
ranger_shortcuts="$HOME/.config/ranger/shortcuts.conf"
qute_shortcuts="$HOME/.config/qutebrowser/shortcuts.py"
vifm_shortcuts="$HOME/.config/vifm/vifmshortcuts"

# Ensuring that output locations are properly sourced
(cat $HOME/.bashrc | grep "source $HOME/.bash_shortcuts")>/dev/null || echo "source $HOME/.bash_shortcuts" >> $HOME/.bashrc
(cat $HOME/.config/ranger/rc.conf | grep "source $HOME/.config/ranger/shortcuts.conf")>/dev/null || echo "source $HOME/.config/ranger/shortcuts.conf" >> $HOME/.config/ranger/rc.conf
(cat $HOME/.config/qutebrowser/config.py | grep "config.source('shortcuts.py')")>/dev/null || echo "config.source('shortcuts.py')" >> $HOME/.config/qutebrowser/config.py
(cat $HOME/.config/fish/config.fish | grep "source ~/.config/fish/shortcuts.fish")>/dev/null || echo "source ~/.config/fish/shortcuts.fish" >> $HOME/.config/fish/config.fish

#Delete old shortcuts
printf "# vim: filetype=sh\\n# bash shortcuts\\n" > $bash_shortcuts
echo "# vim: filetype=sh\\n# fish shortcuts\\n" > $fish_shortcuts
echo "# ranger shortcuts" > $ranger_shortcuts
echo "# qutebrowser shortcuts" > $qute_shortcuts
printf "\" vim: filetype=vim\\n\" vifm shortcuts\\n" > $vifm_shortcuts

writeDirs() { 
  echo "alias $1='cd $2 && exa -glah --git --color-scale'" >> $bash_shortcuts
  echo "alias $1='cd $2; and exa -glah --git --color-scale'" >> $fish_shortcuts
  echo "map g$1 cd $2" >> $ranger_shortcuts
  echo "map t$1 tab_new $2" >> $ranger_shortcuts
  echo "map m$1 shell mv -v %s $2" >> $ranger_shortcuts
  echo "map Y$1 shell cp -rv %s $2" >> $ranger_shortcuts
  echo "config.bind(';$1', 'set downloads.location.directory $2 ;; hint links download')" >> $qute_shortcuts ;
  printf "map g$1 :cd $2<CR>\\nmap t$1 <tab>:cd $2<CR><tab>\\nmap M$1 <tab>:cd $2<CR><tab>:mo<CR>\\nmap Y$1 <tab>:cd $2<CR><tab>:co<CR>\\n" >> $vifm_shortcuts
}

writeConfs() {
  echo "alias $1='vim $2'" >> $bash_shortcuts
  echo "alias $1='vim $2'" >> $fish_shortcuts
  echo "map $1 shell vim $2" >> $ranger_shortcuts 
  echo "map $1 :e $2<CR>" >> $vifm_shortcuts
}

IFS=$'\n'
set -f
for line in $(cat "$folders"); do
  line=$(echo $line | sed 's/#.*//')
  key=$(echo $line | awk '{print $1}')
  dir=$(echo $line | awk '{print $2}')
  [ "$dir" == ""  ] || writeDirs $key $dir
done

set -f
for line in $(cat "$configs");
do
  line=$(echo $line | sed 's/#.*//')
  short=$(echo $line | awk '{print $1}')
  conf=$(echo $line | awk '{print $2}')
  [ "$conf" == ""  ] || writeConfs $short $conf
done
