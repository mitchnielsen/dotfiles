vim.pack.add({ "https://github.com/pwntester/octo.nvim" }, { confirm = false })

require("octo").setup({
  picker = "fzf-lua",
  enable_builtin = true,
})
