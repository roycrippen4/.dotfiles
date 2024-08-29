local api = vim.api
local fn = vim.fn
local augroup = api.nvim_create_augroup
local autocmd = api.nvim_create_autocmd
local clear_autocmds = api.nvim_clear_autocmds

local M = {}

local function lsp_definitions()
  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0, 'textDocument/definition', params, function(_, result, ctx)
    if not result or vim.tbl_isempty(result) then
      vim.notify('No definitions found', vim.log.levels.INFO)
      return
    end

    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if not client then
      return
    end

    local locations = vim.lsp.util.locations_to_items(result, client.offset_encoding)
    if #locations > 1 then
      require('telescope.builtin').lsp_definitions({
        cwd = vim.fn.getcwd(),
        locations = locations,
        client_id = ctx.client_id,
      })
    else
      vim.lsp.util.jump_to_location(result[1], client.offset_encoding)
    end
  end)
end

--- Toggles diagnostics
local function toggle_diagnostics()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end

local function toggle_inlay_hints()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }))
  print('inlay hints: ' .. tostring(vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })))
end

---@param chars string[]
local function check_trigger_chars(chars)
  local cur_line = api.nvim_get_current_line()
  local pos = api.nvim_win_get_cursor(0)[2]

  for _, char in ipairs(chars) do
    if cur_line:sub(pos, pos) == char or cur_line:sub(pos - 1, pos) == ', ' then
      return true
    end
  end
end

---@param bufnr integer
---@param client vim.lsp.Client
local function setup_signature_helper(bufnr, client)
  if client.server_capabilities.signatureHelpProvider then
    local group = augroup('LspSignature', { clear = false })
    clear_autocmds({ group = group, buffer = bufnr })

    autocmd({ 'TextChangedI', 'TextChangedP', 'InsertEnter' }, {
      group = group,
      buffer = bufnr,
      callback = function()
        if check_trigger_chars(client.server_capabilities.signatureHelpProvider.triggerCharacters) then
          vim.lsp.buf.signature_help()
        end
      end,
    })
  end
end

---@param client vim.lsp.Client
local function svelte_change_check(client)
  if client.name == 'svelte' then
    autocmd('BufWritePost', {
      group = augroup('svelte_ondidchangetsorjsfile', { clear = true }),
      pattern = { '*.js', '*.ts' },
      callback = function(ctx)
        client.notify('$/onDidChangeTsOrJsFile', { uri = ctx.match })
      end,
    })
  end
end

---@param additional_keymaps? wk.Mapping[]
function M.set_lsp_mappings(additional_keymaps)
  local keymaps = {
    -- stylua: ignore start
    mode = 'n',
    { 'gr', require('telescope.builtin').lsp_references,                      desc = 'Goto References',            icon = '' },
    -- { 'gd', require('telescope.builtin').lsp_definitions,                     desc = 'Goto Definition',            icon = '󰼭' },
    { 'gd', lsp_definitions,                                                  desc = 'Goto Definition',            icon = '󰼭' },
    { 'gi', require('telescope.builtin').lsp_implementations,                 desc = 'Goto Implementation',        icon = '󰡱' },
    { '<leader>lo', '<cmd> TSToolsOrganizeImports <cr>', desc = '[L]SP Organize Imports',     icon = '󰶘' },
    { '<leader>lh', toggle_inlay_hints,                  desc = '[L]SP Inlay Hints',          icon = '󰊠' },
    { '<leader>ld', toggle_diagnostics,                  desc = '[L]SP Diagnostics',          icon = '' },
    { '<leader>r',  vim.lsp.buf.rename,                  desc = 'Refactor',                   icon = '' },
    { '<leader>la', vim.lsp.buf.code_action,             desc = '[L]SP Code Action',          icon = '' },
    { '<leader>lf', vim.diagnostic.open_float,           desc = '[L]SP Floating Diagnostics', icon = '󰉪' },
    { '<leader>li', '<cmd> LspInfo <cr>',                desc = '[L]SP Server Info',          icon = '' },
    { '<leader>lR', '<cmd> LspRestart <cr>',             desc = '[L]SP Restart Servers',      icon = '' },
    -- stylua: ignore end
  }

  keymaps = vim.tbl_deep_extend('force', keymaps, additional_keymaps or {})

  require('which-key').add({ keymaps })
end

