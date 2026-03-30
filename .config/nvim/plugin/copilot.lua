vim.pack.add({ "https://github.com/zbirenbaum/copilot.lua" }, { confirm = false })

require("copilot").setup({
  panel = { enabled = false },
  suggestion = { enabled = false },
  filetypes = {
    help = false,
    gitcommit = false,
    gitrebase = false,
    hgcommit = false,
    svn = false,
    cvs = false,
    ["."] = false,
  },
})
