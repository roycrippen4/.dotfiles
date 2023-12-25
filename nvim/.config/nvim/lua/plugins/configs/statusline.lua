local utils = require('core.utils')

local timer = require('core.Clock'):new()

local function stbufnr()
  return vim.api.nvim_win_get_buf(vim.g.statusline_winid)
end

local sep_r = ''

local M = {}
--   󰈈       󱡠 󰴍       
local command_icon = '  '
local normal_icon = '  '
local insert_icon = '  '
local select_icon = '  '
local replace_icon = '  '
local confirm_icon = '❔ '

M.modes = {
  ['n'] = { 'NORMAL', 'St_NormalMode' },
  ['no'] = { 'NORMAL (no)', 'St_NormalMode' },
  ['nov'] = { 'NORMAL (nov)', 'St_NormalMode' },
  ['noV'] = { 'NORMAL (noV)', 'St_NormalMode' },
  ['noCTRL-V'] = { 'NORMAL', 'St_NormalMode' },
  ['niI'] = { 'NORMAL i', 'St_NormalMode' },
  ['niR'] = { 'NORMAL r', 'St_NormalMode' },
  ['niV'] = { 'NORMAL v', 'St_NormalMode' },
  ['nt'] = { 'NTERMINAL', 'St_NTerminalMode' },
  ['ntT'] = { 'NTERMINAL (ntT)', 'St_NTerminalMode' },

  ['v'] = { 'VISUAL', 'St_VisualMode' },
  ['vs'] = { 'V-CHAR (Ctrl O)', 'St_VisualMode' },
  ['V'] = { 'V-LINE', 'St_VisualMode' },
  ['Vs'] = { 'V-LINE', 'St_VisualMode' },
  [''] = { 'V-BLOCK', 'St_VisualMode' },

  ['i'] = { 'INSERT', 'St_InsertMode' },
  ['ic'] = { 'INSERT (completion)', 'St_InsertMode' },
  ['ix'] = { 'INSERT completion', 'St_InsertMode' },

  ['t'] = { 'TERMINAL', 'St_TerminalMode' },

  ['R'] = { 'REPLACE', 'St_ReplaceMode' },
  ['Rc'] = { 'REPLACE (Rc)', 'St_ReplaceMode' },
  ['Rx'] = { 'REPLACEa (Rx)', 'St_ReplaceMode' },
  ['Rv'] = { 'V-REPLACE', 'St_ReplaceMode' },
  ['Rvc'] = { 'V-REPLACE (Rvc)', 'St_ReplaceMode' },
  ['Rvx'] = { 'V-REPLACE (Rvx)', 'St_ReplaceMode' },

  ['s'] = { 'SELECT', 'St_SelectMode' },
  ['S'] = { 'S-LINE', 'St_SelectMode' },
  [''] = { 'S-BLOCK', 'St_SelectMode' },
  ['c'] = { 'COMMAND', 'St_CommandMode' },
  ['cv'] = { 'COMMAND', 'St_CommandMode' },
  ['ce'] = { 'COMMAND', 'St_CommandMode' },
  ['r'] = { 'PROMPT', 'St_ConfirmMode' },
  ['rm'] = { 'MORE', 'St_ConfirmMode' },
  ['r?'] = { 'CONFIRM', 'St_ConfirmMode' },
  ['x'] = { 'CONFIRM', 'St_ConfirmMode' },
  ['!'] = { 'SHELL', 'St_TerminalMode' },
}

