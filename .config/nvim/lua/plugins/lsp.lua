return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "saghen/blink.cmp",
    "b0o/schemastore.nvim",
  },
  ft = {
    "markdown",
    "go",
    "ruby",
    "lua",
    "json",
    "yaml",
    "yaml.ghactions",
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

    -- Disable to avoid a large logfile.
    -- Set to "debug" when debugging.
    vim.lsp.log.set_level("off")

    local function get_github_token()
      local handle = io.popen("gh auth token 2>/dev/null")
      if not handle then
        return nil
      end
      local token = handle:read("*a"):gsub("%s+", "")
      handle:close()
      return token ~= "" and token or nil
    end

    local function parse_github_remote(url)
      if not url or url == "" then
        return nil
      end

      -- SSH format: git@github.com:owner/repo.git
      local owner, repo = url:match("git@github%.com:([^/]+)/([^/%.]+)")
      if owner and repo then
        return owner, repo:gsub("%.git$", "")
      end

      -- HTTPS format: https://github.com/owner/repo.git
      owner, repo = url:match("github%.com/([^/]+)/([^/%.]+)")
      if owner and repo then
        return owner, repo:gsub("%.git$", "")
      end

      return nil
    end

    local function get_repo_info(owner, repo)
      local cmd = string.format(
        "gh repo view %s/%s --json id,owner --template '{{.id}}\t{{.owner.type}}' 2>/dev/null",
        owner,
        repo
      )
      local handle = io.popen(cmd)
      if not handle then
        return nil
      end
      local result = handle:read("*a"):gsub("%s+$", "")
      handle:close()

      local id, owner_type = result:match("^(%d+)\t(.+)$")
      if id then
        return {
          id = tonumber(id),
          organizationOwned = owner_type == "Organization",
        }
      end
      return nil
    end

    local function get_repos_config()
      local handle = io.popen("git rev-parse --show-toplevel 2>/dev/null")
      if not handle then
        return nil
      end
      local git_root = handle:read("*a"):gsub("%s+", "")
      handle:close()

      if git_root == "" then
        return nil
      end

      handle = io.popen("git remote get-url origin 2>/dev/null")
      if not handle then
        return nil
      end
      local remote_url = handle:read("*a"):gsub("%s+", "")
      handle:close()

      local owner, name = parse_github_remote(remote_url)
      if not owner or not name then
        return nil
      end

      local info = get_repo_info(owner, name)

      return {
        {
          id = info and info.id or 0,
          owner = owner,
          name = name,
          organizationOwned = info and info.organizationOwned or false,
          workspaceUri = "file://" .. git_root,
        },
      }
    end

    -- Simple servers without custom config
    local servers = { "ruff", "pyright", "ts_ls", "marksman", "terraformls", "tflint" }

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
        root_dir = function(fname, _)
          -- Handle case where fname might be a buffer number
          if type(fname) == "number" then
            fname = vim.api.nvim_buf_get_name(fname)
          end

          -- Disable yamlls for Helm chart templates
          if fname:match("templates/.*%.yaml$") or fname:match("templates/.*%.yml$") then
            return nil
          end
          return vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1]) or vim.fs.dirname
        end,
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
      harper_ls = {
        settings = {
          ["harper-ls"] = {
            -- https://writewithharper.com/docs/rules
            linters = {
              SentenceCapitalization = false,
              SpellCheck = false,
              SplitWords = false,
            },
          },
        },
      },
      -- https://github.com/actions/languageservices/tree/main/languageserver
      actionsls = {
        cmd = { "actions-languageserver", "--stdio" },
        filetypes = { "yaml.ghactions" },
        root_markers = { ".git" },
        init_options = {
          -- Optional: provide a GitHub token and repo context for added functionality
          -- (e.g., repository-specific completions)
          sessionToken = get_github_token(),
          repos = get_repos_config(),
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
