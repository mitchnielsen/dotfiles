vim.pack.add({
  "https://github.com/kyazdani42/nvim-tree.lua",
  "https://github.com/b0o/nvim-tree-preview.lua",
  "https://github.com/kyazdani42/nvim-web-devicons",
}, { confirm = false })

local function on_attach(bufnr)
  local api = require("nvim-tree.api")
  local preview = require("nvim-tree-preview")

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  api.config.mappings.default_on_attach(bufnr)
  vim.keymap.set("n", "i", api.node.open.horizontal, opts("Open: Horizontal Split"))
  vim.keymap.set("n", "s", api.node.open.vertical, opts("Open: Vertical Split"))
  vim.keymap.set("n", "P", preview.watch, opts("Preview (Watch)"))
  vim.keymap.set("n", "<Esc>", preview.unwatch, opts("Close Preview/Unwatch"))
  vim.keymap.set("n", "<Tab>", preview.node_under_cursor, opts("Preview"))
end

vim.opt.termguicolors = true

require("nvim-tree").setup({
  on_attach = on_attach,
  filters = { dotfiles = false },
  git = { ignore = false },
  view = {
    preserve_window_proportions = true,
    adaptive_size = true,
  },
})

vim.cmd("autocmd VimEnter * hi NvimTreeNormal guibg=NONE")
vim.cmd("autocmd VimEnter * hi NvimTreeNormalNC guibg=NONE")

vim.keymap.set("n", "<leader>n", "<cmd>NvimTreeFindFileToggle<cr>", { desc = "toggle file tree" })
vim.keymap.set("n", "<leader>N", "<cmd>NvimTreeFindFile<cr>", { desc = "find file in tree" })
