return {
  "ibhagwan/fzf-lua",
  dependencies = "kyazdani42/nvim-web-devicons",
  cmd = "FzfLua",
  keys = {
    { "<leader>ff", "<cmd>FzfLua files<CR>", desc = "[f]ind [f]iles" },
    { "<leader>fg", "<cmd>FzfLua live_grep<CR>", desc = "[f]ind with [g]rep" },
    { "<leader>fG", "<cmd>FzfLua live_grep_resume<CR>", desc = "[f]ind with [g]rep (resume)" },
    { "<leader>fw", "<cmd>FzfLua grep_cword<CR>", desc = "[f]ind [w]ord under cursor with grep" },
    { "<leader>fb", "<cmd>FzfLua buffers<CR>", desc = "[f]ind [b]uffers" },
    { "<leader>fs", "<cmd>FzfLua lsp_document_symbols<CR>", desc = "[f]ind [s]ymbols" }, -- default: gO
    { "<leader>fd", "<cmd>FzfLua lsp_document_diagnostics<CR>", desc = "[f]ind [d]iagnostics" },
    { "<leader>fc", "<cmd>FzfLua command_history<CR>", desc = "[f]ind [c]ommand history" },
  },
  config = function()
    local actions = require("fzf-lua.actions")
    local sharedActions = {
      ["default"] = actions.file_edit_or_qf,
      ["ctrl-s"] = actions.file_split,
      ["ctrl-v"] = actions.file_vsplit,
      ["ctrl-t"] = actions.file_tabedit,
    }

    -- equal to ~/.config/ripgrep/.ignore
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
      fzf_colors = true, -- auto generate based on current nvim theme
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
          winopts = {
            number = false,
          },
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
        bat = {
          theme = "ansi", -- bat --list-themes
        },
      },
      files = {
        git_icons = false, -- for performance
        file_icons = false, -- for performance
        follow = true,
        file_ignore_patterns = ignored_files,
        actions = sharedActions,
        line_query = true, -- go to line (myfile.txt:5)
        no_ignore = true,
      },
      grep = {
        git_icons = false, -- for performance
        file_icons = false, -- for performance
        prompt = "rg: ",
        actions = sharedActions,
        RIPGREP_CONFIG_PATH = vim.env.RIPGREP_CONFIG_PATH, -- reuse config options
        no_ignore = true, -- define our own ignore pattern below
        file_ignore_patterns = ignored_files,
      },
      lsp = {
        jump1 = true, -- jump directly when only 1 result
        ignore_current_line = true,
        includeDeclaration = false,
      },
    })
  end,
}
