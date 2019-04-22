function pupd
  notify-send -a 'Package Update' 'Upgrade started' & neofetch; and yay -Syyuv --noconfirm --noeditmenu; and notify-send -a 'Package Update' 'Upgrade completed'; or notify-send -a 'Package Update' -u critical 'Upgrade failed'
  pkill -RTMIN+13 i3blocks
end
