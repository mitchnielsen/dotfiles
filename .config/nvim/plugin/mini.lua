vim.pack.add({ "https://github.com/echasnovski/mini.nvim" }, { confirm = false })

require("mini.ai").setup()
require("mini.cmdline").setup()
require("mini.comment").setup()
require("mini.cursorword").setup()

require("mini.diff").setup({
  view = {
    style = "sign",
    signs = { add = "+", change = "~", delete = "-" },
  },
  mappings = {
    apply = "ghs",
    reset = "ghr",
  },
})
require("mini.icons").setup()
require("mini.surround").setup()

require("mini.starter").setup({
  evaluate_single = true,
  header = table.concat({
    [[│ ╲ ││]],
    [[││╲╲││]],
    [[││ ╲ │]],
  }, "\n"),
  items = {
    require("mini.starter").sections.builtin_actions(),
    require("mini.starter").sections.recent_files(5, true),
  },
  content_hooks = {
    require("mini.starter").gen_hook.indexing("all", { "Builtin actions" }),
    require("mini.starter").gen_hook.padding(3, 2),
    require("mini.starter").gen_hook.aligning("center", "center"),
  },
  footer = "",
})

require("mini.statusline").setup({
  set_vim_settings = false,
  content = {
    active = function()
      vim.opt.ruler = false

      local MiniStatusline = require("mini.statusline")

      local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
      local filename = MiniStatusline.section_filename({ trunc_width = 140 })
      local search = MiniStatusline.section_searchcount({})

      local selection = ""
      local mode_char = vim.fn.mode()
      if mode_char:match("[vV\22]") then
        local starts = vim.fn.line("v")
        local ends = vim.fn.line(".")
        local lines = math.abs(ends - starts) + 1
        local vcount = vim.fn.wordcount()
        local chars = vcount.visual_chars or 0
        selection = string.format("%dL %dC", lines, chars)
      end

      return MiniStatusline.combine_groups({
        { hl = "", strings = { filename } },
        { hl = "", strings = { diagnostics } },
        "%<",
        "%=",
        { hl = "", strings = { selection, search } },
      })
    end,
  },
})

-- Use winbar instead of statusline
vim.o.laststatus = 0
vim.o.winbar = "%!v:lua.MiniStatusline.active()"

-- Make statusline/winbar transparent
vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })
vim.api.nvim_set_hl(0, "WinBar", { bg = "NONE" })
vim.api.nvim_set_hl(0, "WinBarNC", { bg = "NONE" })

require("mini.trailspace").setup({
  only_in_normal_buffers = true,
})

require("mini.bracketed").setup({
  buffer = { suffix = "b", options = {} },
  comment = { suffix = "c", options = {} },
  conflict = { suffix = "x", options = {} },
  diagnostic = { suffix = "d", options = {} },
  quickfix = { suffix = "q", options = {} },
})

local miniclue = require("mini.clue")
miniclue.setup({
  triggers = {
    { mode = "n", keys = "<Leader>" },
    { mode = "x", keys = "<Leader>" },
    { mode = "n", keys = "g" },
    { mode = "x", keys = "g" },
    { mode = "n", keys = "<C-w>" },
  },
  clues = {
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.windows(),
  },
})

require("mini.files").setup({
  windows = {
    preview = true,
    width_focus = 30,
    width_preview = 60,
  },
  options = {
    use_as_default_explorer = true,
  },
})

vim.keymap.set("n", "<leader>e", function()
  require("mini.files").open()
end, { desc = "file explorer" })
vim.keymap.set("n", "<leader>E", function()
  require("mini.files").open(vim.api.nvim_buf_get_name(0))
end, { desc = "file explorer (current file)" })
vim.keymap.set("n", "<leader>ghp", function()
  require("mini.diff").toggle_overlay()
end, { desc = "toggle git hunk preview" })
