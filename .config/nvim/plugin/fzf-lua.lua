vim.pack.add({ "https://github.com/ibhagwan/fzf-lua" }, { confirm = false })

local actions = require("fzf-lua.actions")
local sharedActions = {
  ["default"] = actions.file_edit_or_qf,
  ["ctrl-s"] = actions.file_split,
  ["ctrl-v"] = actions.file_vsplit,
  ["ctrl-t"] = actions.file_tabedit,
}

local ignored_files = {
  "%.git/",
  "node_modules/",
  "%.venv/",
  "%.terraform/",
  "%.zsh_sessions/",
  "%.zcompcache/",
  "%.zcompdump",
}

require("fzf-lua").setup({
  ui_select = true, -- Use FzfLua for vim.ui.select (LSP code actions, etc.)
  fzf_colors = true,
  winopts = {
    backdrop = 100,
    border = "rounded",
    height = 0.90,
    width = 0.90,
    preview = {
      wrap = "wrap",
      title = false,
      border = "rounded",
      scrollbar = "border",
      winopts = { number = false },
    },
  },
  keymap = {
    fzf = {
      ["ctrl-d"] = "half-page-down",
      ["ctrl-u"] = "half-page-up",
      ["ctrl-a"] = "toggle-all",
    },
  },
  previewers = {
    bat = { theme = "ansi" },
  },
  files = {
    git_icons = false,
    file_icons = false,
    follow = true,
    file_ignore_patterns = ignored_files,
    actions = sharedActions,
    line_query = true,
    no_ignore = true,
  },
  grep = {
    git_icons = false,
    file_icons = false,
    prompt = "rg: ",
    actions = sharedActions,
    RIPGREP_CONFIG_PATH = vim.env.RIPGREP_CONFIG_PATH,
    no_ignore = true,
    file_ignore_patterns = ignored_files,
  },
  lsp = {
    jump1 = true,
    ignore_current_line = true,
    includeDeclaration = false,
  },
})

vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<CR>", { desc = "[f]ind [f]iles" })
vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua live_grep<CR>", { desc = "[f]ind with [g]rep" })
vim.keymap.set("n", "<leader>fG", "<cmd>FzfLua.live_grep({resume=true})<CR>", { desc = "[f]ind with [g]rep (resume)" })
vim.keymap.set("n", "<leader>fw", "<cmd>FzfLua grep_cword<CR>", { desc = "[f]ind [w]ord under cursor with grep" })
vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<CR>", { desc = "[f]ind [b]uffers" })
vim.keymap.set("n", "<leader>fs", "<cmd>FzfLua lsp_document_symbols<CR>", { desc = "[f]ind [s]ymbols" })
vim.keymap.set("n", "<leader>fd", "<cmd>FzfLua lsp_document_diagnostics<CR>", { desc = "[f]ind [d]iagnostics" })
vim.keymap.set("n", "<leader>fc", "<cmd>FzfLua command_history<CR>", { desc = "[f]ind [c]ommand history" })
