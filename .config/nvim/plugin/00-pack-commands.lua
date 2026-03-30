-- User commands for vim.pack management

-- :PackUpdate [name ...] — update all or specific plugins
vim.api.nvim_create_user_command("PackUpdate", function(opts)
  local names = #opts.fargs > 0 and opts.fargs or nil
  vim.pack.update(names)
end, {
  nargs = "*",
  complete = function()
    return vim.iter(vim.pack.get())
      :map(function(p) return p.spec.name end)
      :totable()
  end,
  desc = "Update plugins (all or by name)",
})

-- :PackDelete — select plugin(s) via fzf-lua, then delete
vim.api.nvim_create_user_command("PackDelete", function()
  local plugins = vim.iter(vim.pack.get())
    :map(function(p) return p.spec.name end)
    :totable()
  table.sort(plugins)

  require("fzf-lua").fzf_exec(plugins, {
    prompt = "Delete plugin> ",
    actions = {
      ["default"] = function(selected)
        if not selected or #selected == 0 then return end
        local confirm = vim.fn.confirm(
          "Delete " .. table.concat(selected, ", ") .. "?",
          "&Yes\n&No", 2
        )
        if confirm == 1 then
          vim.pack.del(selected, { force = true })
          vim.notify("Deleted: " .. table.concat(selected, ", "))
        end
      end,
    },
    winopts = {
      height = 0.4,
      width = 0.5,
    },
    fzf_opts = {
      ["--multi"] = true,
    },
  })
end, { desc = "Delete plugins (fzf picker)" })

-- :PackList — list all installed plugins
vim.api.nvim_create_user_command("PackList", function()
  local plugins = vim.pack.get()
  table.sort(plugins, function(a, b) return a.spec.name < b.spec.name end)
  for _, p in ipairs(plugins) do
    local status = p.active and "●" or "○"
    print(string.format("  %s %s (%s)", status, p.spec.name, p.rev:sub(1, 7)))
  end
  print(string.format("\n  %d plugins installed", #plugins))
end, { desc = "List installed plugins" })

-- :PackClean — delete plugins on disk that aren't in any vim.pack.add() call
vim.api.nvim_create_user_command("PackClean", function()
  local inactive = vim.iter(vim.pack.get())
    :filter(function(p) return not p.active end)
    :map(function(p) return p.spec.name end)
    :totable()

  if #inactive == 0 then
    vim.notify("Nothing to clean")
    return
  end

  local confirm = vim.fn.confirm(
    "Delete inactive plugins?\n  " .. table.concat(inactive, "\n  "),
    "&Yes\n&No", 2
  )
  if confirm == 1 then
    vim.pack.del(inactive, { force = true })
    vim.notify("Cleaned: " .. table.concat(inactive, ", "))
  end
end, { desc = "Remove plugins not in current config" })

