#!/bin/bash

# Config locations
folders="$HOME/.dotfiles/scripts/folders"
configs="$HOME/.dotfiles/scripts/configs"

# Output locations
bash_shortcuts="$HOME/.bash_shortcuts"
fish_dir="${HOME}/.config/fish"
fish_shortcuts="$fish_dir/fish/shortcuts.fish"
ranger_dir="${HOME}/.config/ranger"
ranger_shortcuts="$ranger_dir/shortcuts.conf"
qute_dir="${HOME}/.config/qutebrowser"
qute_shortcuts="$qute_dir/shortcuts.py"
vifm_dir="${HOME}/.config/vifm"
vifm_shortcuts="$vifm_dir/vifmshortcuts"

# Ensuring that output locations are properly sourced
(cat $HOME/.bashrc | grep "source $HOME/.bash_shortcuts")>/dev/null || echo "source $HOME/.bash_shortcuts" >> $HOME/.bashrc
if [[ -d "$ranger_dir" ]]; then
  (cat $ranger_dir/rc.conf | grep "source $HOME/.config/ranger/shortcuts.conf")>/dev/null || echo "source $HOME/.config/ranger/shortcuts.conf" >> $HOME/.config/ranger/rc.conf
fi
if [[ -d "$qute_dir" ]]; then
  (cat $qute_dir/config.py | grep "config.source('shortcuts.py')")>/dev/null || echo "config.source('shortcuts.py')" >> $HOME/.config/qutebrowser/config.py
fi
if [[ -d "$fish_dir" ]]; then
  (cat $fish_dir/config.fish | grep "source ~/.config/fish/shortcuts.fish")>/dev/null || echo "source ~/.config/fish/shortcuts.fish" >> $HOME/.config/fish/config.fish
fi

#Delete old shortcuts
printf "# vim: filetype=sh\\n# bash shortcuts\\n" > $bash_shortcuts
if [[ -d "$fish_dir" ]]; then
  echo "# vim: filetype=sh\\n# fish shortcuts\\n" > $fish_shortcuts
fi
if [[ -d "$ranger_dir" ]]; then
  echo "# ranger shortcuts" > $ranger_shortcuts
fi
if [[ -d "$qute_dir" ]]; then
  echo "# qutebrowser shortcuts" > $qute_shortcuts
fi
if [[ -d "$vifm_dir" ]]; then
  printf "\" vim: filetype=vim\\n\" vifm shortcuts\\n" > $vifm_shortcuts
fi

writeDirs() {
  echo "alias $1='cd $2 && exa -glah --git --color-scale'" >> $bash_shortcuts
  if [[ -d "$fish_dir" ]]; then
    echo "alias $1='cd $2; and exa -glah --git --color-scale'" >> $fish_shortcuts
  fi
  if [[ -d "$ranger_dir" ]]; then
    echo "map g$1 cd $2" >> $ranger_shortcuts
    echo "map t$1 tab_new $2" >> $ranger_shortcuts
    echo "map m$1 shell mv -v %s $2" >> $ranger_shortcuts
    echo "map Y$1 shell cp -rv %s $2" >> $ranger_shortcuts
  fi
  if [[ -d "$qute_dir" ]]; then
    echo "config.bind(';$1', 'set downloads.location.directory $2 ;; hint links download')" >> $qute_shortcuts ;
  fi
  if [[ -d "$vifm_dir" ]]; then
    printf "map g$1 :cd $2<CR>\\nmap t$1 <tab>:cd $2<CR><tab>\\nmap M$1 <tab>:cd $2<CR><tab>:mo<CR>\\nmap Y$1 <tab>:cd $2<CR><tab>:co<CR>\\n" >> $vifm_shortcuts
  fi
}

writeConfs() {
  echo "alias $1='vim $2'" >> $bash_shortcuts
  if [[ -d "$fish_dir" ]]; then
    echo "alias $1='vim $2'" >> $fish_shortcuts
  fi
  if [[ -d "$ranger_dir" ]]; then
    echo "map $1 shell vim $2" >> $ranger_shortcuts
  fi
  if [[ -d "$vifm_dir" ]]; then
    echo "map $1 :e $2<CR>" >> $vifm_shortcuts
  fi
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
