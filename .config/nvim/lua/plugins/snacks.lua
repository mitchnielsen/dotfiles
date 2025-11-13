return {
  "folke/snacks.nvim",
  lazy = false,
  ---@type snacks.Config
  opts = {
    indent = {
      animate = { enabled = false },
    },
    gitbrowse = {},
    picker = {
      layout = "ivy",
      sources = {
        explorer = {
          hidden = true,
        },
        files = {
          hidden = true,
        },
      },
    },

    -- dashboard = {
    --   sections = {
    --     { section = "header" },
    --     { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
    --     { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
    --     { section = "startup" },
    --   },
    --   preset = {
    --     keys = {
    --       {
    --         icon = " ",
    --         key = "f",
    --         desc = "Find File",
    --         action = ":FzfLua files",
    --       },
    --       { icon = " ", key = "e", desc = "New File", action = ":ene | startinsert" },
    --       { icon = " ", key = "g", desc = "Lazygit", action = ":lua Snacks.lazygit.open()" },
    --       { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy },
    --       {
    --         icon = " ",
    --         key = "s",
    --         desc = "Settings",
    --         action = ":e ~/dotfiles",
    --       },
    --       { icon = " ", key = "q", desc = "Quit", action = ":qa" },
    --     },
    --   },
    -- },
  },
  keys = {
    {
      "<leader>gbr",
      function()
        Snacks.gitbrowse()
      end,
      desc = "Open in GitHub",
    },
    {
      "<leader>gbR",
      function()
        Snacks.gitbrowse.open({
          open = function(url)
            vim.fn.setreg("+", url)
            vim.notify("Yanked url to clipboard")
          end,
        })
      end,
      desc = "Copy GitHub URL",
    },
  },
}
