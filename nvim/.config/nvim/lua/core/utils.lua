local api = vim.api
local fn = vim.fn
local augroup = api.nvim_create_augroup
local autocmd = api.nvim_create_autocmd
local clear_autocmds = api.nvim_clear_autocmds

local M = {}

local function organize_imports()
  local valid_fts = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' }

  if vim.tbl_contains(valid_fts, vim.bo.filetype) then
    vim.cmd('TSToolsOrganizeImports')
  else
    vim.lsp.buf.code_action({
      apply = true,
      context = { only = { 'source.organizeImports' }, diagnostics = {} },
    })
  end
end

--- Toggles diagnostics
local function toggle_diagnostics()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end

local function toggle_inlay_hints()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }))
  local msg = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }) and 'Lsp inlay hints enabled' or 'Lsp inlay hints disabled'
  print(msg)
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

    autocmd({ E.TextChangedI, E.TextChangedP, E.InsertEnter }, {
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
    autocmd(E.BufWritePost, {
      group = augroup('svelte_ondidchangetsorjsfile', { clear = true }),
      pattern = { '*.js', '*.ts' },
      callback = function(ctx)
        client.notify('$/onDidChangeTsOrJsFile', { uri = ctx.match })
      end,
    })
  end
end

---@param client vim.lsp.Client
local function cpp_setup(client)
  if client.name == 'clangd' then
    require('clangd_extensions.inlay_hints').setup_autocmd()
    require('clangd_extensions.inlay_hints').set_inlay_hints()
  end
end

---@param additional_keymaps? wk.Mapping[]
function M.set_lsp_mappings(additional_keymaps)
  local keymaps = {
    -- stylua: ignore start
    mode = 'n',
    { '<leader>lo', organize_imports,                    desc = '[L]SP Organize Imports',     icon = '󰶘' },
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
  cpp_setup(client)
end

M.capabilities =
  vim.tbl_deep_extend('force', {}, vim.lsp.protocol.make_client_capabilities(), require('cmp_nvim_lsp').default_capabilities())
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

--- Get's a list of absolute paths for all open files. Ignores plugin windows/buffers
---@return string[] open_files list of open files
local function list_open_files()
  local bufs = api.nvim_list_bufs()
  local visible_bufs = {}

  local function is_buf_visible(bufnr)
    local wins = api.nvim_list_wins()
    local should_skip = vim.tbl_contains(skip_ft, vim.bo[bufnr].ft) or api.nvim_buf_get_name(bufnr) == ''

    for _, win in ipairs(wins) do
      if api.nvim_win_get_buf(win) == bufnr and not should_skip then
        return true
      end
    end
    return false
  end

  for _, bufnr in ipairs(bufs) do
    if is_buf_visible(bufnr) then
      local name = api.nvim_buf_get_name(bufnr)
      table.insert(visible_bufs, name)
    end
  end

  return visible_bufs
end

--- Adds highlighting to any marked files that are currently visible
---@param bufnr integer harpoon.ui buffer handle
---@param ns_id integer namespace identifier
function M.highlight_marked_files(bufnr, ns_id)
  local open_files = list_open_files()

  ---@type string[]
  local marked = {}
  for idx = 1, require('harpoon.mark').get_length() do
    table.insert(marked, require('harpoon.mark').get_marked_file_name(idx))
  end

  for _, open_file in ipairs(open_files) do
    for idx = 1, #marked do
      local marked_file = marked[idx]

      if string.find(open_file, marked_file) then
        api.nvim_buf_add_highlight(bufnr, ns_id, 'HarpoonOpenMark', idx - 1, 0, -1)
      end
    end
  end
end

---@param diagnostics vim.Diagnostic[]
function M.add_missing_commas(diagnostics)
  for _, diag in pairs(diagnostics) do
    if diag.message == 'Miss symbol `,` or `;` .' or diag.message == 'Missed symbol `,`.' then
      api.nvim_buf_set_text(0, diag.lnum, diag.col, diag.lnum, diag.col, { ',' })
    end
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

---@param filename string
function M.has_file(filename)
  return fn.filereadable(fn.getcwd() .. '/' .. filename) == 1 and true or false
end

return M
