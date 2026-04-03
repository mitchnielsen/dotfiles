vim.pack.add({ "https://github.com/mfussenegger/nvim-lint" }, { confirm = false })

vim.diagnostic.config({
  focus = false,
  virtual_text = false,
  virtual_lines = false,
  current_line = false,
  signs = true,
  severity_sort = true,
  update_in_insert = false, -- don't update when typing
  float = {
    header = "Diagnostics",
    source = true,
    border = "rounded",
    format = function(diagnostic)
      if diagnostic.user_data and diagnostic.user_data.code then
        return string.format("%s %s", diagnostic.user_data.code, diagnostic.message)
      else
        return diagnostic.message
      end
    end,
  },
})

vim.filetype.add({
  pattern = {
    [".*/.github/workflows/.*%.yml"] = "yaml.ghaction",
    [".*/.github/workflows/.*%.yaml"] = "yaml.ghaction",
  },
})

local lint = require("lint")

lint.linters.shellcheck.args = { "-s", "sh", "--format", "json", "-x", "-" }

lint.linters_by_ft = {
  sh = { "shellcheck" },
  bash = { "shellcheck" },
  ghaction = { "actionlint" },
  yaml = { "yamllint" },
  markdown = { "markdownlint", "vale" },
  ruby = { "rubocop" },
  json = { "jsonlint" },
  python = { "ruff" },
  terraform = { "tflint" },
  go = { "golangcilint" },
  dockerfile = { "hadolint" },
}

lint.try_lint()

vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function()
    require("lint").try_lint()
  end,
})

vim.keymap.set("n", "<leader>l", function()
  if vim.diagnostic.is_enabled() then
    vim.diagnostic.enable(false)
  else
    vim.diagnostic.enable(true)
  end
end, { desc = "toggle linters" })

vim.api.nvim_create_user_command("LintInfo", function()
  local filetype = vim.bo.filetype
  local linters = require("lint").linters_by_ft[filetype]
  if linters then
    print("Linters for " .. filetype .. ": " .. table.concat(linters, ", "))
  else
    print("No linters configured for filetype: " .. filetype)
  end
end, {})
