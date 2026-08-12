vim.pack.add({
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.10") },
}, { confirm = false })

require("blink.cmp").setup({
  keymap = {
    preset = "enter",
    ["<Tab>"] = { "select_next", "fallback" },
    ["<S-Tab>"] = { "select_prev", "fallback" },
    ["<C-u>"] = { "scroll_documentation_up", "fallback" },
    ["<C-d>"] = { "scroll_documentation_down", "fallback" },
  },
  signature = {
    enabled = true,
    window = { border = "single" },
  },
  completion = {
    menu = {
      border = "single",
      auto_show = false,
    },
    ghost_text = {
      enabled = true,
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 100,
    },
    list = {
      selection = {
        preselect = false,
      },
    },
  },
  cmdline = {
    enabled = false,
  },
})
