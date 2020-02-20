config.source('shortcuts.py')

# open current URL in MPV
config.bind("m", "spawn ~/bin/umpv '{url}'")

# open link in MPV
config.bind(";M", "hint links spawn ~/bin/umpv '{hint-url}'")
config.bind(";m", "hint links spawn ~/bin/umpv '{hint-url}'")
config.bind(",m", "hint links spawn ~/bin/umpv '{hint-url}'")

# open link
config.bind(",o", "hint links fill :open {hint-url}")

# open link in new tab
config.bind(";O", "hint links fill :open -t -r {hint-url}")

# Yank link
config.bind(",y", "hint links yank")

# Add to Pocket
config.bind(",p", "hint links spawn ~/bin/addpocket {hint-url}")
config.bind("P", "spawn ~/bin/addpocket {url} ")
config.bind("gp", ":open https://getpocket.com/a/queue")

config.load_autoconfig()

c.input.insert_mode.auto_leave = True
c.input.insert_mode.auto_load = True
c.content.proxy = 'system'
