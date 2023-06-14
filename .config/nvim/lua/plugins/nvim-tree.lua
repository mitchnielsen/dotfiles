local function on_attach(bufnr)
  local api = require('nvim-tree.api')

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  vim.keymap.set('n', 'i', api.node.open.horizontal, opts('Open: Horizontal Split')) -- was '<C-x>'
  vim.keymap.set('n', 's', api.node.open.vertical, opts('Open: Vertical Split')) -- was '<C-v'
end

return {
  'kyazdani42/nvim-tree.lua',
  dependencies = "kyazdani42/nvim-web-devicons",
  keys = {
    {"<leader>n", "<cmd>NvimTreeFindFileToggle<cr>", desc = "toggle"},
  },
  lazy = false,
  config = function ()
    require('nvim-tree').setup {
      on_attach = on_attach,
      filters = {
        dotfiles = false,
      },
      git = {
        ignore = false,
      },
      view = {
        preserve_window_proportions = true,
      }
    }
  end
}
