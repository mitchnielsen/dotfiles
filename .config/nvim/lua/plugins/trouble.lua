return {
  "folke/trouble.nvim",
  dependencies = "kyazdani42/nvim-web-devicons",
  keys = {
    { '<leader>h', '<cmd>TroubleToggle<CR>', desc = 'toggle' },
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
