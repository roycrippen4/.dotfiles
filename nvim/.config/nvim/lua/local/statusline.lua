local autocmd = vim.api.nvim_create_autocmd

local clock_timer = vim.uv.new_timer()

--- WARNING: DONT CHANGE THIS
local function redraw()
  vim.cmd('redrawstatus')
end

if clock_timer then
  clock_timer:start(1000, 1000, vim.schedule_wrap(redraw))
end

local M = {}

local command_icon = '  '
local normal_icon = '  '
local insert_icon = '  '
local select_icon = '  '
local replace_icon = '  '
local confirm_icon = '❔ '

--- Enumerates the different modes and their respective text and highlight groups
---@type { [string]: { text: string, hl: string, icon: string } }
local modes = {
  -- Normal
  ['n'] = { text = 'NORMAL', hl = 'St_NormalMode', icon = normal_icon },
  ['no'] = { text = 'NORMAL (no)', hl = 'St_NormalMode', icon = normal_icon },
  ['nov'] = { text = 'NORMAL (nov)', hl = 'St_NormalMode', icon = normal_icon },
  ['noV'] = { text = 'NORMAL (noV)', hl = 'St_NormalMode', icon = normal_icon },
  ['noCTRL-V'] = { text = 'NORMAL', hl = 'St_NormalMode', icon = normal_icon },
  ['niI'] = { text = 'NORMAL i', hl = 'St_NormalMode', icon = normal_icon },
  ['niR'] = { text = 'NORMAL r', hl = 'St_NormalMode', icon = normal_icon },
  ['niV'] = { text = 'NORMAL v', hl = 'St_NormalMode', icon = normal_icon },
  ['nt'] = { text = 'NTERMINAL', hl = 'St_NTerminalMode', icon = normal_icon },
  ['ntT'] = { text = 'NTERMINAL (ntT)', hl = 'St_NTerminalMode', icon = normal_icon },

  -- Visual
  ['v'] = { text = 'VISUAL', hl = 'St_VisualMode', icon = '  ' },
  ['vs'] = { text = 'V-CHAR (Ctrl O)', hl = 'St_VisualMode', icon = ' 󱡠 ' },
  ['V'] = { text = 'V-LINE', hl = 'St_VisualMode', icon = '  ' },
  ['Vs'] = { text = 'V-LINE', hl = 'St_VisualMode', icon = '  ' },
  [''] = { text = 'V-BLOCK', hl = 'St_VisualMode', icon = ' 󰣟 ' },

  -- Insert
  ['i'] = { text = 'INSERT', hl = 'St_InsertMode', icon = insert_icon },
  ['ic'] = { text = 'INSERT (completion)', hl = 'St_InsertMode', icon = insert_icon },
  ['ix'] = { text = 'INSERT completion', hl = 'St_InsertMode', icon = insert_icon },

  -- Terminal   
  ['t'] = { text = 'TERMINAL', hl = 'St_TerminalMode', icon = '  ' },

  -- Replace
  ['R'] = { text = 'REPLACE', hl = 'St_ReplaceMode', icon = replace_icon },
  ['Rc'] = { text = 'REPLACE (Rc)', hl = 'St_ReplaceMode', icon = replace_icon },
  ['Rx'] = { text = 'REPLACEa (Rx)', hl = 'St_ReplaceMode', icon = replace_icon },
  ['Rv'] = { text = 'V-REPLACE', hl = 'St_ReplaceMode', icon = replace_icon },
  ['Rvc'] = { text = 'V-REPLACE (Rvc)', hl = 'St_ReplaceMode', icon = replace_icon },
  ['Rvx'] = { text = 'V-REPLACE (Rvx)', hl = 'St_ReplaceMode', icon = replace_icon },

  -- Select
  ['s'] = { text = 'SELECT', hl = 'St_SelectMode', icon = select_icon },
  ['S'] = { text = 'S-LINE', hl = 'St_SelectMode', icon = select_icon },
  [''] = { text = 'S-BLOCK', hl = 'St_SelectMode', icon = select_icon },

  -- Command
  ['c'] = { text = 'COMMAND', hl = 'St_CommandMode', icon = command_icon },
  ['cv'] = { text = 'COMMAND', hl = 'St_CommandMode', icon = command_icon },
  ['ce'] = { text = 'COMMAND', hl = 'St_CommandMode', icon = command_icon },

  -- Confirm
  ['r'] = { text = 'PROMPT', hl = 'St_ConfirmMode', icon = confirm_icon },
  ['rm'] = { text = 'MORE', hl = 'St_ConfirmMode', icon = confirm_icon },
  ['r?'] = { text = 'CONFIRM', hl = 'St_ConfirmMode', icon = confirm_icon },
  ['x'] = { text = 'CONFIRM', hl = 'St_ConfirmMode', icon = confirm_icon },

  -- Shell
  ['!'] = { text = 'SHELL', hl = 'St_TerminalMode', icon = '  ' },
}

