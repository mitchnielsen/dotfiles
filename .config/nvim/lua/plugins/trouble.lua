return {
  "folke/trouble.nvim",
  dependencies = "kyazdani42/nvim-web-devicons",
  keys = {
    { '<leader>h', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>', desc = 'Toggle diagnostics window' },
    { '<leader>s', '<cmd>Trouble symbols toggle<CR>', desc = 'Toggle symbols window' },
  },
  opts = {
    action_keys = {
      open_split = { "<c-c>" },
      open_vsplit = { "<c-v>" },
    },
    auto_preview = false,
    auto_close = true,
  }
}
