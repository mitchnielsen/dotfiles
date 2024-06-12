return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'mrjones2014/nvim-ts-rainbow',
    'ray-x/lsp_signature.nvim',
    'nvim-lua/lsp-status.nvim',
  },
  ft = {
    "go",
    "ruby",
    "lua",
    "yaml",
    "python",
    "terraform",
  },
  keys = {
    {"K", "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "lsp: hover"},
    {"gR", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "lsp: rename"},
    {"gr", "<cmd>FzfLua lsp_references<CR>", desc = "lsp: references"},
    {"gi", "<cmd>FzfLua lsp_implementations<CR>", desc = "lsp: implementation"},
    {"gd", "<cmd>FzfLua lsp_definitions<CR>", desc = "lsp: definition"},
    {"ca", "<cmd>FzfLua lsp_code_actions<CR>", desc = "lsp: code action"},
  },
  config = function()
    local vim = vim

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

    require("lsp_signature").setup({ hint_enable = false })

    local lsp_status = require('lsp-status')
    lsp_status.register_progress()
    capabilities = vim.tbl_extend('keep', capabilities or {}, lsp_status.capabilities)

    local servers = {
      "ruff",       -- Python
      "ruff_lsp",   -- Python
      "pyright",    -- Python
      "tsserver",   -- Typescript
      "marksman",   -- Markdown
      "terraformls", -- Terraform
      "tflint",     -- Terraform
    }

    for _, lsp in ipairs(servers) do
      require("lspconfig")[lsp].setup {
        capabilities = capabilities,
        on_attach = lsp_status.on_attach
      }
    end

    require("lspconfig").gopls.setup({
      capabilities = capabilities,
      on_attach = lsp_status.on_attach,
      settings = {
        gopls = {
          -- https://github.com/golang/tools/blob/master/gopls/doc/inlayHints.md
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
    })

    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls
    require'lspconfig'.lua_ls.setup {
      settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT',
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = {'vim'},
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file("", true),
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = {
            enable = false,
          },
        },
      },
    }
  end,
}
