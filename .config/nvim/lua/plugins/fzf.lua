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
  },
  config = function ()
    local actions = require "fzf-lua.actions"
    local sharedActions = {
      ["default"]     = actions.file_edit_or_qf,
      ["ctrl-s"]      = actions.file_split,
      ["ctrl-v"]      = actions.file_vsplit,
      ["ctrl-t"]      = actions.file_tabedit,
    }

    local rg_common_opts = '--color=always --no-ignore --hidden --smart-case --line-number --glob "!.git/*"'
    local files_opts = rg_common_opts .. ' ' .. '--files --follow'

    require'fzf-lua'.setup {
      winopts = {
        preview = {
          wrap = 'wrap', -- wrap|nowrap
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
          theme = 'OneHalfDark', -- bat --list-themes
        },
      },
      files = {
        rg_opts = files_opts,
        actions = sharedActions,
      },
      grep = {
        prompt = 'rg❯ ',
        rg_opts = rg_common_opts,
        actions = sharedActions,
      },
    }
  end
}
