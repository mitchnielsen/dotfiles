return {
  "ibhagwan/fzf-lua",
  dependencies = "kyazdani42/nvim-web-devicons",
  cmd = "FzfLua",
  keys = {
    { "<leader>rg", "<cmd>FzfLua live_grep_glob<CR>", desc = "grep" },
    { "<leader>f", "<cmd>FzfLua files<CR>", desc = "files" },
    { "<leader>rG", "<cmd>FzfLua live_grep_resume<CR>", desc = "grep resume" },
    { "<leader>rw", "<cmd>FzfLua grep_cword<CR>", desc = "grep cursor word" },
    { "<leader>b", "<cmd>FzfLua buffers<CR>", desc = "grep buffers" },
  },
  setup = function ()
    local actions = require "fzf-lua.actions"
    require'fzf-lua'.setup {
      winopts = {
        fullscreen       = false,           -- start fullscreen?
        -- split            = "belowright new",
        height           = 0.90,            -- window height
        width            = 0.90,            -- window width
        row              = 0.35,            -- window row position (0=top, 1=bottom)
        col              = 0.50,            -- window col position (0=left, 1=right)
        preview = {
          wrap           = 'wrap',          -- wrap|nowrap
          layout         = 'vertical',
          winopts = {                       -- builtin previewer window options
            number            = true,
            relativenumber    = false,
            cursorline        = true,
            cursorlineopt     = 'both',
            cursorcolumn      = false,
            signcolumn        = 'no',
            list              = false,
            foldenable        = false,
            foldmethod        = 'manual',
          },
        },
      },
      keymap = {
        fzf = {
          ["ctrl-z"]      = "abort",
          ["ctrl-d"]      = "half-page-down",
          ["ctrl-u"]      = "half-page-up",
          ["ctrl-a"]      = "beginning-of-line",
          ["ctrl-e"]      = "end-of-line",
          ["alt-a"]       = "toggle-all",
        },
      },
      fzf_opts = {
        ['--ansi']        = '',
        ['--prompt']      = '> ',
        ['--info']        = 'inline',
        ['--height']      = '100%',
        ['--layout']      = 'reverse',
      },
      previewers = {
        bat = {
          cmd             = "bat",
          args            = "--style=numbers,changes --color always",
          theme           = 'OneHalfDark', -- bat preview theme (bat --list-themes)
        },
      },
      files = {
        rg_opts           = '--color=always --no-ignore --hidden --smart-case --line-number',
        actions = {
          ["default"]     = actions.file_edit_or_qf,
          ["ctrl-s"]      = actions.file_split,
          ["ctrl-v"]      = actions.file_vsplit,
          ["ctrl-t"]      = actions.file_tabedit,
        }
      },
      grep = {
        prompt            = 'Rg❯ ',
        cmd               = "rg --vimgrep",
        rg_opts           = '--color=always --no-ignore --hidden --smart-case --line-number',
        actions = {
          ["default"]     = actions.file_edit_or_qf,
          ["ctrl-s"]      = actions.file_split,
          ["ctrl-v"]      = actions.file_vsplit,
          ["ctrl-t"]      = actions.file_tabedit,
        }
      },
    }
  end
}
