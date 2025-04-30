return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'saghen/blink.cmp',
  },
  ft = {
    "go",
    "ruby",
    "lua",
    "yaml",
    "python",
    "tf",
    "terraform",
  },
  keys = {
    {"K", "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "lsp: hover"},
    {"gR", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "lsp: rename"}, -- default: grn
    {"ge", "<cmd>lua vim.diagnostic.open_float()<CR>", desc = "lsp: show full error"},
    {"]e", "<cmd>lua vim.diagnostic.goto_next()<CR>", desc = "lsp: next error"},
    {"[e", "<cmd>lua vim.diagnostic.goto_prev()<CR>", desc = "lsp: previous error"},
    {"gr", "<cmd>FzfLua lsp_references<CR>", desc = "lsp: references"}, -- default: grr
    {"gi", "<cmd>FzfLua lsp_implementations<CR>", desc = "lsp: implementation"}, -- gri
    {"gd", "<cmd>FzfLua lsp_definitions<CR>", desc = "lsp: definition"},
    {"ga", "<cmd>FzfLua lsp_code_actions<CR>", desc = "lsp: code action"}, -- default: gra
  }, -- ctrl-S for signature help in insert and select mode
  config = function()
    local vim = vim
    local lspconfig = require('lspconfig')

    -- Disable to avoid a large log file.
    -- Set to "debug" when debugging.
    vim.lsp.set_log_level("off")

    -- Simple servers without custom config
    local servers = { "ruff", "pyright", "ts_ls", "marksman", "terraformls", "tflint" }

    -- Servers with custom config
    local custom_servers = {
      lua_ls = {
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = {'vim'} },
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
    }

    local capabilities = require('blink.cmp').get_lsp_capabilities()

    -- Setup simple servers
    for _, server in ipairs(servers) do
      lspconfig[server].setup({
        capabilities = capabilities,
      })
    end

    -- Setup servers with custom config
    for server, config in pairs(custom_servers) do
      lspconfig[server].setup(vim.tbl_extend("force", {
        capabilities = capabilities,
      }, config))
    end
  end
}
