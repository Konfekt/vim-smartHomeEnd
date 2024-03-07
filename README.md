*Vim-smartHomeEnd*
==================

Vim plug-in makes the `<Home/End>` keys cycle through the starts/endings of the screen rows spanned by the current line in Normal and Visual Mode.
In Insert Mode, the read-line bindings `<Ctrl-A/E>` are remapped instead.

Suggested remappings:

```vim
nmap H <Home>
xmap H <Home>
nmap L <End>
xmap L <End>
```