M.mode_module = function()
  -- Normal
  M.modes['n'][3] = normal_icon
  M.modes['no'][3] = normal_icon
  M.modes['nov'][3] = normal_icon
  M.modes['noV'][3] = normal_icon
  M.modes['noCTRL-V'][3] = normal_icon
  M.modes['niI'][3] = normal_icon
  M.modes['niR'][3] = normal_icon
  M.modes['niV'][3] = normal_icon
  M.modes['nt'][3] = normal_icon
  M.modes['ntT'][3] = normal_icon

  -- Visual
  M.modes['v'][3] = '  '
  M.modes['vs'][3] = ' 󱡠 '
  M.modes['V'][3] = '  '
  M.modes['Vs'][3] = '  '
  M.modes[''][3] = ' 󰣟 '

  -- Insert
  M.modes['i'][3] = insert_icon
  M.modes['ic'] = insert_icon
  M.modes['ix'] = insert_icon

  -- Terminal   
  M.modes['t'][3] = '  '

  -- Replace
  M.modes['R'][3] = replace_icon
  M.modes['Rc'][3] = replace_icon
  M.modes['Rx'][3] = replace_icon
  M.modes['Rv'][3] = replace_icon
  M.modes['Rvc'][3] = replace_icon
  M.modes['Rvx'][3] = replace_icon

  -- Select
  M.modes['s'][3] = select_icon
  M.modes['S'][3] = select_icon
  M.modes[''][3] = select_icon

  -- Command
  M.modes['c'][3] = command_icon
  M.modes['cv'][3] = command_icon
  M.modes['ce'][3] = command_icon

  -- Confirm
  M.modes['r'][3] = confirm_icon
  M.modes['rm'][3] = confirm_icon
  M.modes['r?'][3] = confirm_icon
  M.modes['x'][3] = confirm_icon

  -- Shell
  M.modes['!'][3] = '  '

  local m = vim.api.nvim_get_mode().mode
  local current_mode = '%#' .. M.modes[m][2] .. '#' .. (M.modes[m][3] or '  ') .. M.modes[m][1] .. ' '
  local mode_sep1 = '%#' .. M.modes[m][2] .. 'Sep' .. '#' .. ''

  local recording_register = vim.fn.reg_recording()

  if recording_register == '' then
    return current_mode .. mode_sep1 .. '%#ST_EmptySpace#' .. ''
  else
    return ' %#ST_Macro#󰑊 MACRO ' .. recording_register .. '%#ST_MacroSep# '
  end
end

local spinner_colors = {
  SpinnerRed = '%#SpinnerRed#',
  SpinnerNeonCarrot = '%#SpinnerNeonCarrot#',
  SpinnerOrange = '%#SpinnerOrange#',
  SpinnerGold = '%#SpinnerGold#',
  SpinnerYellow = '%#SpinnerYellow#',
  SpinnerLimeGreen = '%#SpinnerLimeGreen#',
  SpinnerBrightGreen = '%#SpinnerBrightGreen#',
  SpinnerSpringGreen = '%#SpinnerSpringGreen#',
  SpinnerCyan = '%#SpinnerCyan#',
  SpinnerAzure = '%#SpinnerAzure#',
  SpinnerBlue = '%#SpinnerBlue#',
  SpinnerViolet = '%#SpinnerViolet#',
  SpinnerVioleter = '%#SpinnerVioleter#',
  SpinnerHotPink = '%#SpinnerHotPink#',
}

