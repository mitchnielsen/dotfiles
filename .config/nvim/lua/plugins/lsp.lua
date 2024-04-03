return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'mrjones2014/nvim-ts-rainbow',
    'ray-x/lsp_signature.nvim',
    'nvim-lua/lsp-status.nvim',
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim"
  },
  ft = {
    "go",
    "ruby",
    "lua",
    "yaml",
    "python",
  },
  keys = {
    {"K", "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "hover"},
    {"gR", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "rename"},
    {"gr", "<cmd>lua vim.lsp.buf.references()<CR>", desc = "references"},
    {"gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", desc = "implementation"},
    {"gd", "<cmd>lua vim.lsp.buf.definition()<CR>", desc = "definition"},
  },
  config = function()
    local vim = vim

    vim.g.lsp_config = {
      lua = {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      },
    }

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

    local servers = {
      "pyright",
      "gopls",
      "solargraph",
      "tsserver",
      "marksman"
    }

    require('mason').setup()
    require'mason-lspconfig'.setup {
      ensure_installed = servers
    }

    require("lsp_signature").setup({ hint_enable = false })

    local lsp_status = require('lsp-status')
    lsp_status.register_progress()
    capabilities = vim.tbl_extend('keep', capabilities or {}, lsp_status.capabilities)

    for _, lsp in ipairs(servers) do
      require("lspconfig")[lsp].setup {
        capabilities = capabilities,
        on_attach = lsp_status.on_attach
      }
    end

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

    require'lspconfig'.yamlls.setup {
      settings = {
        yaml = {
          ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = "/.gitlab-ci.yml",
        },
      },
    }

    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics,
      {
        underline = true,
        virtual_text = false,
        signs = true,
        update_in_insert = true,
      }
    )
  end,
}
