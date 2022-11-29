# telescope-yamlnav.nvim

**yamlnav** is telescope extension that allow you to navigate .yml file by path.

## Requirements

- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) (required)
- [yaml-path](https://github.com/aubinlrx/yaml-path) (required)

## Installation

**vim-plug**

```
Plug 'aubinlrx/telescope-yamlnav.nvim'
```

**packer.nvim**

```
use { 'aubinlrx/telescope-yamlnav.nvim', branch = 'main' }
```

## Setup

```lua
-- You dont need to set any of these options. These are the default ones. Only
-- the loading is important
require('telescope').setup({
  extensions = {
    yamlnav = {
      remove_prefix = true
    }
  }
})

-- To get yamlnav loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('yamlnav')

-- To be able to copy path under the current cursor a user function is available
vim.keymap.set("n", "<leader>yy", "<cmd>YamlNavCopy<cr>")
```
