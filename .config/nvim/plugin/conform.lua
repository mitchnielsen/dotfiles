vim.pack.add({ "https://github.com/stevearc/conform.nvim" }, { confirm = false })

require("conform").setup({
  formatters_by_ft = {
    go = { "goimports", "gofmt" },
    python = { "ruff_format" },
    terraform = { "terraform_fmt" },
    sh = { "shellcheck" },
    lua = { "stylua" },
    yaml = { "yamlfmt" },
    json = { "jq" },
  },
  format_on_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { timeout_ms = 500, lsp_format = "fallback" }
  end,
})

vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, { desc = "Disable autoformat-on-save", bang = true })

vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, { desc = "Re-enable autoformat-on-save" })
