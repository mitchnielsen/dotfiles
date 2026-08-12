vim.pack.add({ "https://github.com/echasnovski/mini.nvim" }, { confirm = false })

require("mini.ai").setup() -- more around/in textobjects
require("mini.cmdline").setup() -- better cmdline experience
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
local starter = require("mini.starter")
starter.setup({
  evaluate_single = true,
  header = table.concat({
    [[│ ╲ ││]],
    [[││╲╲││]],
    [[││ ╲ │]],
  }, "\n"),
  items = {
    starter.sections.builtin_actions(),
    starter.sections.recent_files(5, true),
  },
  content_hooks = {
    starter.gen_hook.indexing("all", { "Builtin actions" }),
    starter.gen_hook.padding(3, 2),
    starter.gen_hook.aligning("center", "center"),
  },
  footer = "",
})

-- show helpful info in the statusline
vim.o.ruler = false
require("mini.statusline").setup({
  set_vim_settings = false,
  content = {
    active = function()
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
local files = require("mini.files")
files.setup({
  windows = {
    preview = true,
    width_focus = 30,
    width_preview = 60,
  },
})

local function map_split(buf_id, lhs, direction)
  vim.keymap.set("n", lhs, function()
    local target = files.get_explorer_state().target_window
    local split = vim.api.nvim_win_call(target, function()
      vim.cmd(direction .. " split")
      return vim.api.nvim_get_current_win()
    end)

    files.set_target_window(split)
    files.go_in({ close_on_file = true })
  end, { buffer = buf_id, desc = "Open in " .. direction .. " split" })
end

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesBufferCreate",
  callback = function(args)
    map_split(args.data.buf_id, "<C-s>", "belowright horizontal")
    map_split(args.data.buf_id, "<C-v>", "belowright vertical")
  end,
})

vim.keymap.set("n", "<leader>e", function()
  files.open()
end, { desc = "file explorer" })

vim.keymap.set("n", "<leader>E", function()
  files.open(vim.api.nvim_buf_get_name(0))
end, { desc = "file explorer (current file)" })

vim.keymap.set("n", "<leader>ghp", function()
  require("mini.diff").toggle_overlay()
end, { desc = "toggle git hunk preview" })
