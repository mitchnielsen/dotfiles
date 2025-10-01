return {
  "stevearc/conform.nvim", -- automatically format on save
  opts = {},
  lazy = false,
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        go = { "goimports", "gofmt" },
        python = { "ruff_format" },
        terraform = { "terraform_fmt" },
        sh = { "shellcheck" },
        lua = { "stylua" },
        yaml = { "yamlfmt" },
      },

      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end

        return { timeout_ms = 500, lsp_format = "fallback" }
      end,
    })

    -- https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#command-to-toggle-format-on-save
    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, {
      desc = "Disable autoformat-on-save",
      bang = true,
    })
    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, {
      desc = "Re-enable autoformat-on-save",
    })
  end,
}
