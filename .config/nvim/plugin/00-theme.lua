vim.pack.add({
  "https://github.com/EdenEast/nightfox.nvim",
  "https://github.com/Mofiqul/vscode.nvim",
  "https://github.com/aktersnurra/no-clown-fiesta.nvim",
  "https://github.com/navarasu/onedark.nvim",
  "https://github.com/oskarnurm/koda.nvim",
  "https://github.com/rmehri01/onenord.nvim",
}, { confirm = false })

require("nightfox").setup({
  options = {
    transparent = true,
  },
})

vim.cmd.colorscheme("nordfox")