---@param client vim.lsp.Client
---@param bufnr integer
function M.on_attach(client, bufnr)
  M.set_lsp_mappings()
  svelte_change_check(client)
  setup_signature_helper(bufnr, client)
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem = {
  documentationFormat = { 'markdown', 'plaintext' },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      'documentation',
      'detail',
      'additionalTextEdits',
    },
  },
}

api.nvim_set_hl(0, 'UrlHighlight', { fg = 'gray' })
local url_ns = api.nvim_create_namespace('UrlHighlight')

local skip_ft = {
  'NvimTree',
  'Trouble',
  'alpha',
  'dap-repl',
  'dapui_breakpoints',
  'dapui_console',
  'dapui_scopes',
  'dapui_stacks',
  'dapui_watches',
  'dashboard',
  'fidget',
  'help',
  'harpoon',
  'lazy',
  'logger',
  'noice',
  'nvcheatsheet',
  'nvdash',
  'terminal',
  'toggleterm',
  'vim',
}

---@param key string
---@param mode string
function _G.feed(key, mode)
  api.nvim_feedkeys(api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

---@param cwd string|nil
function M.set_titlestring(cwd)
  local env = os.getenv('HOME')

  if cwd == env then
    vim.o.titlestring = '~/' .. '  '
    return
  end

  if cwd and type(env) == 'string' then
    local match = string.match(cwd, env)
    if match then
      vim.o.titlestring = cwd:gsub(match, '~') .. '  '
      return
    end
    vim.o.titlestring = cwd
  end
end

function M.highlight_url()
  if require('nvim-treesitter.parsers').has_parser() then
    local node = vim.treesitter.get_node({ lang = 'comment' })

    if not node then
      return
    end

    api.nvim_buf_clear_namespace(0, url_ns, 0, -1)
    if node:type() == 'uri' then
      local line, col_start, _, col_end = node:range()
      api.nvim_buf_add_highlight(0, url_ns, 'UrlHighlight', line, col_start, col_end)
    end
  end
end

--- Returns a list of all files marked by harpoon
---@return string[]
function M.get_marked_files()
  ---@type string[]
  local marked = {}
  for idx = 1, require('harpoon.mark').get_length() do
    table.insert(marked, require('harpoon.mark').get_marked_file_name(idx))
  end
  return marked
end

--- Sets the currently opened file to the first entry in the marks list
function M.set_as_first_mark()
  local mark = require('harpoon.mark')
  local bufname = api.nvim_buf_get_name(0)
  local path = require('plenary.path'):new(bufname):make_relative(vim.uv.cwd())
  local marks = require('core.utils').get_marked_files()
  ---@type integer|nil
  local file_idx

  if vim.tbl_contains(marks, path) then
    file_idx = mark.get_current_index()
  else
    mark.add_file()
    file_idx = mark.get_length()
    marks = require('core.utils').get_marked_files()
  end

  ---@type string[]
  local new_marks = {}
  table.insert(new_marks, mark.get_marked_file_name(file_idx))
  for _, filepath in pairs(marks) do
    if vim.tbl_contains(new_marks, filepath) then
      goto continue
    end

    table.insert(new_marks, filepath)

    ::continue::
  end
  mark.set_mark_list(new_marks)
  vim.cmd('redrawtabline')
end

--- Adds highlighting to any marked files that are currently visible
---@param bufnr integer harpoon.ui buffer handle
---@param ns_id integer namespace identifier
function M.highlight_marked_files(bufnr, ns_id)
  local open_files = M.list_open_files()
  local marked = M.get_marked_files()

  for _, open_file in ipairs(open_files) do
    for idx = 1, #marked do
      local marked_file = marked[idx]

      if string.find(open_file, marked_file) then
        api.nvim_buf_add_highlight(bufnr, ns_id, 'HarpoonOpenMark', idx - 1, 0, -1)
      end
    end
  end
end

--- Takes a bufnr. Returns true if bufnr is visible, [false] if not
---@param bufnr integer buffer handle/number
function M.is_buf_visible(bufnr)
  local wins = api.nvim_list_wins()
  local should_skip = vim.tbl_contains(skip_ft, vim.bo[bufnr].ft) or api.nvim_buf_get_name(bufnr) == ''

  for _, win in ipairs(wins) do
    if api.nvim_win_get_buf(win) == bufnr and not should_skip then
      return true
    end
  end
  return false
end

--- Get's a list of absolute paths for all open files. Ignores plugin windows/buffers
---@return string[] open_files list of open files
function M.list_open_files()
  local bufs = api.nvim_list_bufs()
  local visible_bufs = {}

  for _, bufnr in ipairs(bufs) do
    if M.is_buf_visible(bufnr) then
      local name = api.nvim_buf_get_name(bufnr)
      table.insert(visible_bufs, name)
    end
  end
  return visible_bufs
end

---@param opts table
function M.load_ext(opts)
  for _, ext in ipairs(opts.extensions_list) do
    require('telescope').load_extension(ext)
  end
end

--- Returns true if the currently opened file is marked
---@return boolean|integer
function M.is_current_file_marked()
  local current_file = api.nvim_buf_get_name(api.nvim_get_current_buf())
  local marked_files = M.get_marked_files()
  for _, file in ipairs(marked_files) do
    if string.find(current_file, file) then
      return true
    end
  end
  return false
end

---@param diagnostics vim.Diagnostic[]
function M.add_missing_commas(diagnostics)
  for _, diag in pairs(diagnostics) do
    if diag.message == 'Miss symbol `,` or `;` .' or diag.message == 'Missed symbol `,`.' then
      api.nvim_buf_set_text(0, diag.lnum, diag.col, diag.lnum, diag.col, { ',' })
    end
  end
end

local pairs = { '()', '[]', '{}', "''", '""', '``', '  ' }
---@param key string
---@param fallback string
function M.handle_cmdline_pair(key, fallback)
  local pos = fn.getcmdpos()
  local cmdline = fn.getcmdline()

  for _, pair in ipairs(pairs) do
    if string.sub(cmdline, pos - 1, pos) == pair then
      feed(key, 'n')
      return
    end
  end
  feed(fallback, 'n')
end

function M.harpoon_add_file()
  require('harpoon.mark').add_file()
  vim.cmd('redrawtabline')
end

function M.show_harpoon_menu()
  require('harpoon.ui').toggle_quick_menu()
  vim.wo.cursorline = true
end

function M.create_harpoon_nav_mappings()
  for i = 1, 10, 1 do
    local n = i ~= 10 and i or 0
    local str = ('<C-' .. n .. '>')
    vim.keymap.set('n', str, function()
      require('harpoon.ui').nav_file(n)
    end, { desc = 'Mark file' })
  end
end

function M.close_buf()
  if #api.nvim_list_wins() == 1 and string.sub(api.nvim_buf_get_name(0), -10) == 'NvimTree_1' then
    vim.cmd([[ q ]])
  else
    require('local.tabufline').close_buffer()
  end
end

function M.send_to_black_hole()
  local line_content = fn.line('.')
  if type(line_content) == 'string' and string.match(line_content, '^%s*$') then
    vim.cmd('normal! "_dd')
  else
    vim.cmd('normal! dd')
  end
end

---@param win integer
---@param opts table
function M.win_apply_config(win, opts)
  opts = vim.tbl_deep_extend('force', api.nvim_win_get_config(win), opts or {})
  api.nvim_win_set_config(win, opts)
end

--- Returns true if the file exists
---@param filename string
---@return boolean
function M.file_exists(filename)
  local file = io.open(filename, 'r')

  if file ~= nil then
    io.close(file)
    return true
  end

  return false
end

--- @return boolean
local function toggle_text()
  local current_word = vim.fn.expand('<cword>')

  if current_word == 'true' then
    feed('ciwfalse<esc>', 'n')
    return true
  end

  if current_word == 'false' then
    feed('ciwtrue<esc>', 'n')
    return true
  end

  if current_word == 'True' then
    feed('ciwFalse<esc>', 'n')
    return true
  end

  if current_word == 'False' then
    feed('ciwTrue<esc>', 'n')
    return true
  end

  if current_word == '&&' then
    feed('ciw||<esc>', 'n')
    return true
  end

  if current_word == '||' then
    feed('ciw&&<esc>', 'n')
    return true
  end

  if current_word == 'and' then
    feed('ciwor<esc>', 'n')
    return true
  end

  if current_word == 'or' then
    feed('ciwand<esc>', 'n')
    return true
  end

  return false
end

function M.ctrl_x()
  if not toggle_text() then
    feed('<C-x>', 'n')
  end
end

function M.ctrl_a()
  if not toggle_text() then
    feed('<C-a>', 'n')
  end
end

return M
