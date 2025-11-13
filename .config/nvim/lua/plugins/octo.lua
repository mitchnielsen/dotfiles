return {
  "pwntester/octo.nvim",
  requires = {
    "nvim-lua/plenary.nvim",
    "ibhagwan/fzf-lua",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("octo").setup({
      picker = "fzf-lua",
      enable_builtin = true,
    })
  end,
}
