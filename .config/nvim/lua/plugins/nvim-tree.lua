local function on_attach(bufnr)
  local api = require('nvim-tree.api')

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

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
    -- disable netrw at the very start of your init.lua
    -- need to keep these enabled for :GBrowse to work
    -- vim.g.loaded_netrw = 1
    -- vim.g.loaded_netrwPlugin = 1

    -- set termguicolors to enable highlight groups
    vim.opt.termguicolors = true

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
