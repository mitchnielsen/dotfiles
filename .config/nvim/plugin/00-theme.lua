vim.pack.add({
  -- Available for :colorscheme / picker
  "https://github.com/navarasu/onedark.nvim",
  "https://github.com/Mofiqul/vscode.nvim",
  "https://github.com/EdenEast/nightfox.nvim",
  "https://github.com/shaunsingh/nord.nvim",
  "https://github.com/rmehri01/onenord.nvim",
  "https://github.com/aktersnurra/no-clown-fiesta.nvim",
  "https://github.com/oskarnurm/koda.nvim",
}, { confirm = false })

-- Follow macOS appearance: pick clarity-light or clarity-dark.
local function detect_appearance()
  if vim.fn.has("mac") == 0 then
    return "light"
  end
  local out = vim.fn.system({ "defaults", "read", "-g", "AppleInterfaceStyle" })
  return (vim.v.shell_error == 0 and out:match("Dark")) and "dark" or "light"
end

local function apply_clarity()
  vim.cmd("colorscheme clarity-" .. detect_appearance())
end

apply_clarity()

-- Re-detect on focus (works when nvim is foregrounded after the flip).
vim.api.nvim_create_autocmd("FocusGained", {
  group = vim.api.nvim_create_augroup("ClarityAppearance", { clear = true }),
  callback = apply_clarity,
})

-- Re-detect on SIGUSR1 so `clarity-mode` can push the theme to running
-- instances (including those buried in tmux panes that won't see FocusGained).
local sigusr1 = vim.uv.new_signal()
if sigusr1 then
  sigusr1:start("sigusr1", function()
    vim.schedule(apply_clarity)
  end)
end
