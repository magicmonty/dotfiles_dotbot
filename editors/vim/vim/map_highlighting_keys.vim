" map_option_highlighting_keys.vim
"
" A temporary home for the Option+movement keys, while I turn the
" Shift+movement key script into a plugin.
"

"""
""" Option movement keys
"""
""" XXX: All the Option maps need to be reviewed for the
""" missing-last-character bug.
"""


"" Option+Left/Right

" Normal mode
"
nnoremap    <S-Left>            vh
nnoremap    <S-Right>           vl

" Insert mode
"
inoremap    <S-Left>            <C-O>vh
inoremap    <S-Right>           <C-O>vl

" Visual mode
"
xnoremap    <S-Left>            h
xnoremap    <S-Right>           l

" Select mode
"
snoremap    <S-Left>            <C-O>h
snoremap    <S-Right>           <C-O>l


"" Option+Up/Down

" Make option up/down enter Visual mode, then move
" up/down by a display line.

" Normal mode
"
" Enter Visual mode then move.
"
nnoremap    <S-Down>            vgj
nnoremap    <S-Up>              vgk

" Insert mode
"
imap        <S-Up>              <C-O><M-Up>
imap        <S-Down>            <C-O><M-Down>

" Visual mode
"
" Just stay in Visual mode.
"
xnoremap    <S-Up>              gk
xnoremap    <S-Down>            gj

" Select mode
"
" Option+Up/Down in Select mode enter Visual mode for one command, move the
" cursor one display line in the proper direction, then re-enter Select mode.
"
" XXX: Stay in Select mode, or switch to Visual mode?
"
snoremap    <S-Down>            <C-O>gj
snoremap    <S-Up>              <C-O>gk


"" Option+Home/End, Option+Command+Left/Right

" Normal mode
"
" Enter Visual mode then move.
"
nnoremap    <expr> <S-Home>     "v" . (&wrap ? "g0" : "0")
nnoremap    <expr> <S-End>      "v" . (&wrap ? "g$" : "$")
nmap        <S-D-Left>          <S-Home>
nmap        <S-D-Right>         <S-End>

" Insert mode
"
" Leave Insert mode for a single command, then trigger the Normal mode
" maps.
"

" This is essentially the same map as Insert-mode Shift+Home; it just leaves
" off the Control+G at the end, so we stay in Visual mode instead of returning
" to Select mode. See the notes above imap Shift+Home for an explanation of
" how it works.
"
" XXX: Factor out common code between this map and imap Shift+Home.
"
inoremap    <expr> <S-Home>     "<C-O>" . (&wrap ? "g0" : "0")
                                \ . "<C-O>v"
                                \ . virtcol('.') . "\|"
                                \ . "o"

imap        <S-End>             <C-O><M-End>
imap        <S-D-Left>          <C-O><M-Home>
imap        <S-D-Right>         <C-O><M-End>

" Visual mode
"
xnoremap    <expr> <M-Home>     &wrap ? "g0" : "0"
xnoremap    <expr> <M-End>      &wrap ? "g$" : "$"
xmap        <M-D-Left>          <M-Home>
xmap        <M-D-Right>         <M-End>

" Select mode
"
" Extend the selection to the start/end of the display line.
"
" Shift+Home/End in Select mode enter Visual mode for one command, move the
" cursor within the display line in the proper direction, then re-enter
" Select mode.
"
" XXX: These require that the corresponding Visual mode maps all be single
" commands. Might be better to not depend on the Normal mode maps.
"
smap        <M-Home>            <C-O><M-Home>
smap        <M-End>             <C-O><M-End>
smap        <M-D-Left>          <C-O><M-D-Left>
smap        <M-D-Right>         <C-O><M-D-Right>


"" Option+Up/Down

" Normal mode
"
nnoremap    <S-D-Up>            vgg
nnoremap    <S-D-Down>          vG

" Insert mode
"
imap        <S-D-Up>            <C-O><M-D-Up>
imap        <S-D-Down>          <C-O><M-D-Down>

" Visual mode
"
xnoremap    <S-D-Up>            gg
xnoremap    <S-D-Down>          G

" Select mode
"
smap        <S-D-Up>            <C-O><M-D-Up>
smap        <S-D-Down>          <C-O><M-D-Down>


" end map_option_highlighting_keys.vim
