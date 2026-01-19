return {
  "echasnovski/mini.nvim",
  version = false,
  lazy = false,
  config = function()
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
    require("mini.git").setup()
    require("mini.icons").setup()
    require("mini.pairs").setup()
    require("mini.surround").setup()

    require("mini.starter").setup({
      evaluate_single = true,
      items = {
        require("mini.starter").sections.builtin_actions(),
        require("mini.starter").sections.recent_files(5, false),
        require("mini.starter").sections.recent_files(5, true),
      },
      content_hooks = {
        require("mini.starter").gen_hook.indexing("all", { "Builtin actions" }),
        require("mini.starter").gen_hook.padding(3, 2),
        require("mini.starter").gen_hook.aligning("center", "center"),
      },
      footer = "", -- hide instructions
    })

    require("mini.trailspace").setup({
      only_in_normal_buffers = true,
    })

    -- Disable trailspace in snacks dashboard
    local trailspace_group = vim.api.nvim_create_augroup("MiniTrailspaceDashboard", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "snacks_dashboard",
      callback = function()
        vim.b.minitrailspace_disable = true
        require("mini.trailspace").unhighlight()
      end,
      group = trailspace_group,
    })
    vim.api.nvim_create_autocmd("User", {
      pattern = "SnacksDashboardOpened",
      callback = function()
        vim.b.minitrailspace_disable = true
        require("mini.trailspace").unhighlight()
      end,
      group = trailspace_group,
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