M.mode = function()
  -- Normal
  local entry = modes[vim.api.nvim_get_mode().mode]
  local current_mode = '%#' .. entry.hl .. '#' .. (entry.icon or '  ') .. entry.text .. ' '
  local mode_sep1 = '%#' .. entry.hl .. 'Sep#'

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
  local path = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(0))
  local name = (path == '' and 'Empty ') or path:match('([^/\\]+)[/\\]*$')

  if name == 'fish' then
    return ' %#St_Fish#󰈺 SHELL %#St_FileSep#'
  end

  if name == '[Command Line]' then
    return '  CmdHistory '
  end

  if #name > 25 then
    name = truncate_filename(name)
  end

  if name ~= 'Empty ' then
    local ft_icon, _ = require('nvim-web-devicons').get_icon(name)
    icon = ((ft_icon ~= nil) and ' %#St_FtIcon#' .. ft_icon) or icon

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
    lspinfo = {
      icon = '  ',
      label = 'LSP INFO',
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
    lazygit = {
      icon = '%#St_Lazygit#  ',
      label = 'LAZYGIT',
    },
    lazy = {
      icon = '%#St_Lazy# 💤 ',
      label = 'LAZY',
    },
    Trouble = {
      icon = '%#St_Trouble#  ',
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

  return icon .. '%#St_FileInfo#' .. name .. '%#St_FileSep#' .. ''
end

M.git = function()
  local bufnr = vim.api.nvim_win_get_buf(0)
  if not vim.b[bufnr].gitsigns_head or vim.b[bufnr].gitsigns_git_status then
    return '%#St_EmptySpace#'
  end

  local git_status = vim.b[bufnr].gitsigns_status_dict

  local added = (git_status.added and git_status.added ~= 0) and ('%#St_GitAdd#  ' .. git_status.added) or ''
  local changed = (git_status.changed and git_status.changed ~= 0) and ('%#St_GitChange#  ' .. git_status.changed) or ''
  local removed = (git_status.removed and git_status.removed ~= 0) and ('%#St_GitRemove#  ' .. git_status.removed) or ''
  local branch_name = '%#St_GitBranch#  ' .. git_status.head

  return branch_name .. added .. changed .. removed .. '%#St_FileSep#  '
end

M.lsp_diagnostics = function()
  if vim.bo.ft == 'lazy' then
    return ''
  end

  local count = vim.diagnostic.count(0)
  local errors = count[1]
  local warnings = count[2]
  local hints = count[3]
  local info = count[4]

  errors = (errors and errors > 0) and ('%#St_Lsp_Error#󰅚 ' .. errors .. ' ') or ''
  warnings = (warnings and warnings > 0) and ('%#St_LspWarning# ' .. warnings .. ' ') or ''
  hints = (hints and hints > 0) and ('%#St_LspHints#󱡴 ' .. hints .. ' ') or ''
  info = (info and info > 0) and ('%#St_LspInfo# ' .. info .. ' ') or ''

  return vim.o.columns > 140 and errors .. warnings .. hints .. info or ''
end

M.lsp_status = function()
  if rawget(vim, 'lsp') then
    for _, client in ipairs(vim.lsp.get_clients()) do
      if client.attached_buffers[vim.api.nvim_win_get_buf(0)] then
        return (vim.o.columns > 100 and '%#St_LspStatus#' .. '   LSP [' .. client.name .. '] ') or '   LSP '
      end
    end
  end
  return ''
end

M.cursor_position = function()
  local current_mode = vim.fn.mode(true)

  local v_line, v_col = vim.fn.line('v'), vim.fn.col('v')
  local cur_line, cur_col = vim.fn.line('.'), vim.fn.col('.')

  if current_mode == '' then
    return '%#St_VisualMode#' .. '' .. ' Ln ' .. math.abs(v_line - cur_line) + 1 .. ', Col ' .. math.abs(v_col - cur_col) + 1 .. ' '
  end

  local total_lines = math.abs(v_line - cur_line) + 1
  if current_mode == 'V' then
    local cur_line_is_bigger = v_line and cur_line and v_line < cur_line

    if cur_line_is_bigger then
      return '%#St_VisualMode#' .. ' Ln ' .. v_line .. ' - Ln %l ⎸ ' .. total_lines
    else
      return '%#St_VisualMode#' .. ' Ln %l - Ln ' .. v_line .. ' ⎸ ' .. total_lines
    end
  end

  if current_mode == 'v' then
    if v_line == cur_line then
      return '%#St_VisualMode#' .. ' Col ' .. math.abs(v_col - cur_col) + 1 .. ' '
    else
      return '%#St_VisualMode#' .. ' Ln ' .. total_lines .. ' '
    end
  end

  return vim.o.columns > 140 and '%#St_PosSep#' .. '' .. '%#St_PosText# Ln %l, Col %c ' or ''
end

M.time = function()
  return '%#St_Time# ' .. os.date('%I:%M:%S %p ', os.time())
end

M.cwd = function()
  local dir_name = '%#St_CwdSep#' .. '' .. ' 󰉖 ' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t') .. ' '
  return (vim.o.columns > 85 and dir_name) or ''
end

M.package_info = function()
  if vim.fn.expand('%:t') == 'package.json' then
    return require('package-info').get_status()
  end

  return ''
end

-- Dynamically changes the highlight group of the statusline mode segment based on the current mode
autocmd('ModeChanged', {
  group = vim.api.nvim_create_augroup('StatusLineMode', { clear = true }),
  callback = function()
    local entry = modes[vim.api.nvim_get_mode().mode]
    local hl = vim.api.nvim_get_hl(0, { name = entry.hl })
    vim.api.nvim_set_hl(0, 'St_NvimTree', { fg = hl.fg, bg = hl.bg, italic = true })
    vim.api.nvim_set_hl(0, 'St_Harpoon', { fg = hl.fg, bg = hl.bg, italic = true })
  end,
})

-- Dynamically changes the highlight group of the statusline filetype icon based on the current file
autocmd('BufEnter', {
  group = vim.api.nvim_create_augroup('StatusLineFiletype', { clear = true }),
  callback = function()
    local _, hl_group = require('nvim-web-devicons').get_icon(vim.fn.expand('%:e'))

    if hl_group == nil then
      return
    end

    local hl = vim.api.nvim_get_hl(0, { name = hl_group })
    vim.api.nvim_set_hl(0, 'St_FtIcon', { fg = hl.fg, bg = '#21252b' })
  end,
})

vim.opt.statusline = "%!v:lua.require('local.statusline').generate_statusline()"

M.generate_statusline = function()
  local statusline = {
    M.mode(),
    M.file_info(),
    M.git(),
    '%=',
    M.package_info(),
    '%=',
    M.lsp_diagnostics(),
    M.lsp_status(),
    M.cursor_position(),
    M.time(),
    M.cwd(),
  }
  return table.concat(statusline)
end

return M
