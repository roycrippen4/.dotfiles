local M = {}

local sep_color = '#454951'
local bg_link = { 'grey', -5 }
local black = { 'black', 0 }
local d_yellow = { 'yellow', -20 }
local d_red = { 'red', -10 }
local green = { 'green', -10 }
local l_blue = '#00C5FF'
local orange = { 'orange', -10 }
local pink = { 'pink', -10 }
-- local white = 'white'

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
  NvimTreeTitle       = { fg = { "yellow", -10 }, bg = "darker_black", sp = sep_color, underline = true },
  NvimTreeTitleSepOn  = { fg = sep_color,         bg = "black",        sp = sep_color, underline = false },
  NvimTreeTitleSepOff = { fg = sep_color,         bg = "darker_black", sp = sep_color, underline = true,  },

  WinBar              = { fg = "red", bg = black },
  WinBarNC            = { bg = black },

  TbLineMarkedBufOn    = {fg = { 'blue', -20}, bg = 'black' },
  TbLineMarkedBufOff   = {fg = { 'grey',  0 }, bg = 'darker_black', sp = sep_color, underline = true},
  TbLineUnmarkedBufOn  = {fg = { 'blue', -20}, bg = 'black' },
  TbLineUnmarkedBufOff = {fg = { 'grey',  0 }, bg = 'darker_black', sp = sep_color, underline = true},

  -- Statusline special buffers
  St_toggleterm          = { fg = green,            bg = "black", italic = true },
  St_toggleterm_icon     = { fg = '',               bg = "black" },
  St_toggleterm_sep      = { fg = 'black',          bg = "grey" },
  St_harpoon             = { fg = 'blue',           bg = "black", italic = true },
  St_harpoon_icon        = { fg = { 'white', -10 }, bg = "black" },
  St_harpoon_sep         = { fg = 'black',          bg = "grey" },
  St_nvimtree            = { fg = l_blue,           bg = black, italic = true },
  St_nvimtree_icon       = { fg = { 'white', -10 }, bg = "black" },
  St_nvimtree_sep        = { fg = 'black',          bg = "grey" },
  St_lazygit            = { fg = green,           bg = black, italic = true },
  St_lazygit_icon       = { fg = { 'white', -10 }, bg = "black" },
  St_lazygit_sep        = { fg = 'black',          bg = "grey" },
}

-- stylua: ignore
M.override = {
  -- Tabufline
  TbLineBufOn          = { fg = d_yellow },
  TbLineBufOff         = { fg = "grey", bg = "darker_black", sp = sep_color, underline = true },
  TbLineBufOffModified = { bg = "darker_black", sp = sep_color, underline = true },
  TbLineBufOffClose    = { bg = "darker_black", sp = sep_color, underline = true },
  TblineFill           = { bg = "darker_black", sp = sep_color, underline = true },

  -- Statusline modes
  St_NormalMode      = { fg = l_blue,   bg = black },
  St_NormalModeSep   = { fg = black,    bg = bg_link },
  St_InsertMode      = { fg = d_yellow, bg = black },
  St_InsertModeSep   = { fg = black,    bg = bg_link },
  St_TerminalMode    = { fg = green,    bg = black, bold = true },
  St_TerminalModeSep = { fg = black,    bg = bg_link },
  St_NTerminalMode    = { fg = green,    bg = black, bold = true },
  St_NTerminalModeSep = { fg = black,    bg = bg_link },
  St_CommandMode     = { fg = d_red,    bg = black, bold = true },
  St_CommandModeSep  = { fg = black,    bg = bg_link },
  St_ReplaceMode     = { fg = orange,   bg = black, bold = true },
  St_ReplaceModeSep  = { fg = black,    bg = bg_link },
  St_VisualMode      = { fg = pink,     bg = black, bold = true },
  St_VisualModeSep   = { fg = black,    bg = bg_link },
  St_SelectMode      = { fg = pink,     bg = black, bold = true },
  St_SelectModeSep   = { fg = black,    bg = bg_link },
  St_ConfirmMode     = { fg = d_red,    bg = black, bold = true },
  St_ConfirmModeSep  = { fg = black,    bg = bg_link },

  St_EmptySpace      = { fg = bg_link, bg = "black" },
  St_EmptySpace2      = { bg = "green" },

  St_file_info = { fg = { 'white', -10 },    bg = "black", bold = true },
  St_file_sep = { fg = 'black',    bg = "yellow", bold = true },

  -- Misc
  FloatBorder = { bg = "black" },
  CmpDocBorder = { fg = { "blue", -25 }, bg = "black" },
  Comment = { italic = true },
  WinSeparator = { fg = "yellow", bg = "black" },
  NvimTreeWinSeparator = { fg = black, bg = "black" },
}

return M
