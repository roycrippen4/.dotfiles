local M = {}

local cursorline = '#252931'
local sep_color = '#454951'
local black = { 'black', 0 }
local darkest_black = { 'black', -0.9 }
local d_yellow = { 'yellow', -20 }
local d_red = { 'red', -10 }
local green = { 'green', -10 }
local l_blue = '#00C5FF'
local orange = { 'orange', -10 }
local pink = { 'pink', -10 }

-- stylua: ignore
M.add = {
  RainbowDelimiterRed    = { fg = 'red' },
  RainbowDelimiterYellow = { fg = 'yellow' },
  RainbowDelimiterBlue   = { fg = 'blue' },
  RainbowDelimiterOrange = { fg = 'orange' },
  RainbowDelimiterGreen  = { fg = 'green' },
  RainbowDelimiterViolet = { fg = 'purple' },
  RainbowDelimiterCyan   = { fg = 'cyan' },

  NvimTreeBookmark    = { fg = { "red", -10 } },
  NvimTreeBookmarkHL  = { fg = { "red", -10 } },
  NvimTreeOpenedFile  = { fg = { "yellow", -10 } },
  NvimTreeTitle       = { fg = { "yellow", -10 }, bg = "darker_black", sp = sep_color, --[[ underline = true ]] },
  NvimTreeTitleSepOn  = { fg = sep_color,         bg = "black",        sp = sep_color, --[[ underline = false ]] },
  NvimTreeTitleSepOff = { fg = sep_color,         bg = "darker_black", sp = sep_color, --[[ underline = true, ]]  },

  WinBar              = { fg = "red", bg = black },
  WinBarNC            = { fg = black, bg = black },

  TbLineMarkedBufOn    = {fg = { 'blue', -20}, bg = 'black' },
  TbLineMarkedBufOff   = {fg = { 'grey',  0 }, bg = 'darker_black', sp = sep_color --[[ underline = true ]]},
  TbLineUnmarkedBufOn  = {fg = { 'blue', -20}, bg = 'black' },
  TbLineUnmarkedBufOff = {fg = { 'grey',  0 }, bg = 'darker_black', sp = sep_color--[[ , underline = true ]]},

  -- Statusline special buffers
  St_toggleterm          = { fg = green,           bg = darkest_black, italic = true },
  St_toggleterm_icon     = { fg = 'green',         bg = darkest_black },
  St_nvimtree            = { fg = l_blue,          bg = darkest_black, italic = true },
  St_nvimtree_icon       = { fg = l_blue,          bg = darkest_black },
  St_lazygit             = { fg = green,           bg = darkest_black, italic = true },
  St_lazygit_icon        = { fg = green,           bg = darkest_black },
  St_trouble             = { fg = d_red,           bg = darkest_black, italic = true, bold = true },
  St_trouble_icon        = { fg = d_red,           bg = darkest_black },

  St_lazygit_sep         = { fg = green,           bg = darkest_black },
  St_toggleterm_sep      = { fg = green,           bg = darkest_black },
  St_nvimtree_sep        = { fg = l_blue,          bg = darkest_black },
  St_trouble_sep         = { fg = d_red,           bg = darkest_black },

  St_gitAdd              = { fg = 'green',   bg = darkest_black },
  St_gitRemove           = { fg = 'red',     bg = darkest_black },
  St_gitChange           = { fg = 'yellow',  bg = darkest_black },
  St_Macro               = { fg = d_red,     bg = darkest_black },
  St_MacroSep            = { fg = d_red,     bg = darkest_black },
  St_MacroA              = { fg = d_red,     bg = darkest_black },
  St_MacroSepA           = { fg = d_red,     bg = darkest_black },
  St_MacroB              = { fg = 'yellow',  bg = darkest_black },
  St_MacroSepB           = { fg = 'yellow',  bg = darkest_black },
  St_Host                = { fg = { 'grey', -5 }, bg = darkest_black, italic = true },
  St_HostSep             = { fg = { 'grey', -5 }, bg = darkest_black, italic = true },
  St_Time                = { fg = '#cc5e00', bg = darkest_black },
  St_unix                = { fg = '#00EE6e', bg = darkest_black },

  NoiceVirtualTextOn     = { fg = '#53bf00', bg = cursorline, italic = true },

  CmdlineEx        = { fg =  {'red', -15}, bg = darkest_black },
  CmdlineLua       = { fg =  green,        bg = darkest_black },
  CmdlineVisualSub = { fg =  pink,         bg = darkest_black },
  CmdlineSub       = { fg =  l_blue,       bg = darkest_black },
  CmdlineSearch    = { fg = '#cc5e00',     bg = darkest_black },
  CmdlineHelp      = { fg = '#53bf00',     bg = darkest_black },

}

