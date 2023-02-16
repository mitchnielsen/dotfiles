return {
  'kyazdani42/nvim-tree.lua',
  dependencies = "kyazdani42/nvim-web-devicons",
  keys = {
    {"<leader>n", "<cmd>NvimTreeFindFileToggle<cr>", desc = "toggle"},
  },
  -- https://github.com/nvim-tree/nvim-tree.lua/wiki/Open-At-Startup#opening-nvim-tree-at-neovim-startup
  lazy = false,
  opts = {
    ignore_buffer_on_setup = true,
    filters = {
      dotfiles = false,
    },
    git = {
      ignore = false,
    },
    view = {
      preserve_window_proportions = true,
      mappings = {
        list = {
          { key = "s", action = "vsplit" },
          { key = "i", action = "split" },
        },
      },
    },
  }
}
