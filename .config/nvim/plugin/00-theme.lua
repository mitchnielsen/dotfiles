vim.pack.add({
  "https://github.com/projekt0n/github-nvim-theme",

  -- Available for :colorscheme / picker
  "https://github.com/navarasu/onedark.nvim",
  "https://github.com/Mofiqul/vscode.nvim",
  "https://github.com/EdenEast/nightfox.nvim",
  "https://github.com/shaunsingh/nord.nvim",
  "https://github.com/rmehri01/onenord.nvim",
  "https://github.com/aktersnurra/no-clown-fiesta.nvim",
  "https://github.com/oskarnurm/koda.nvim",
}, { confirm = false })

require("github-theme").setup({
  options = {
    transparent = true,
  },
})
vim.cmd("colorscheme github_light_default")
