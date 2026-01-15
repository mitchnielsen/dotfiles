return {
  "echasnovski/mini.nvim",
  version = false,
  lazy = false,
  config = function()
    require("mini.ai").setup()
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
    require("mini.git").setup()
    require("mini.icons").setup()
    require("mini.pairs").setup()
    require("mini.surround").setup()
    require("mini.trailspace").setup()

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

    -- mini.files - File picker
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
  end,
  keys = {
    {
      "<leader>e",
      function()
        require("mini.files").open()
      end,
      desc = "file explorer",
    },
    {
      "<leader>E",
      function()
        require("mini.files").open(vim.api.nvim_buf_get_name(0))
      end,
      desc = "file explorer (current file)",
    },
    {
      "<leader>ghp",
      function()
        require("mini.diff").toggle_overlay()
      end,
      desc = "toggle git hunk preview",
    },
  },
}
