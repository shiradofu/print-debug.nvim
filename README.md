<p align="center">
  <h1 align="center">😎 print-debug.nvim 😎</h1>
</p>

<p align="center">
  Of course, only for extreme professionals.
</p>

## Original

This plugins is a lua port of [vim-print-debug](https://github.com/sentriz/vim-print-debug)!

## Features

### `require('print-debug').add()`

Add a print-debug code, like `print("+++ AAAAAAAAAAAAAAAAAAAA")`.

### `require('print-debug').clear()`

Clear all print-debug codes.

## Config

Please see the source code if you want to know default templates.
Currently not so much languages are supported, so feel free to submit PR to
support your favorite ones!

If you change `placeholder`, default templates' placeholder will also be
replaced automatically.

```lua
require('print-debug').config({
  repeat_count = 999, -- default: 20
  placeholder = '{}', -- default: '@'
  templates = {
    new_lang1 = [[log("+++ {}");]],
    -- you don't have to do like this:
    -- javascript = [[console.log(`+++ {}`);]]
  }
})
```
