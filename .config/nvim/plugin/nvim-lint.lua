vim.pack.add({ "https://github.com/mfussenegger/nvim-lint" }, { confirm = false })

vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = false,
  severity_sort = true,
  update_in_insert = false,
  float = {
    focusable = false,
    header = "Diagnostics",
    source = true,
    border = "rounded",
    format = function(diagnostic)
      if diagnostic.code then
        return string.format("%s %s", diagnostic.code, diagnostic.message)
      end
      return diagnostic.message
    end,
  },
})

local lint = require("lint")
table.insert(lint.linters.shellcheck.args, 3, "-x")

lint.linters_by_ft = {
  sh = { "shellcheck" },
  bash = { "shellcheck" },
  yaml = { "yamllint" },
  markdown = { "markdownlint", "vale" },
  json = { "jsonlint" },
  go = { "golangcilint" },
  dockerfile = { "hadolint" },
}

vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("Lint", { clear = true }),
  callback = function()
    lint.try_lint()
  end,
})

vim.keymap.set("n", "<leader>l", function()
  if vim.diagnostic.is_enabled() then
    vim.diagnostic.enable(false)
  else
    vim.diagnostic.enable(true)
  end
end, { desc = "toggle diagnostics" })

vim.api.nvim_create_user_command("LintInfo", function()
  local filetype = vim.bo.filetype
  local linters = require("lint").linters_by_ft[filetype]
  if linters then
    print("Linters for " .. filetype .. ": " .. table.concat(linters, ", "))
  else
    print("No linters configured for filetype: " .. filetype)
  end
end, { desc = "Show linters configured for the current filetype" })
