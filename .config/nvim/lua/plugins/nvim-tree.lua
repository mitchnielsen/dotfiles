return {
  'kyazdani42/nvim-tree.lua',
  dependencies = "kyazdani42/nvim-web-devicons",
  keys = {
    {"<leader>n", "<cmd>NvimTreeFindFileToggle<cr>", desc = "toggle"},
  },
  config = function()
    require'nvim-tree'.setup {
      ignore_buffer_on_setup = true,
      filters = {
        dotfiles = false,
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
  end
}
