return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require('copilot').setup({
        panel = {
          enabled = false, -- defer to blink
        },
        suggestion = {
          enabled = false, -- defer to blink
          auto_trigger = false,
          hide_during_completion = true,
          debounce = 75,
          keymap = {
            accept = "<C-y>",
            accept_word = false,
            accept_line = true,
            next = "<C-]>",
            prev = "<C-[>",
            dismiss = "<ESC>",
          },
        },
        filetypes = {
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ["."] = false,
        },
      })
    end,
  }
