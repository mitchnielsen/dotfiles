vim.pack.add({ "https://github.com/echasnovski/mini.nvim" }, { confirm = false })

require("mini.ai").setup() -- more around/in textobjects
require("mini.cmdline").setup() -- better cmdline experience
require("mini.comment").setup() -- commenting shortcuts
require("mini.cursorword").setup() -- highlight instances of word under cursor
require("mini.icons").setup() -- show filetype icons
require("mini.surround").setup() -- actions to surround textobjects

require("mini.diff").setup({
  view = {
    style = "sign", -- easier to parse than just colors on numbers
    signs = { add = "+", change = "~", delete = "-" },
  },
  mappings = {
    apply = "ghs", -- stage a hunk
    reset = "ghr", -- reset a hunk
  },
})

-- show a helpful start page
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

-- show helpful info in the statusline
require("mini.statusline").setup({
  set_vim_settings = false,
  content = {
    active = function()
      vim.opt.ruler = false

      local MiniStatusline = require("mini.statusline")

      local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })

      -- hide filename on ministarter screens
      local filename = vim.bo.filetype == "ministarter" and "" or MiniStatusline.section_filename({ trunc_width = 140 })

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

-- use winbar for file info, global statusline for split separation
vim.o.laststatus = 3
vim.o.winbar = "%!v:lua.MiniStatusline.active()"

-- make statusline/winbar transparent
vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })
vim.api.nvim_set_hl(0, "WinBar", { bg = "NONE" })
vim.api.nvim_set_hl(0, "WinBarNC", { bg = "NONE" })

-- highlight trailing spaces
require("mini.trailspace").setup({
  only_in_normal_buffers = true,
})

-- go forward/backward with square brackets
require("mini.bracketed").setup({
  buffer = { suffix = "b", options = {} },
  comment = { suffix = "c", options = {} },
  conflict = { suffix = "x", options = {} },
  diagnostic = { suffix = "d", options = {} },
  quickfix = { suffix = "q", options = {} },
})

-- keymap hints
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

-- file explorer
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

-- open mini.files explorer
vim.keymap.set("n", "<leader>e", function()
  require("mini.files").open()
end, { desc = "file explorer" })

-- open mini.files explorer at the current file
vim.keymap.set("n", "<leader>E", function()
  require("mini.files").open(vim.api.nvim_buf_get_name(0))
end, { desc = "file explorer (current file)" })

vim.keymap.set("n", "<leader>ghp", function()
  require("mini.diff").toggle_overlay()
end, { desc = "toggle git hunk preview" })