M.spinner = {
  rainbow_wave = function()
    local zero = spinner_colors.SpinnerRed .. '▁'
    local one = spinner_colors.SpinnerNeonCarrot .. '▂'
    local two = spinner_colors.SpinnerOrange .. '▃'
    local three = spinner_colors.SpinnerGold .. '▄'
    local four = spinner_colors.SpinnerYellow .. '▅'
    local five = spinner_colors.SpinnerLimeGreen .. '▆'
    local six = spinner_colors.SpinnerBrightGreen .. '▇'
    local seven = spinner_colors.SpinnerSpringGreen .. '█'
    local eight = spinner_colors.SpinnerCyan .. '▇'
    local nine = spinner_colors.SpinnerAzure .. '▆'
    local ten = spinner_colors.SpinnerBlue .. '▅'
    local eleven = spinner_colors.SpinnerViolet .. '▄'
    local twelve = spinner_colors.SpinnerVioleter .. '▃'
    local thirteen = spinner_colors.SpinnerHotPink .. '▂'

    local chars = {
      zero
        .. one
        .. two
        .. three
        .. four
        .. five
        .. six
        .. seven
        .. eight
        .. nine
        .. ten
        .. eleven
        .. twelve
        .. thirteen,
      one
        .. two
        .. three
        .. four
        .. five
        .. six
        .. seven
        .. eight
        .. nine
        .. ten
        .. eleven
        .. twelve
        .. thirteen
        .. zero,
      two
        .. three
        .. four
        .. five
        .. six
        .. seven
        .. eight
        .. nine
        .. ten
        .. eleven
        .. twelve
        .. thirteen
        .. zero
        .. one,
      three
        .. four
        .. five
        .. six
        .. seven
        .. eight
        .. nine
        .. ten
        .. eleven
        .. twelve
        .. thirteen
        .. zero
        .. one
        .. two,
      four
        .. five
        .. six
        .. seven
        .. eight
        .. nine
        .. ten
        .. eleven
        .. twelve
        .. thirteen
        .. zero
        .. one
        .. two
        .. three,
      five
        .. six
        .. seven
        .. eight
        .. nine
        .. ten
        .. eleven
        .. twelve
        .. thirteen
        .. zero
        .. one
        .. two
        .. three
        .. four,
      six
        .. seven
        .. eight
        .. nine
        .. ten
        .. eleven
        .. twelve
        .. thirteen
        .. zero
        .. one
        .. two
        .. three
        .. four
        .. five,
      seven
        .. eight
        .. nine
        .. ten
        .. eleven
        .. twelve
        .. thirteen
        .. zero
        .. one
        .. two
        .. three
        .. four
        .. five
        .. six,
      eight
        .. nine
        .. ten
        .. eleven
        .. twelve
        .. thirteen
        .. zero
        .. one
        .. two
        .. three
        .. four
        .. five
        .. six
        .. seven,
      nine
        .. ten
        .. eleven
        .. twelve
        .. thirteen
        .. zero
        .. one
        .. two
        .. three
        .. four
        .. five
        .. six
        .. seven
        .. eight,
      ten
        .. eleven
        .. twelve
        .. thirteen
        .. zero
        .. one
        .. two
        .. three
        .. four
        .. five
        .. six
        .. seven
        .. eight
        .. nine,
      eleven
        .. twelve
        .. thirteen
        .. zero
        .. one
        .. two
        .. three
        .. four
        .. five
        .. six
        .. seven
        .. eight
        .. nine
        .. ten,
      twelve
        .. thirteen
        .. zero
        .. one
        .. two
        .. three
        .. four
        .. five
        .. six
        .. seven
        .. eight
        .. nine
        .. ten
        .. eleven,
      thirteen
        .. zero
        .. one
        .. two
        .. three
        .. four
        .. five
        .. six
        .. seven
        .. eight
        .. nine
        .. ten
        .. eleven
        .. twelve,
    }
    return chars, 100
  end,

  mutating_lines = function()
    local chars = {
      spinner_colors.SpinnerRed .. '︷',
      spinner_colors.SpinnerRed .. '︵',
      spinner_colors.SpinnerRed .. '︹',
      spinner_colors.SpinnerRed .. '︺',
      spinner_colors.SpinnerRed .. '︶',
      spinner_colors.SpinnerRed .. '︸',
      spinner_colors.SpinnerRed .. '︶',
      spinner_colors.SpinnerRed .. '︺',
      spinner_colors.SpinnerRed .. '︹',
      spinner_colors.SpinnerRed .. '︵',
    }
    return chars, 200
  end,

  braille_6_circle_worm = function()
    local chars = {
      spinner_colors.SpinnerRed .. '⠋',
      spinner_colors.SpinnerRed .. '⠙',
      spinner_colors.SpinnerRed .. '⠹',
      spinner_colors.SpinnerRed .. '⠸',
      spinner_colors.SpinnerRed .. '⠼',
      spinner_colors.SpinnerRed .. '⠴',
      spinner_colors.SpinnerRed .. '⠦',
      spinner_colors.SpinnerRed .. '⠧',
      spinner_colors.SpinnerRed .. '⠇',
      spinner_colors.SpinnerRed .. '⠏',
    }
    return chars, 200
  end,

  braille_8_circle_worm = function(color)
    local chars = {
      color .. '⠋',
      color .. '⠙',
      color .. '⠹',
      color .. '⠸',
      color .. '⢰',
      color .. '⣰',
      color .. '⣠',
      color .. '⣄',
      color .. '⣆',
      color .. '⡆',
      color .. '⠇',
      color .. '⠏',
    }
    return chars, 60
  end,
}

M.run_spinner = function(chars, speed)
  local ms = vim.loop.hrtime() / 1000000
  local frame = math.floor(ms / speed) % #chars
  local content = string.format('%%<%s', chars[frame + 1])
  return content
end

