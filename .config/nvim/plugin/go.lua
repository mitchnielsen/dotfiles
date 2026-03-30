vim.pack.add({ "https://github.com/ray-x/go.nvim" }, { confirm = false })

require("go").setup({
  lsp_inlay_hints = {
    enable = true,
    style = "eol",
  },
})
