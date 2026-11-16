# vim-smartHomeEnd

This Vim plug-in makes the `<Home>` and `<End>` keys cycle through the starts and ends of the screen rows spanned by the current line in Normal and Visual mode.
In Insert mode, the readline bindings `<Ctrl-A>` and `<Ctrl-E>` are remapped instead.

- `<Home>` alternates between the first non-blank character and the first column of the screen row; repeated presses move up through the screen rows of a wrapped line.
- `<End>` moves to the end of the screen row; repeated presses move down through the screen rows of a wrapped line.
- In Insert mode, `<Ctrl-E>` on the last screen row puts the cursor after the last character.
  At the end of the line, or while the completion popup menu is visible, `<Ctrl-E>` keeps its built-in meaning.

If `'wrap'` is off, buffer-line motions (`^`, `0`, `$`) are used instead of screen-row motions.

## Mappings

Default mappings are only created if the keys are not mapped already.
To map other keys, use the `<Plug>` mappings:

| Mode                  | `<Plug>` mapping              | Default         |
|-----------------------|-------------------------------|-----------------|
| Normal, Visual        | `<Plug>(SmartHomeEnd-Home)`   | `<Home>`        |
| Normal, Visual        | `<Plug>(SmartHomeEnd-End)`    | `<End>`         |
| Insert                | `<Plug>(SmartHomeEnd-Home)`   | `<Ctrl-A>`      |
| Insert                | `<Plug>(SmartHomeEnd-End)`    | `<Ctrl-E>`      |

Suggested remappings:

```vim
nmap H <Home>
xmap H <Home>
nmap L <End>
xmap L <End>
```

## Tests

Run `test/run.sh` to run the tests headless in Vim and Neovim.
