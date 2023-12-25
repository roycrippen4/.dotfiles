local M = {}

local sep_color = '#454951'
local bg_link = { 'grey', -5 }
local black = { 'black', 0 }
local d_yellow = { 'yellow', -20 }
local d_red = { 'red', -10 }
local green = { 'green', -10 }
local l_blue = '#00C5FF'
local orange = { 'orange', -10 }
local pink = { 'pink', -15 }
-- local white = 'white'

local st_sb_sep_bg = 'black'

-- stylua: ignore
M.add = {
  SpinnerRed         = { fg =  '#FF2400' },
  SpinnerNeonCarrot  = { fg =  '#FF7500' },
  SpinnerOrange      = { fg =  '#FFA500' },
  SpinnerGold        = { fg =  '#FFBF00' },
  SpinnerYellow      = { fg =  '#FFFF00' },
  SpinnerLimeGreen   = { fg =  '#BFFF00' },
  SpinnerBrightGreen = { fg =  '#6FFF00' },
  SpinnerSpringGreen = { fg =  '#00FF7F' },
  SpinnerCyan        = { fg =  '#00FFFF' },
  SpinnerAzure       = { fg =  '#007FFF' },
  SpinnerBlue        = { fg =  '#0000FF' },
  SpinnerViolet      = { fg =  '#7F00FF' },
  SpinnerVioleter    = { fg =  '#FF00FF' },
  SpinnerHotPink     = { fg =  '#FF2477' },


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
  St_toggleterm          = { fg = green,           bg = "black", italic = true },
  St_toggleterm_icon     = { fg = 'green',         bg = "black" },
  St_harpoon             = { fg = { 'blue', -20 }, bg = "black", italic = true, bold = true },
  St_harpoon_icon        = { fg = { 'blue', -20 }, bg = "black" },
  St_nvimtree            = { fg = l_blue,          bg = black, italic = true },
  St_nvimtree_icon       = { fg = l_blue,          bg = "black" },
  St_lazygit             = { fg = green,           bg = black, italic = true },
  St_lazygit_icon        = { fg = green,           bg = "black" },
  St_trouble             = { fg = d_red,           bg = black, italic = true, bold = true },
  St_trouble_icon        = { fg = d_red,           bg = "black" },

  St_lazygit_sep         = { fg = green,           bg = st_sb_sep_bg },
  St_toggleterm_sep      = { fg = green,           bg = st_sb_sep_bg },
  St_nvimtree_sep        = { fg = l_blue,          bg = st_sb_sep_bg },
  St_harpoon_sep         = { fg = { 'blue', -20 }, bg = st_sb_sep_bg },
  St_trouble_sep         = { fg = d_red,           bg = st_sb_sep_bg },

  St_gitAdd              = { fg = 'green',  bg = 'black' },
  St_gitRemove           = { fg = 'red',    bg = 'black' },
  St_gitChange           = { fg = 'yellow', bg = 'black' },
  St_Macro              = { fg = d_red,     bg = 'black' },
  St_MacroSep           = { fg = d_red,     bg = 'black' },

  St_MacroA              = { fg = d_red,    bg = 'black' },
  St_MacroSepA           = { fg = d_red,    bg = 'black' },
  St_MacroB              = { fg = 'yellow', bg = 'black' },
  St_MacroSepB           = { fg = 'yellow', bg = 'black' },

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
  St_NormalModeSep   = { fg = black,    bg = l_blue },
  St_InsertMode      = { fg = d_yellow, bg = black },
  St_InsertModeSep   = { fg = black,    bg = d_yellow },
  St_TerminalMode    = { fg = green,    bg = black, bold = true },
  St_TerminalModeSep = { fg = black,    bg = green },
  St_NTerminalMode    = { fg = green,    bg = black, bold = true },
  St_NTerminalModeSep = { fg = black,    bg = green },
  St_CommandMode     = { fg = d_red,    bg = black, bold = true },
  St_CommandModeSep  = { fg = black,    bg = d_red },
  St_ReplaceMode     = { fg = orange,   bg = black, bold = true },
  St_ReplaceModeSep  = { fg = black,    bg = orange },
  St_VisualMode      = { fg = pink,     bg = black, bold = true },
  St_VisualModeSep   = { fg = black,    bg = pink },
  St_SelectMode      = { fg = pink,     bg = black, bold = true },
  St_SelectModeSep   = { fg = black,    bg = pink },
  St_ConfirmMode     = { fg = d_red,    bg = black, bold = true },
  St_ConfirmModeSep  = { fg = black,    bg = d_red },
  St_EmptySpace      = { fg = l_blue, bg = "black" },
  St_EmptySpace2      = { fg = bg_link, bg = "black" },

  St_file_info  = { fg = { 'white', -10 },    bg = "black", bold = true },
  St_file_sep   = { fg = 'black',    bg = bg_link, bold = true },
  St_gitIcons   = { fg = { 'white', -10 }, bg = "black" },
  St_lspError   = { bg = 'black' },
  St_lspWarning = { bg = 'black' },
  St_LspHints   = { bg = 'black' },
  St_LspInfo    = { bg = 'black' },
  St_LspStatus  = { bg = 'black' },
  St_pos_text   = { bg = 'black' },
  St_cwd_sep    = { bg = 'black'},
  St_pos_sep    = { bg = 'black'},

  -- Misc
  FloatBorder = { bg = "black" },
  CmpDocBorder = { fg = { "blue", -25 }, bg = "black" },
  Comment = { italic = true },
  WinSeparator = { fg = "yellow", bg = "black" },
  NvimTreeWinSeparator = { fg = black, bg = "black" },
}

return M
