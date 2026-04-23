-- clarity.lua — minimal light colorscheme for legibility
-- Designed to match a Ghostty terminal with #fafafa background.
-- Most code is the foreground color. Color is used sparingly:
--   green  (#3a7d10) — strings, additions, success
--   red    (#a12a2a) — errors, deletions, important warnings
--   blue   (#0969da) — functions, methods, links, references
--   yellow (#7a6520) — parameters, warnings
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
  subtle_bg = "#f0f0f0",
  float_bg = "#f4f4f4",
  border = "#d0d7de",
  green = "#1a8a0e",
  red = "#a12a2a",
  blue = "#0969da",
  yellow = "#7a6520",
  visual = "#d1e5fa",
  cursor_line = "#f0f2f4",
  search = "#fbe5a0",
  match = "#fef3c7",
}

local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- ┌──────────────────────────────────┐
-- │  Editor chrome                   │
-- └──────────────────────────────────┘
hi("Normal", { fg = c.fg, bg = c.bg })
hi("NormalFloat", { fg = c.fg, bg = c.float_bg })
hi("FloatBorder", { fg = c.border, bg = c.float_bg })
hi("FloatTitle", { fg = c.fg, bg = c.float_bg, bold = true })
hi("Cursor", { fg = c.bg, bg = c.fg })
hi("CursorLine", { bg = c.cursor_line })
hi("CursorLineNr", { fg = c.fg, bold = true })
hi("LineNr", { fg = c.faint })
hi("SignColumn", { bg = c.none })
hi("FoldColumn", { fg = c.faint, bg = c.none })
hi("Folded", { fg = c.dim, bg = c.subtle_bg })
hi("VertSplit", { fg = c.dim, bg = c.none })
hi("WinSeparator", { fg = c.dim, bg = c.none })
hi("ColorColumn", { bg = c.subtle_bg })
hi("Visual", { bg = c.visual })
hi("VisualNOS", { bg = c.visual })
hi("Search", { bg = c.search })
hi("IncSearch", { bg = c.search, bold = true })
hi("CurSearch", { fg = "#ffffff", bg = c.blue, bold = true })
hi("MatchParen", { bg = c.match, bold = true })
hi("NonText", { fg = c.faint })
hi("SpecialKey", { fg = c.faint })
hi("Whitespace", { fg = c.faint })
hi("EndOfBuffer", { fg = c.faint })
hi("Directory", { fg = c.blue })
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
hi("PmenuSel", { bg = c.visual })
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
hi("Comment", { fg = c.dim, italic = true })

hi("Constant", { fg = c.fg })
hi("String", { fg = c.green })
hi("Character", { fg = c.green })
hi("Number", { fg = c.fg })
hi("Boolean", { fg = c.fg, bold = true })
hi("Float", { fg = c.fg })

hi("Identifier", { fg = c.fg })
hi("Function", { fg = c.blue })

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
hi("Tag", { fg = c.blue })
hi("Delimiter", { fg = c.fg })
hi("SpecialComment", { fg = c.dim, bold = true })
hi("Debug", { fg = c.red })

hi("Underlined", { fg = c.blue, underline = true })
hi("Error", { fg = c.red, bold = true })
hi("Todo", { fg = c.blue, bold = true })

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

hi("@function", { fg = c.blue })
hi("@function.builtin", { fg = c.blue })
hi("@function.call", { fg = c.blue })
hi("@function.macro", { fg = c.blue })
hi("@method", { fg = c.blue })
hi("@method.call", { fg = c.blue })
hi("@constructor", { fg = c.blue })

hi("@keyword", { fg = c.fg, bold = true })
hi("@keyword.function", { fg = c.fg, bold = true })
hi("@keyword.return", { fg = c.fg, bold = true })
hi("@keyword.operator", { fg = c.fg, bold = true })
hi("@conditional", { fg = c.fg, bold = true })
hi("@repeat", { fg = c.fg, bold = true })
hi("@exception", { fg = c.red, bold = true })
hi("@include", { fg = c.fg, bold = true })

hi("@variable", { fg = c.fg })
hi("@variable.builtin", { fg = c.yellow, italic = true })
hi("@parameter", { fg = c.yellow })
hi("@field", { fg = c.fg })
hi("@property", { fg = c.fg })

hi("@type", { fg = c.fg })
hi("@type.builtin", { fg = c.fg })
hi("@type.definition", { fg = c.fg })
hi("@type.qualifier", { fg = c.fg, bold = true })

hi("@constant", { fg = c.fg })
hi("@constant.builtin", { fg = c.fg, bold = true })
hi("@constant.macro", { fg = c.fg })

hi("@namespace", { fg = c.fg })
hi("@symbol", { fg = c.fg })

hi("@text", { fg = c.fg })
hi("@text.strong", { bold = true })
hi("@text.emphasis", { italic = true })
hi("@text.underline", { underline = true })
hi("@text.strike", { strikethrough = true })
hi("@text.title", { fg = c.fg, bold = true })
hi("@text.literal", { fg = c.green })
hi("@text.uri", { fg = c.blue, underline = true })
hi("@text.reference", { fg = c.blue })
hi("@text.todo", { fg = c.blue, bold = true })
hi("@text.note", { fg = c.blue })
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
hi("@markup.link", { fg = c.blue })
hi("@markup.link.url", { fg = c.blue, underline = true })
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
hi("@lsp.type.parameter", { fg = c.yellow })
hi("@lsp.type.variable", { fg = c.fg })
hi("@lsp.type.property", { fg = c.fg })
hi("@lsp.type.function", { fg = c.blue })
hi("@lsp.type.method", { fg = c.blue })
hi("@lsp.type.macro", { fg = c.fg })
hi("@lsp.type.decorator", { fg = c.fg })
hi("@lsp.type.comment", { link = "Comment" })
hi("@lsp.mod.deprecated", { strikethrough = true })

-- ┌──────────────────────────────────┐
-- │  Diagnostics                     │
-- └──────────────────────────────────┘
hi("DiagnosticError", { fg = c.red })
hi("DiagnosticWarn", { fg = c.yellow })
hi("DiagnosticInfo", { fg = c.blue })
hi("DiagnosticHint", { fg = c.dim })
hi("DiagnosticOk", { fg = c.green })
hi("DiagnosticUnderlineError", { sp = c.red, undercurl = true })
hi("DiagnosticUnderlineWarn", { sp = c.yellow, undercurl = true })
hi("DiagnosticUnderlineInfo", { sp = c.blue, undercurl = true })
hi("DiagnosticUnderlineHint", { sp = c.dim, undercurl = true })
hi("DiagnosticVirtualTextError", { fg = c.red, bg = "#fdf0f0" })
hi("DiagnosticVirtualTextWarn", { fg = c.yellow, bg = "#fdf6e8" })
hi("DiagnosticVirtualTextInfo", { fg = c.blue, bg = "#eef4fc" })
hi("DiagnosticVirtualTextHint", { fg = c.dim, bg = c.subtle_bg })

-- ┌──────────────────────────────────┐
-- │  Diff                            │
-- └──────────────────────────────────┘
hi("DiffAdd", { bg = "#dafbe1" })
hi("DiffChange", { bg = "#eef4fc" })
hi("DiffDelete", { bg = "#fbe5e1" })
hi("DiffText", { bg = "#d1e5fa" })
hi("Added", { fg = c.green })
hi("Changed", { fg = c.blue })
hi("Removed", { fg = c.red })

-- mini.diff signs
hi("MiniDiffSignAdd", { fg = c.green })
hi("MiniDiffSignChange", { fg = c.blue })
hi("MiniDiffSignDelete", { fg = c.red })

-- ┌──────────────────────────────────┐
-- │  Git signs / Fugitive            │
-- └──────────────────────────────────┘
hi("GitSignsAdd", { fg = c.green })
hi("GitSignsChange", { fg = c.blue })
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
hi("MiniStarterItemPrefix", { fg = c.blue })
hi("MiniStarterQuery", { fg = c.blue, bold = true })
hi("MiniStarterCurrent", { bg = c.cursor_line })
hi("MiniStarterSection", { fg = c.dim, bold = true })

-- ┌──────────────────────────────────┐
-- │  mini.statusline                 │
-- └──────────────────────────────────┘
hi("MiniStatuslineModeNormal", { fg = c.fg, bold = true })
hi("MiniStatuslineModeInsert", { fg = c.green, bold = true })
hi("MiniStatuslineModeVisual", { fg = c.blue, bold = true })
hi("MiniStatuslineModeReplace", { fg = c.red, bold = true })
hi("MiniStatuslineModeCommand", { fg = c.yellow, bold = true })
hi("MiniStatuslineFilename", { fg = c.fg })
hi("MiniStatuslineFileinfo", { fg = c.dim })
hi("MiniStatuslineInactive", { fg = c.dim })

-- ┌──────────────────────────────────┐
-- │  mini.files                      │
-- └──────────────────────────────────┘
hi("MiniFilesNormal", { fg = c.fg, bg = c.float_bg })
hi("MiniFilesBorder", { fg = c.border, bg = c.float_bg })
hi("MiniFilesTitle", { fg = c.fg, bg = c.float_bg, bold = true })
hi("MiniFilesCursorLine", { bg = c.visual })
hi("MiniFilesDirectory", { fg = c.blue })
hi("MiniFilesFile", { fg = c.fg })

-- ┌──────────────────────────────────┐
-- │  mini.clue                       │
-- └──────────────────────────────────┘
hi("MiniClueBorder", { fg = c.border, bg = c.float_bg })
hi("MiniClueTitle", { fg = c.fg, bg = c.float_bg, bold = true })
hi("MiniClueDescGroup", { fg = c.blue })
hi("MiniClueDescSingle", { fg = c.fg })
hi("MiniClueNextKey", { fg = c.blue, bold = true })

-- ┌──────────────────────────────────┐
-- │  mini.trailspace                 │
-- └──────────────────────────────────┘
hi("MiniTrailspace", { bg = "#fbe5e1" })

-- ┌──────────────────────────────────┐
-- │  FzfLua                          │
-- └──────────────────────────────────┘
hi("FzfLuaNormal", { fg = c.fg, bg = c.float_bg })
hi("FzfLuaBorder", { fg = c.border, bg = c.float_bg })
hi("FzfLuaTitle", { fg = c.fg, bg = c.float_bg, bold = true })
hi("FzfLuaPreviewNormal", { fg = c.fg, bg = c.float_bg })
hi("FzfLuaPreviewBorder", { fg = c.border, bg = c.float_bg })
hi("FzfLuaPreviewTitle", { fg = c.fg, bg = c.float_bg, bold = true })
hi("FzfLuaCursorLine", { bg = c.visual })
hi("FzfLuaSearch", { fg = c.blue })
hi("FzfLuaHeaderBind", { fg = c.blue })
hi("FzfLuaHeaderText", { fg = c.dim })
hi("FzfLuaFzfNormal", { fg = c.fg, bg = c.float_bg })
hi("FzfLuaFzfGutter", { bg = c.float_bg })
hi("FzfLuaFzfHeader", { fg = c.dim })
hi("FzfLuaFzfInfo", { fg = c.dim })
hi("FzfLuaFzfPointer", { fg = c.blue })
hi("FzfLuaFzfPrompt", { fg = c.blue })
hi("FzfLuaFzfMatch", { fg = c.blue })

-- ┌──────────────────────────────────┐
-- │  Neogit                          │
-- └──────────────────────────────────┘
hi("NeogitDiffAdd", { fg = c.green, bg = "#dafbe1" })
hi("NeogitDiffDelete", { fg = c.red, bg = "#fbe5e1" })
hi("NeogitHunkHeader", { fg = c.fg, bg = c.subtle_bg, bold = true })
hi("NeogitBranch", { fg = c.blue, bold = true })
hi("NeogitRemote", { fg = c.green })

-- ┌──────────────────────────────────┐
-- │  Blink.cmp                       │
-- └──────────────────────────────────┘
hi("BlinkCmpMenu", { fg = c.fg, bg = c.float_bg })
hi("BlinkCmpMenuBorder", { fg = c.border, bg = c.float_bg })
hi("BlinkCmpMenuSelection", { bg = c.visual })
hi("BlinkCmpLabel", { fg = c.fg })
hi("BlinkCmpLabelMatch", { fg = c.blue, bold = true })
hi("BlinkCmpKind", { fg = c.dim })
hi("BlinkCmpDoc", { fg = c.fg, bg = c.float_bg })
hi("BlinkCmpDocBorder", { fg = c.border, bg = c.float_bg })
