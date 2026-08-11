vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/artempyanykh/marksman",
}, { confirm = false })

vim.lsp.log.set_level("off")

local capabilities = require("blink.cmp").get_lsp_capabilities()

local servers = { "ruff", "pyright", "marksman", "terraformls", "tflint", "jsonls", "yamlls" }

local typescript_path =
  vim.fs.joinpath(vim.trim(vim.fn.system({ "mise", "where", "npm:typescript" })), "node_modules", "typescript")

local custom_servers = {
  ts_ls = {
    init_options = {
      tsserver = { fallbackPath = typescript_path },
    },
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
        ["ui.inlayhint.hints"] = {
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

for _, server in ipairs(servers) do
  vim.lsp.config(server, { capabilities = capabilities })
  vim.lsp.enable(server)
end

for server, config in pairs(custom_servers) do
  vim.lsp.config(server, vim.tbl_extend("force", { capabilities = capabilities }, config))
  vim.lsp.enable(server)
end

-- Commands
vim.api.nvim_create_user_command("LspInfo", function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    vim.notify("No LSP clients attached", vim.log.levels.WARN)
    return
  end
  for _, c in ipairs(clients) do
    print(string.format("  %s (id=%d) root=%s", c.name, c.id, c.root_dir or "none"))
  end
end, { desc = "Show LSP clients attached to current buffer" })

vim.api.nvim_create_user_command("LspLog", function()
  vim.cmd.edit(vim.lsp.log.get_filename())
end, { desc = "Open LSP log file" })

vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { desc = "lsp: hover" })
vim.keymap.set("n", "gR", "<cmd>lua vim.lsp.buf.rename()<CR>", { desc = "lsp: rename" })
vim.keymap.set("n", "ge", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "lsp: show full error" })
vim.keymap.set("n", "]e", "<cmd>lua vim.diagnostic.goto_next()<CR>", { desc = "lsp: next error" })
vim.keymap.set("n", "[e", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { desc = "lsp: previous error" })
vim.keymap.set("n", "gr", "<cmd>FzfLua lsp_references<CR>", { desc = "lsp: references" })
vim.keymap.set("n", "gi", "<cmd>FzfLua lsp_implementations<CR>", { desc = "lsp: implementation" })
vim.keymap.set("n", "gd", "<cmd>FzfLua lsp_definitions<CR>", { desc = "lsp: definition" })
vim.keymap.set("n", "ga", vim.lsp.buf.code_action, { desc = "lsp: code action" })
vim.keymap.set("n", "<leader>=", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", { desc = "format code" })
