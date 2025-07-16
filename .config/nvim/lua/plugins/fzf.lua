return {
  "ibhagwan/fzf-lua",
  dependencies = "kyazdani42/nvim-web-devicons",
  cmd = "FzfLua",
  keys = {
    { "<leader>gg", "<cmd>FzfLua live_grep_glob<CR>", desc = "grep" },
    { "<leader>gG", "<cmd>FzfLua live_grep_resume<CR>", desc = "grep resume" },
    { "<leader>gw", "<cmd>FzfLua grep_cword<CR>", desc = "grep cursor word" },
    { "<leader>f", "<cmd>FzfLua files<CR>", desc = "files" },
    { "<leader>b", "<cmd>FzfLua buffers<CR>", desc = "grep buffers" },
    { "<leader>s", "<cmd>FzfLua lsp_document_symbols<CR>", desc = "symbols" }, -- default: gO
    { "<leader>h", "<cmd>FzfLua lsp_document_diagnostics<CR>", desc = "diagnostics" },
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
        preview = {
          wrap = "wrap", -- wrap|nowrap
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
