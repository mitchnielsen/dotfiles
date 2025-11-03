return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "saghen/blink.cmp",
    "b0o/schemastore.nvim",
  },
  ft = {
    "go",
    "ruby",
    "lua",
    "json",
    "yaml",
    "python",
    "tf",
    "terraform",
    "typescriptreact",
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  keys = {
    { "K", "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "lsp: hover" },
    { "gR", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "lsp: rename" }, -- default: grn
    { "ge", "<cmd>lua vim.diagnostic.open_float()<CR>", desc = "lsp: show full error" },
    { "]e", "<cmd>lua vim.diagnostic.goto_next()<CR>", desc = "lsp: next error" },
    { "[e", "<cmd>lua vim.diagnostic.goto_prev()<CR>", desc = "lsp: previous error" },
    { "gr", "<cmd>FzfLua lsp_references<CR>", desc = "lsp: references" }, -- default: grr
    { "gi", "<cmd>FzfLua lsp_implementations<CR>", desc = "lsp: implementation" }, -- gri
    { "gd", "<cmd>FzfLua lsp_definitions<CR>", desc = "lsp: definition" },
    { "ga", "<cmd>FzfLua lsp_code_actions<CR>", desc = "lsp: code action" }, -- default: gra
  }, -- ctrl-S for signature help in insert and select mode
  config = function()
    local vim = vim

    -- Disable to avoid a large log file.
    -- Set to "debug" when debugging.
    vim.lsp.log.set_level("off")

    -- Simple servers without custom config
    local servers = { "ruff", "pyright", "ts_ls", "marksman", "terraformls", "tflint", "jsonls", "yamlls" }

    -- Servers with custom config
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
        settings = {
          yaml = {
            schemaStore = {
              -- You must disable built-in schemaStore support if you want to use
              -- this plugin and its advanced options like `ignore`.
              enable = false,

              -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
              url = "",
            },

            schemas = require("schemastore").yaml.schemas({
              extra = {
                {
                  name = "Kubernetes",
                  description = "Kubernetes resource manifest",
                  url = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.34.1-standalone/all.json",
                  fileMatch = {
                    "**/*.yaml",
                  },
                },
              },
            }),
          },
        },
      },
    }

    local capabilities = require("blink.cmp").get_lsp_capabilities()

    -- Setup simple servers
    for _, server in ipairs(servers) do
      vim.lsp.config(server, {
        capabilities = capabilities,
      })
      vim.lsp.enable(server)
    end

    -- Setup servers with custom config
    for server, config in pairs(custom_servers) do
      vim.lsp.config(
        server,
        vim.tbl_extend("force", {
          capabilities = capabilities,
        }, config)
      )
      vim.lsp.enable(server)
    end
  end,
}
