function gitv -d "Show git log using Gitv in vim"
  command vim (git rev-parse --show-toplevel)/.git/index -c "Gitv $args" -c "tabonly"
end
