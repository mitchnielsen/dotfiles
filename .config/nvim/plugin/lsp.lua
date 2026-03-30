vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/b0o/schemastore.nvim",
}, { confirm = false })

vim.lsp.log.set_level("off")

local capabilities = require("blink.cmp").get_lsp_capabilities()

local servers = { "ruff", "pyright", "ts_ls", "marksman", "terraformls", "tflint" }

local custom_servers = {
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
  jsonls = {
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
      },
    },
  },
  yamlls = {
    root_dir = function(fname, _)
      if type(fname) == "number" then
        fname = vim.api.nvim_buf_get_name(fname)
      end
      if fname:match("templates/.*%.yaml$") or fname:match("templates/.*%.yml$") then
        return nil
      end
      return vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1]) or vim.fs.dirname
    end,
    settings = {
      yaml = {
        schemaStore = {
          enable = false,
          url = "",
        },
        schemas = require("schemastore").yaml.schemas({
          extra = {
            {
              name = "Kubernetes",
              description = "Kubernetes resource manifest",
              url = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.34.1-standalone/all.json",
              fileMatch = { "**/*.yaml" },
            },
          },
        }),
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
  actionsls = {
    cmd = { "actions-languageserver", "--stdio" },
    filetypes = { "yaml.ghactions" },
    root_markers = { ".git" },
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