M.fileInfo = function()
  local icon = ' 󰈚 '
  local path = vim.api.nvim_buf_get_name(stbufnr())
  local name = (path == '' and 'Empty ') or path:match('([^/\\]+)[/\\]*$')

  if name ~= 'Empty ' then
    local devicons_present, devicons = pcall(require, 'nvim-web-devicons')

    if devicons_present then
      local ft_icon = devicons.get_icon(name)
      icon = (ft_icon ~= nil and ' ' .. ft_icon) or icon
    end

    name = ' ' .. name .. ' '
  end

  local filetypes = {
    toggleterm = {
      icon = '%#St_toggleterm_icon#  ',
      label = '%#St_toggleterm#TOGGLETERM ',
      label_hl = '%#St_toggleterm#',
      sep_hl = '%#St_toggleterm_sep#',
    },
    harpoon = {
      icon = '%#St_harpoon_icon#  ',
      label = '%#St_harpoon#HARPOON ',
      label_hl = '%#St_harpoon#',
      sep_hl = '%#St_harpoon_sep#',
    },
    NvimTree = {
      icon = '%#St_nvimtree_icon#  ',
      label = '%#St_nvimtree#NVIMTREE ',
      label_hl = '%#St_nvimtree#',
      sep_hl = '%#St_nvimtree_sep#',
    },
    lazygit = {
      icon = '%#St_lazygit_icon#  ',
      label = '%#St_lazygit#LAZYGIT ',
      label_hl = '%#St_lazygit#',
      sep_hl = '%#St_lazygit_sep#',
    },
    Trouble = {
      icon = '%#St_trouble_icon# 𝍐 ',
      label = '%#St_trouble#TROUBLE ',
      label_hl = '%#St_trouble#',
      sep_hl = '%#St_trouble_sep#',
    },
  }

  local ft = vim.bo.ft

  local function redraw_status()
    vim.api.nvim_command('redrawstatus')
  end

  for ftype, info in pairs(filetypes) do
    if utils.contains(ft, ftype) then
      timer:start(100, redraw_status)
      local chars, speed = M.spinner.braille_8_circle_worm(info.label_hl)
      return info.icon
        .. info.label
        .. M.run_spinner(chars, speed)
        .. ' '
        .. info.sep_hl
        .. ''
        .. info.sep_hl
        .. ' '
    end
  end

  timer:stop()
  return '%#St_file_info#' .. icon .. name .. '%#St_file_sep#' .. sep_r
end

M.git = function()
  if not vim.b[stbufnr()].gitsigns_head or vim.b[stbufnr()].gitsigns_git_status then
    return ''
  end

  local git_status = vim.b[stbufnr()].gitsigns_status_dict

  local added = (git_status.added and git_status.added ~= 0) and ('%#St_gitAdd#  ' .. git_status.added) or ''
  local changed = (git_status.changed and git_status.changed ~= 0) and ('%#St_gitChange#  ' .. git_status.changed)
    or ''
  local removed = (git_status.removed and git_status.removed ~= 0) and ('%#St_gitRemove#  ' .. git_status.removed)
    or ''
  local branch_name = '  ' .. git_status.head

  return '%#ST_EmptySpace2#' .. '' .. '%#St_gitIcons#' .. branch_name .. added .. changed .. removed
end

M.LSP_Diagnostics = function()
  ---@type integer|string
  local errors = #vim.diagnostic.get(stbufnr(), { severity = vim.diagnostic.severity.ERROR })
  ---@type integer|string
  local warnings = #vim.diagnostic.get(stbufnr(), { severity = vim.diagnostic.severity.WARN })
  ---@type integer|string
  local hints = #vim.diagnostic.get(stbufnr(), { severity = vim.diagnostic.severity.HINT })
  ---@type integer|string
  local info = #vim.diagnostic.get(stbufnr(), { severity = vim.diagnostic.severity.INFO })

  errors = (errors and errors > 0) and ('%#St_lspError# 󰅚 ' .. errors .. ' ') or ''
  warnings = (warnings and warnings > 0) and ('%#St_lspWarning# ' .. warnings .. ' ') or ''
  hints = (hints and hints > 0) and ('%#St_LspHints#󱧣 ' .. hints .. ' ') or ''
  info = (info and info > 0) and ('%#St_lspInfo# ' .. info .. ' ') or ''

  return vim.o.columns > 140 and errors .. warnings .. hints .. info or ''
end

M.LSP_status = function()
  if rawget(vim, 'lsp') then
    ---@diagnostic disable-next-line
    for _, client in ipairs(vim.lsp.get_active_clients()) do
      if client.attached_buffers[stbufnr()] and client.name ~= 'null-ls' then
        return (
          vim.o.columns > 100 --[[ '%#St_LspStatus#╱' .. ]]
          and '%#St_LspStatus#' .. '   LSP ~ ' .. client.name .. ' '
        ) or '   LSP '
      end
    end
  end
end

M.cursor_position = function()
  return vim.o.columns > 140 and '%#St_pos_sep#' .. '' .. '%#St_pos_text# Ln %l, Col %c  ' or ''
end

M.cwd = function()
  local dir_name = '%#St_cwd_sep#' .. '' .. ' 󰉖 ' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t') .. ' '
  return (vim.o.columns > 85 and dir_name) or ''
end

return M
