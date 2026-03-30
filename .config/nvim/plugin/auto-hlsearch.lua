vim.pack.add({ "https://github.com/asiryk/auto-hlsearch.nvim" }, { confirm = false })

require("auto-hlsearch").setup({
  create_commands = true,
  remap_keys = { "/", "?", "*", "#", "n", "N" },
})
