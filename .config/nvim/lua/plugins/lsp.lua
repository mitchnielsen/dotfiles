return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'ray-x/lsp_signature.nvim',
    'nvim-lua/lsp-status.nvim',
    'hrsh7th/cmp-nvim-lsp',
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
    {"gR", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "lsp: rename"},
    {"gr", "<cmd>FzfLua lsp_references<CR>", desc = "lsp: references"},
    {"gi", "<cmd>FzfLua lsp_implementations<CR>", desc = "lsp: implementation"},
    {"gd", "<cmd>FzfLua lsp_definitions<CR>", desc = "lsp: definition"},
    {"ga", "<cmd>FzfLua lsp_code_actions<CR>", desc = "lsp: code action"},
  },
  config = function()
    local vim = vim
    local lspconfig = require('lspconfig')
    local lsp_status = require('lsp-status')

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
    capabilities = vim.tbl_extend('keep', capabilities, lsp_status.capabilities)

    require("lsp_signature").setup({
      hint_enable = false,
      floating_window = true,
      handler_opts = {
        border = "single",
      },
    })

    lsp_status.register_progress()

    -- Simple servers without custom config
    local servers = { "ruff", "ruff_lsp", "pyright", "ts_ls", "marksman", "terraformls", "tflint" }

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

    -- Setup simple servers
    for _, server in ipairs(servers) do
      lspconfig[server].setup({
        capabilities = capabilities,
        on_attach = lsp_status.on_attach,
      })
    end

    -- Setup servers with custom config
    for server, config in pairs(custom_servers) do
      lspconfig[server].setup(vim.tbl_extend("force", {
        capabilities = capabilities,
        on_attach = lsp_status.on_attach,
      }, config))
    end
  end
}
