local function stbufnr()
  return vim.api.nvim_win_get_buf(0)
end

local M = {}
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

M.mode = function()
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
  local mode_sep1 = '%#' .. M.modes[m][2] .. 'Sep#'

  local recording_register = vim.fn.reg_recording()

  if recording_register == '' then
    return current_mode .. mode_sep1
  else
    return '%#ST_Macro# 󰑊 MACRO ' .. recording_register .. '%#ST_MacroSep# '
  end
end

local function truncate_filename(filename, max_length)
  local max_len = max_length or 20
  local len = #filename

  if len <= max_len then
    return filename
  end

  local base_name, extension = filename:match('(.*)%.(.*)')
  if not base_name then
    base_name = filename
    extension = ''
  end

  local base_len = max_len - #extension - 1
  local partial_len = math.floor(base_len / 2)

  return base_name:sub(1, partial_len) .. '…' .. base_name:sub(-partial_len) .. '.' .. extension
end

M.file_info = function()
  local icon = ' 󰈚 '
  local path = vim.api.nvim_buf_get_name(stbufnr())
  local name = (path == '' and 'Empty ') or path:match('([^/\\]+)[/\\]*$')

  if name == '[Command Line]' then
    return '  CmdHistory '
  end

  if #name > 25 then
    name = truncate_filename(name)
  end

  if name ~= 'Empty ' then
    local devicons_present, devicons = pcall(require, 'nvim-web-devicons')

    if devicons_present then
      local ft_icon = devicons.get_icon(name)
      icon = (ft_icon ~= nil and ' ' .. ft_icon) or icon
    end

    name = ' ' .. name .. ' '
  end

  local filetypes = {
    Colors = {
      icon = '%#St_Colors1#  ',
      label = '%#St_Colors2#C' .. '%#St_Colors3#O' .. '%#St_Colors4#L' .. '%#St_Colors5#O' .. '%#St_Colors6#R' .. '%#St_Colors7#S',
    },
    DressingInput = {
      icon = '  ',
      label = 'INPUT BOX',
    },
    harpoon = {
      icon = '  ',
      label = 'HARPOON',
    },
    mason = {
      icon = '%#St_Mason# 󱌣 ',
      label = 'MASON',
    },
    undotree = {
      icon = '  ',
      label = 'UNDOTREE',
    },
    NvimTree = {
      icon = '%#St_NvimTree#  ',
      label = 'NVIMTREE',
    },
    lazy = {
      icon = '%#St_Lazy# 💤 ',
      label = 'LAZY',
    },
    lazygit = {
      icon = '%#St_Lazygit#  ',
      label = 'LAZYGIT',
    },
    Trouble = {
      icon = '%#St_Trouble# 𝍐 ',
      label = 'TROUBLE',
    },
    TelescopePrompt = {
      icon = '  ',
      label = 'TELESCOPE',
    },
  }

  local ft = vim.bo.ft

  for k, v in pairs(filetypes) do
    if string.find(ft, k) ~= nil then
      return v.icon .. v.label .. ' ' .. ''
    end
  end

  return '%#St_FileInfo#' .. icon .. name .. '%#St_FileSep#' .. ''
end

M.git = function()
  if not vim.b[stbufnr()].gitsigns_head or vim.b[stbufnr()].gitsigns_git_status then
    return '%#St_EmptySpace#'
  end

  local git_status = vim.b[stbufnr()].gitsigns_status_dict

  local added = (git_status.added and git_status.added ~= 0) and ('%#St_GitAdd#  ' .. git_status.added) or ''
  local changed = (git_status.changed and git_status.changed ~= 0) and ('%#St_GitChange#  ' .. git_status.changed) or ''
  local removed = (git_status.removed and git_status.removed ~= 0) and ('%#St_GitRemove#  ' .. git_status.removed) or ''
  local branch_name = '%#St_GitBranch#  ' .. git_status.head .. ' '

  return branch_name .. added .. changed .. removed
end

M.lsp_diagnostics = function()
  local count = vim.diagnostic.count(0)
  local errors = count[1]
  local warnings = count[2]
  local hints = count[3]
  local info = count[4]

  errors = (errors and errors > 0) and ('%#St_Lsp_Error#󰅚 ' .. errors .. ' ') or ''
  warnings = (warnings and warnings > 0) and ('%#St_LspWarning# ' .. warnings .. ' ') or ''
  hints = (hints and hints > 0) and ('%#St_LspHints#󱧣 ' .. hints .. ' ') or ''
  info = (info and info > 0) and ('%#St_LspInfo# ' .. info .. ' ') or ''

  return vim.o.columns > 140 and errors .. warnings .. hints .. info or ''
end

M.lsp_status = function()
  if rawget(vim, 'lsp') then
    ---@diagnostic disable-next-line
    for _, client in ipairs(vim.lsp.get_active_clients()) do
      if client.attached_buffers[stbufnr()] then
        return (vim.o.columns > 100 and '%#St_LspStatus#' .. '   LSP ~ ' .. client.name .. ' ') or '   LSP '
      end
    end
  end
  return ''
end

M.cursor_position = function()
  local mode = vim.fn.mode(true)

  local v_line, v_col = vim.fn.line('v'), vim.fn.col('v')
  local cur_line, cur_col = vim.fn.line('.'), vim.fn.col('.')

  if mode == '' then
    return '%#St_VisualMode#' .. '' .. ' Ln ' .. math.abs(v_line - cur_line) + 1 .. ', Col ' .. math.abs(v_col - cur_col) + 1 .. ' '
  end

  local total_lines = math.abs(v_line - cur_line) + 1
  if mode == 'V' then
    local cur_line_is_bigger = v_line and cur_line and v_line < cur_line

    if cur_line_is_bigger then
      return '%#St_VisualMode#' .. ' Ln ' .. v_line .. ' - Ln %l ⎸ ' .. total_lines
    else
      return '%#St_VisualMode#' .. ' Ln %l - Ln ' .. v_line .. ' ⎸ ' .. total_lines
    end
  end

  if mode == 'v' then
    if v_line == cur_line then
      return '%#St_VisualMode#' .. ' Col ' .. math.abs(v_col - cur_col) + 1 .. ' '
    else
      return '%#St_VisualMode#' .. ' Ln ' .. total_lines .. ' '
    end
  end

  return vim.o.columns > 140 and '%#St_PosSep#' .. '' .. '%#St_PosText# Ln %l, Col %c ' or ''
end

M.time = function()
  return '%#St_Time# ' .. os.date('%I:%M:%S %p ', os.time())
end

M.cwd = function()
  local dir_name = '%#St_CwdSep#' .. '' .. ' 󰉖 ' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t') .. ' '
  return (vim.o.columns > 85 and dir_name) or ''
end

M.max_length = function()
  return #M.mode() + #M.file_info() + #M.git()
end

-- Dynamically changes the highlight group of the statusline mode segment based on the current mode
vim.api.nvim_create_autocmd('ModeChanged', {
  group = vim.api.nvim_create_augroup('StatusLineMode', { clear = true }),
  callback = function()
    local m = vim.api.nvim_get_mode().mode
    local hl = vim.api.nvim_get_hl(0, { name = M.modes[m][2] })
    vim.api.nvim_set_hl(0, 'St_NvimTree', { fg = hl.fg, bg = hl.bg, italic = true })
    vim.api.nvim_set_hl(0, 'St_Harpoon', { fg = hl.fg, bg = hl.bg, italic = true })
  end,
})

return M