-- stylua: ignore
M.override = {
  -- Tabufline
  TbLineBufOn          = { fg = d_yellow },
  TbLineBufOff         = { fg = "grey", bg = "darker_black", sp = sep_color, --[[ underline = true ]] },
  TbLineBufOffModified = { bg = "darker_black", sp = sep_color, --[[ underline = true ]] },
  TbLineBufOffClose    = { bg = "darker_black", sp = sep_color, --[[ underline = true ]] },
  TblineFill           = { bg = "darker_black", sp = sep_color, --[[ underline = true ]] },

  -- Statusline modes
  St_NormalMode       = { fg = l_blue,         bg = darkest_black },
  St_NormalModeSep    = { fg = l_blue,         bg = darkest_black },
  St_InsertMode       = { fg = d_yellow,       bg = darkest_black },
  St_InsertModeSep    = { fg = d_yellow,       bg = darkest_black },
  St_TerminalMode     = { fg = green,          bg = darkest_black },
  St_TerminalModeSep  = { fg = green,          bg = darkest_black },
  St_NTerminalMode    = { fg = green,          bg = darkest_black },
  St_NTerminalModeSep = { fg = green,          bg = darkest_black },
  St_CommandMode      = { fg = d_red,          bg = darkest_black },
  St_CommandModeSep   = { fg = d_red,          bg = darkest_black },
  St_ReplaceMode      = { fg = orange,         bg = darkest_black },
  St_ReplaceModeSep   = { fg = orange,         bg = darkest_black },
  St_VisualMode       = { fg = pink,           bg = darkest_black },
  St_VisualModeSep    = { fg = pink,           bg = darkest_black },
  St_SelectMode       = { fg = pink,           bg = darkest_black },
  St_SelectModeSep    = { fg = pink,           bg = darkest_black },
  St_ConfirmMode      = { fg = d_red,          bg = darkest_black },
  St_ConfirmModeSep   = { fg = d_red ,         bg = darkest_black },
  St_EmptySpace       = { fg = '#00C5FF',      bg = darkest_black },
  St_EmptySpace2      = { fg = darkest_black, bg = darkest_black },

  St_file_info        = { fg = { 'white', -10 },     bg = darkest_black },
  St_gitIcons         = { fg = { 'white', -10 },     bg = darkest_black, italic = true, bold = false },
  St_file_sep         = { fg = { 'grey',   10 },     bg = darkest_black, bold = true },

  St_lspError   = { bg = darkest_black },
  St_lspWarning = { bg = darkest_black },
  St_LspHints   = { bg = darkest_black },
  St_LspInfo    = { bg = darkest_black },
  St_LspStatus  = { fg = '#53bf00', bg = darkest_black },
  St_pos_text   = { fg = '#d6a000', bg = darkest_black, bold = false },
  St_cwd_sep    = { fg = {'red', -15}, bg = darkest_black},
  St_pos_sep    = { fg = '#d6a000', bg = darkest_black, bold = false },

  -- Misc
  FloatBorder  = { fg = { 'red', -15 }, bg = 'black' },
  CmpPmenu    = { bg = { 'black', -5 } },
  -- CmpDocBorder = { fg = { 'red', -30 }, bg = 'black' },
  Comment = { italic = true },
  WinSeparator = { fg = 'yellow', bg = 'black' },
  NvimTreeWinSeparator = { fg = black, bg = 'black' },
}

return M
