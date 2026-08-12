vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" }, { confirm = false })

vim.lsp.log.set_level("off")

vim.lsp.config("*", {
  capabilities = require("blink.cmp").get_lsp_capabilities(),
})

local servers = { "ruff", "pyright", "marksman", "terraformls", "tflint", "jsonls", "yamlls" }

local custom_servers = {
  ts_ls = {
    before_init = function(_, config)
      local typescript_root = vim.trim(vim.fn.system({ "mise", "where", "npm:typescript" }))
      config.init_options.tsserver = {
        fallbackPath = vim.fs.joinpath(typescript_root, "node_modules", "typescript"),
      }
    end,
  },
  lua_ls = {
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        diagnostics = { globals = { "vim" } },
        workspace = { library = vim.api.nvim_get_runtime_file("", true) },
        telemetry = { enable = false },
      },
    },
  },
  gopls = {
    settings = {
      gopls = {
        hints = {
          assignVariableTypes = false,
          compositeLiteralFields = false,
          compositeLiteralTypes = false,
          constantValues = false,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = false,
        },
      },
    },
  },
  harper_ls = {
    settings = {
      ["harper-ls"] = {
        linters = {
          SentenceCapitalization = false,
          SpellCheck = false,
          SplitWords = false,
        },
      },
    },
  },
}

for server, config in pairs(custom_servers) do
  vim.lsp.config(server, config)
  table.insert(servers, server)
end
vim.lsp.enable(servers)

vim.api.nvim_create_user_command("LspInfo", "checkhealth vim.lsp", {
  desc = "Show LSP health and attached clients",
})
vim.api.nvim_create_user_command("LspLog", function()
  vim.cmd.edit(vim.lsp.log.get_filename())
end, { desc = "Open the LSP log" })

vim.keymap.set("n", "gR", "<cmd>lua vim.lsp.buf.rename()<CR>", { desc = "lsp: rename" })
vim.keymap.set("n", "ge", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "lsp: show diagnostic" })
vim.keymap.set("n", "]e", function()
  vim.diagnostic.jump({ count = 1 })
end, { desc = "lsp: next diagnostic" })
vim.keymap.set("n", "[e", function()
  vim.diagnostic.jump({ count = -1 })
end, { desc = "lsp: previous diagnostic" })
vim.keymap.set("n", "gr", "<cmd>FzfLua lsp_references<CR>", { desc = "lsp: references" })
vim.keymap.set("n", "gi", "<cmd>FzfLua lsp_implementations<CR>", { desc = "lsp: implementation" })
vim.keymap.set("n", "gd", "<cmd>FzfLua lsp_definitions<CR>", { desc = "lsp: definition" })
vim.keymap.set("n", "ga", vim.lsp.buf.code_action, { desc = "lsp: code action" })
