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
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
  appearance = {
    use_nvim_cmp_as_default = false,
    nerd_font_variant = "mono",
    kind_icons = {
      Text = "󰉿",
      Method = "󰊕",
      Function = "󰊕",
      Constructor = "󰒓",
      Field = "󰜢",
      Variable = "󰆦",
      Property = "󰖷",
      Class = "󱡠",
      Interface = "󱡠",
      Struct = "󱡠",
      Module = "󰅩",
      Unit = "󰪚",
      Value = "󰦨",
      Enum = "󰦨",
      EnumMember = "󰦨",
      Keyword = "󰻾",
      Constant = "󰏿",
      Snippet = "󱄽",
      Color = "󰏘",
      File = "󰈔",
      Reference = "󰬲",
      Folder = "󰉋",
      Event = "󱐋",
      Operator = "󰪚",
      TypeParameter = "󰬛",
    },
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
      show_with_menu = true,
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 100,
      treesitter_highlighting = true,
    },
    list = {
      selection = {
        preselect = false,
        auto_insert = true,
      },
    },
  },
  cmdline = {
    enabled = false,
  },
})
