-- clarity.lua — minimal light colorscheme for legibility
-- Designed to match a Ghostty terminal with #efefed background.
-- Most code is the foreground color. Color is used sparingly:
--   green  (#1a8a0e) — strings, additions, success
--   red    (#a12a2a) — errors, deletions, important warnings
--   blue   (#0969da) — functions, methods, links
--   yellow (#8a5a00) — parameters, warnings
--   muted  (#6e7781) — comments, dim UI, deemphasized text

vim.cmd("highlight clear")
vim.g.colors_name = "clarity"
vim.o.background = "light"

local c = {
  none = "NONE",
  fg = "#24292f",
  bg = "NONE", -- transparent, Ghostty provides color
  dim = "#6e7781",
  faint = "#b0b8c1",
  subtle_bg = "#f6f8fa",
  float_bg = "#efefed",
  border = "#d0d7de",
  green = "#1a8a0e",
  red = "#a12a2a",
  blue = "#0969da",
  link = "#0969da",
  function_blue = "#0969da",
  info = "#57606a",
  yellow = "#8a5a00",
  param = "#6f5e2e",
  visual = "#d8dee4",
  cursor_line = "#eaeef2",
  search = "#fbe5a0",
  match = "#eaeef2",
}

local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- ┌──────────────────────────────────┐
-- │  Editor chrome                   │
-- └──────────────────────────────────┘
hi("Normal", { fg = c.fg, bg = c.bg })
hi("NormalFloat", { fg = c.fg, bg = c.float_bg })
hi("FloatBorder", { fg = c.fg, bg = c.float_bg })
hi("FloatTitle", { fg = c.fg, bg = c.float_bg, bold = true })
hi("Cursor", { fg = c.bg, bg = c.fg })
hi("CursorLine", { bg = c.cursor_line })
hi("CursorLineNr", { fg = c.fg, bold = true })
hi("LineNr", { fg = c.faint })
hi("SignColumn", { bg = c.none })
hi("FoldColumn", { fg = c.faint, bg = c.none })
hi("Folded", { fg = c.dim, bg = c.subtle_bg })
hi("VertSplit", { fg = c.border, bg = c.none })
hi("WinSeparator", { fg = c.border, bg = c.none })
hi("ColorColumn", { bg = c.subtle_bg })
hi("Visual", { bg = c.visual })
hi("VisualNOS", { bg = c.visual })
hi("Search", { bg = c.search })
hi("IncSearch", { bg = c.search, bold = true })
hi("CurSearch", { fg = "#ffffff", bg = c.link, bold = true })
hi("MatchParen", { bg = c.match, bold = true })
hi("NonText", { fg = c.faint })
hi("SpecialKey", { fg = c.faint })
hi("Whitespace", { fg = c.faint })
hi("EndOfBuffer", { fg = c.faint })
hi("Directory", { fg = c.link })
hi("Title", { fg = c.fg, bold = true })
hi("Question", { fg = c.green })
hi("MoreMsg", { fg = c.green })
hi("ErrorMsg", { fg = c.red, bold = true })
hi("WarningMsg", { fg = c.yellow, bold = true })
hi("WildMenu", { fg = c.fg, bg = c.visual })

-- ┌──────────────────────────────────┐
-- │  Statusline / Winbar             │
-- └──────────────────────────────────┘
hi("StatusLine", { fg = c.fg, bg = c.none })
hi("StatusLineNC", { fg = c.dim, bg = c.none })
hi("WinBar", { fg = c.fg, bg = c.none })
hi("WinBarNC", { fg = c.dim, bg = c.none })

-- ┌──────────────────────────────────┐
-- │  Pmenu (completion)              │
-- └──────────────────────────────────┘
hi("Pmenu", { fg = c.fg, bg = c.float_bg })
hi("PmenuSel", { bg = c.match })
hi("PmenuSbar", { bg = c.subtle_bg })
hi("PmenuThumb", { bg = c.border })

-- ┌──────────────────────────────────┐
-- │  Tabline                         │
-- └──────────────────────────────────┘
hi("TabLine", { fg = c.dim, bg = c.subtle_bg })
hi("TabLineSel", { fg = c.fg, bg = c.none, bold = true })
hi("TabLineFill", { bg = c.none })

-- ┌──────────────────────────────────┐
-- │  Syntax (minimal)                │
-- └──────────────────────────────────┘
-- The philosophy: almost everything is fg. Color marks semantics, not grammar.
hi("Comment", { fg = c.dim })

hi("Constant", { fg = c.fg })
hi("String", { fg = c.green })
hi("Character", { fg = c.green })
hi("Number", { fg = c.fg })
hi("Boolean", { fg = c.fg, bold = true })
hi("Float", { fg = c.fg })

hi("Identifier", { fg = c.fg })
hi("Function", { fg = c.function_blue })

hi("Statement", { fg = c.fg, bold = true })
hi("Conditional", { fg = c.fg, bold = true })
hi("Repeat", { fg = c.fg, bold = true })
hi("Label", { fg = c.fg, bold = true })
hi("Operator", { fg = c.fg })
hi("Keyword", { fg = c.fg, bold = true })
hi("Exception", { fg = c.red, bold = true })

hi("PreProc", { fg = c.dim })
hi("Include", { fg = c.fg, bold = true })
hi("Define", { fg = c.fg, bold = true })
hi("Macro", { fg = c.fg })
hi("PreCondit", { fg = c.fg })

hi("Type", { fg = c.fg })
hi("StorageClass", { fg = c.fg, bold = true })
hi("Structure", { fg = c.fg })
hi("Typedef", { fg = c.fg })

hi("Special", { fg = c.fg })
hi("SpecialChar", { fg = c.green })
hi("Tag", { fg = c.link })
hi("Delimiter", { fg = c.fg })
hi("SpecialComment", { fg = c.dim, bold = true })
hi("Debug", { fg = c.red })

hi("Underlined", { fg = c.link, underline = true })
hi("Error", { fg = c.red, bold = true })
hi("Todo", { fg = c.info, bold = true })

-- ┌──────────────────────────────────┐
-- │  Treesitter                      │
-- └──────────────────────────────────┘
-- Override only what diverges from the Vim defaults above.
hi("@comment", { link = "Comment" })
hi("@string", { link = "String" })
hi("@string.escape", { fg = c.dim })
hi("@string.regex", { fg = c.dim })
hi("@string.special", { fg = c.dim })
hi("@character", { link = "Character" })
hi("@number", { link = "Number" })
hi("@boolean", { link = "Boolean" })
hi("@float", { link = "Float" })

hi("@function", { fg = c.function_blue })
hi("@function.builtin", { fg = c.function_blue })
hi("@function.call", { fg = c.function_blue })
hi("@function.macro", { fg = c.function_blue })
hi("@method", { fg = c.function_blue })
hi("@method.call", { fg = c.function_blue })
hi("@constructor", { fg = c.function_blue })

hi("@keyword", { fg = c.fg, bold = true })
hi("@keyword.function", { fg = c.fg, bold = true })
hi("@keyword.return", { fg = c.fg, bold = true })
hi("@keyword.operator", { fg = c.fg, bold = true })
hi("@conditional", { fg = c.fg, bold = true })
hi("@repeat", { fg = c.fg, bold = true })
hi("@exception", { fg = c.red, bold = true })
hi("@include", { fg = c.fg, bold = true })

hi("@variable", { fg = c.fg })
hi("@variable.builtin", { fg = c.param, italic = true })
hi("@parameter", { fg = c.param })
hi("@variable.parameter", { fg = c.param })
hi("@field", { fg = c.fg })
hi("@property", { fg = c.fg })

hi("@type", { fg = c.fg })
hi("@type.builtin", { fg = c.fg, bold = true })
hi("@type.definition", { fg = c.fg })
hi("@type.qualifier", { fg = c.fg, bold = true })

hi("@constant", { fg = c.fg })
hi("@constant.builtin", { fg = c.fg, bold = true })
hi("@constant.macro", { fg = c.fg })

hi("@namespace", { fg = c.fg })
hi("@module", { fg = c.fg })
hi("@symbol", { fg = c.fg })

hi("@text", { fg = c.fg })
hi("@text.strong", { bold = true })
hi("@text.emphasis", { italic = true })
hi("@text.underline", { underline = true })
hi("@text.strike", { strikethrough = true })
hi("@text.title", { fg = c.fg, bold = true })
hi("@text.literal", { fg = c.green })
hi("@text.uri", { fg = c.link, underline = true })
hi("@text.reference", { fg = c.link })
hi("@text.todo", { fg = c.info, bold = true })
hi("@text.note", { fg = c.info })
hi("@text.warning", { fg = c.yellow })
hi("@text.danger", { fg = c.red })

hi("@tag", { fg = c.fg, bold = true })
hi("@tag.attribute", { fg = c.fg })
hi("@tag.delimiter", { fg = c.dim })

hi("@punctuation.delimiter", { fg = c.fg })
hi("@punctuation.bracket", { fg = c.fg })
hi("@punctuation.special", { fg = c.dim })

hi("@markup.heading", { fg = c.fg, bold = true })
hi("@markup.italic", { italic = true })
hi("@markup.strong", { bold = true })
hi("@markup.strikethrough", { strikethrough = true })
hi("@markup.link", { fg = c.link })
hi("@markup.link.url", { fg = c.link, underline = true })
hi("@markup.raw", { fg = c.green })
hi("@markup.list", { fg = c.fg })

-- ┌──────────────────────────────────┐
-- │  LSP semantic tokens             │
-- └──────────────────────────────────┘
hi("@lsp.type.namespace", { fg = c.fg })
hi("@lsp.type.type", { fg = c.fg })
hi("@lsp.type.class", { fg = c.fg })
hi("@lsp.type.enum", { fg = c.fg })
hi("@lsp.type.interface", { fg = c.fg })
hi("@lsp.type.struct", { fg = c.fg })
hi("@lsp.type.parameter", { fg = c.param })
hi("@lsp.type.variable", { fg = c.fg })
hi("@lsp.type.property", { fg = c.fg })
hi("@lsp.type.function", { fg = c.function_blue })
hi("@lsp.type.method", { fg = c.function_blue })
hi("@lsp.type.macro", { fg = c.fg })
hi("@lsp.type.decorator", { fg = c.fg })
hi("@lsp.type.comment", { link = "Comment" })
hi("@lsp.mod.deprecated", { strikethrough = true })

-- ┌──────────────────────────────────┐
-- │  Diagnostics                     │
-- └──────────────────────────────────┘
hi("DiagnosticError", { fg = c.red })
hi("DiagnosticWarn", { fg = c.yellow })
hi("DiagnosticInfo", { fg = c.info })
hi("DiagnosticHint", { fg = c.dim })
hi("DiagnosticOk", { fg = c.green })
hi("DiagnosticUnderlineError", { sp = c.red, undercurl = true })
hi("DiagnosticUnderlineWarn", { sp = c.yellow, undercurl = true })
hi("DiagnosticUnderlineInfo", { sp = c.info, undercurl = true })
hi("DiagnosticUnderlineHint", { sp = c.dim, undercurl = true })
hi("DiagnosticVirtualTextError", { fg = c.red, bg = "#fdf0f0" })
hi("DiagnosticVirtualTextWarn", { fg = c.yellow, bg = "#fff8e5" })
hi("DiagnosticVirtualTextInfo", { fg = c.info, bg = c.subtle_bg })
hi("DiagnosticVirtualTextHint", { fg = c.dim, bg = c.subtle_bg })

-- ┌──────────────────────────────────┐
-- │  Diff                            │
-- └──────────────────────────────────┘
hi("DiffAdd", { bg = "#dafbe1" })
hi("DiffChange", { bg = c.subtle_bg })
hi("DiffDelete", { bg = "#fbe5e1" })
hi("DiffText", { bg = c.visual })
hi("Added", { fg = c.green })
hi("Changed", { fg = c.info })
hi("Removed", { fg = c.red })

-- mini.diff signs
hi("MiniDiffSignAdd", { fg = c.green })
hi("MiniDiffSignChange", { fg = c.info })
hi("MiniDiffSignDelete", { fg = c.red })

-- ┌──────────────────────────────────┐
-- │  Git signs / Fugitive            │
-- └──────────────────────────────────┘
hi("GitSignsAdd", { fg = c.green })
hi("GitSignsChange", { fg = c.info })
hi("GitSignsDelete", { fg = c.red })

-- ┌──────────────────────────────────┐
-- │  Treesitter Context              │
-- └──────────────────────────────────┘
hi("TreesitterContext", { bg = c.subtle_bg })
hi("TreesitterContextLineNumber", { fg = c.dim, bg = c.subtle_bg })

-- ┌──────────────────────────────────┐
-- │  mini.cursorword                 │
-- └──────────────────────────────────┘
hi("MiniCursorword", { bg = c.match })
hi("MiniCursorwordCurrent", { bg = c.match })

-- ┌──────────────────────────────────┐
-- │  mini.starter                    │
-- └──────────────────────────────────┘
hi("MiniStarterHeader", { fg = c.dim })
hi("MiniStarterFooter", { fg = c.dim })
hi("MiniStarterItem", { fg = c.fg })
hi("MiniStarterItemBullet", { fg = c.faint })
hi("MiniStarterItemPrefix", { fg = c.link })
hi("MiniStarterQuery", { fg = c.link, bold = true })
hi("MiniStarterCurrent", { bg = c.cursor_line })
hi("MiniStarterSection", { fg = c.dim, bold = true })

-- ┌──────────────────────────────────┐
-- │  mini.statusline                 │
-- └──────────────────────────────────┘
hi("MiniStatuslineModeNormal", { fg = c.fg, bold = true })
hi("MiniStatuslineModeInsert", { fg = c.green, bold = true })
hi("MiniStatuslineModeVisual", { fg = c.link, bold = true })
hi("MiniStatuslineModeReplace", { fg = c.red, bold = true })
hi("MiniStatuslineModeCommand", { fg = c.yellow, bold = true })
hi("MiniStatuslineFilename", { fg = c.fg })
hi("MiniStatuslineFileinfo", { fg = c.dim })
hi("MiniStatuslineInactive", { fg = c.dim })

-- ┌──────────────────────────────────┐
-- │  mini.files                      │
-- └──────────────────────────────────┘
hi("MiniFilesNormal", { fg = c.fg, bg = c.float_bg })
hi("MiniFilesBorder", { fg = c.fg, bg = c.float_bg })
hi("MiniFilesTitle", { fg = c.fg, bg = c.float_bg, bold = true })
hi("MiniFilesCursorLine", { bg = c.match })
hi("MiniFilesDirectory", { fg = c.link })
hi("MiniFilesFile", { fg = c.fg })

-- ┌──────────────────────────────────┐
-- │  mini.clue                       │
-- └──────────────────────────────────┘
hi("MiniClueBorder", { fg = c.fg, bg = c.float_bg })
hi("MiniClueTitle", { fg = c.fg, bg = c.float_bg, bold = true })
hi("MiniClueDescGroup", { fg = c.link })
hi("MiniClueDescSingle", { fg = c.fg })
hi("MiniClueNextKey", { fg = c.link, bold = true })

-- ┌──────────────────────────────────┐
-- │  mini.trailspace                 │
-- └──────────────────────────────────┘
hi("MiniTrailspace", { bg = "#fbe5e1" })

-- ┌──────────────────────────────────┐
-- │  FzfLua                          │
-- └──────────────────────────────────┘
hi("FzfLuaNormal", { fg = c.fg, bg = c.float_bg })
hi("FzfLuaBorder", { fg = c.fg, bg = c.float_bg })
hi("FzfLuaTitle", { fg = c.fg, bg = c.float_bg, bold = true })
hi("FzfLuaPreviewNormal", { fg = c.fg, bg = c.float_bg })
hi("FzfLuaPreviewBorder", { fg = c.fg, bg = c.float_bg })
hi("FzfLuaPreviewTitle", { fg = c.fg, bg = c.float_bg, bold = true })
hi("FzfLuaCursorLine", { bg = c.match })
hi("FzfLuaSearch", { fg = c.link })
hi("FzfLuaHeaderBind", { fg = c.link })
hi("FzfLuaHeaderText", { fg = c.dim })
hi("FzfLuaFzfNormal", { fg = c.fg, bg = c.float_bg })
hi("FzfLuaFzfGutter", { bg = c.float_bg })
hi("FzfLuaFzfHeader", { fg = c.dim })
hi("FzfLuaFzfInfo", { fg = c.dim })
hi("FzfLuaFzfPointer", { fg = c.link })
hi("FzfLuaFzfPrompt", { fg = c.link })
hi("FzfLuaFzfMatch", { fg = c.link })

-- ┌──────────────────────────────────┐
-- │  Neogit                          │
-- └──────────────────────────────────┘
hi("NeogitDiffAdd", { fg = c.green, bg = "#dafbe1" })
hi("NeogitDiffDelete", { fg = c.red, bg = "#fbe5e1" })
hi("NeogitHunkHeader", { fg = c.fg, bg = c.subtle_bg, bold = true })
hi("NeogitBranch", { fg = c.link, bold = true })
hi("NeogitRemote", { fg = c.green })

-- ┌──────────────────────────────────┐
-- │  Blink.cmp                       │
-- └──────────────────────────────────┘
hi("BlinkCmpMenu", { fg = c.fg, bg = c.float_bg })
hi("BlinkCmpMenuBorder", { fg = c.fg, bg = c.float_bg })
hi("BlinkCmpMenuSelection", { bg = c.match })
hi("BlinkCmpLabel", { fg = c.fg })
hi("BlinkCmpLabelMatch", { fg = c.link, bold = true })
hi("BlinkCmpKind", { fg = c.dim })
hi("BlinkCmpDoc", { fg = c.fg, bg = c.float_bg })
hi("BlinkCmpDocBorder", { fg = c.fg, bg = c.float_bg })
