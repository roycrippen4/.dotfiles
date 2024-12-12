local api = vim.api
local fn = vim.fn
local augroup = api.nvim_create_augroup
local autocmd = api.nvim_create_autocmd
local clear_autocmds = api.nvim_clear_autocmds

_G.U = {}

---Generates an array of numbers from start to stop with step n
---Table is end-inclusive
---@param start integer Starting point
---@param stop integer Stopping point
---@param step integer? Step size
---@return integer[]
function U.range(start, stop, step)
  if start == stop then
    return { start }
  end

  if start < stop and not step then
    step = 1
  end

  if start > stop and not step then
    step = -1
  end

  if start < stop and step < 0 then
    Snacks.notify.error({
      '```lua',
      'utils.range(' .. start .. ', ' .. stop .. ', ' .. step .. ')',
      '            ───┬  ┬',
      '               │  ╰─ Should be positive',
      '               ╰─ Or swap these',
      '```',
    }, { title = 'Invalid Parameters' })
  end

  if start > stop and step > 0 then
    Snacks.notify.error({
      '```lua',
      'utils.range(' .. start .. ', ' .. stop .. ', ' .. step .. ')',
      '            ───┬  ┬',
      '               │  ╰─ Should be negative',
      '               ╰─ Or swap these',
      '```',
    }, { title = 'Invalid Parameters' })
  end

  ---@type integer[]
  local res = {}
  for i = start, stop, step do
    table.insert(res, i)
  end
  return res
end

---Creates an iterator from an array from start to stop with step n
---Table is end-inclusive
---@param start integer Starting point
---@param stop integer Stopping point
---@param step integer? Step size
---@return Iter
function U.range_iter(start, stop, step)
  return vim.iter(U.range(start, stop, step))
end

local function organize_imports()
  -- local valid_fts = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' }

  -- if vim.tbl_contains(valid_fts, vim.bo.filetype) then
  vim.lsp.buf.code_action({
    apply = true,
    context = { only = { 'source.organizeImports' }, diagnostics = {} },
  })
  -- else
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
  return vim.iter(chars):any(function(char)
    return cur_line:sub(pos, pos) == char or cur_line:sub(pos - 1, pos) == ', '
  end)
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
local function svelte(client)
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

---@param client vim.lsp.Client
local function ts(client, _)
  if client.name ~= 'vtsls' then
    return
  end

  --- this fixes a strange vtsls warning message
  client.commands['_typescript.didOrganizeImports'] = function() end

  ---@diagnostic disable-next-line
  client.handlers['workspace/executeCommand'] = function(err, _, result, _)
    if err and err.message:match('_typescript.didOrganizeImports') then
      return nil
    end

    ---@diagnostic disable-next-line
    return vim.lsp.handlers['workspace/executeCommand'](err, _, result, _)
  end

  client.commands['_typescript.moveToFileRefactoring'] = function(command, _)
    ---@type string, string, lsp.Range
    ---@diagnostic disable-next-line
    local action, uri, range = unpack(command.arguments)

    local function move(newf)
      client.request('workspace/executeCommand', {
        command = command.command,
        arguments = { action, uri, range, newf },
      })
    end

    ---@diagnostic disable-next-line
    local fname = vim.uri_to_fname(uri)
    client.request('workspace/executeCommand', {
      command = 'typescript.tsserverRequest',
      arguments = {
        'getMoveToRefactoringFileSuggestions',
        {
          file = fname,
          ---@diagnostic disable-next-line
          startLine = range.start.line + 1,
          ---@diagnostic disable-next-line
          startOffset = range.start.character + 1,
          ---@diagnostic disable-next-line
          endLine = range['end'].line + 1,
          ---@diagnostic disable-next-line
          endOffset = range['end'].character + 1,
        },
      },
    }, function(_, result)
      ---@type string[]
      local files = result.body.files
      table.insert(files, 1, 'Enter new path...')
      vim.ui.select(files, {
        prompt = 'Select move destination:',
        format_item = function(f)
          return vim.fn.fnamemodify(f, ':~:.')
        end,
      }, function(f)
        if f and f:find('^Enter new path') then
          ---@diagnostic disable-next-line: missing-fields
          vim.ui.input({
            prompt = 'Enter move destination:',
            default = vim.fn.fnamemodify(fname, ':h') .. '/',
            completion = 'file',
          }, function(newf)
            ---@diagnostic disable-next-line: redundant-return-value
            return newf and move(newf)
          end)
        elseif f then
          move(f)
        end
      end)
    end)
  end
end

---@param additional_keymaps? wk.Mapping[]
function U.set_lsp_mappings(additional_keymaps)
  require('which-key').add({
    vim.tbl_deep_extend('force', {
      mode = 'n',
      { '<leader>lo', organize_imports, desc = '[L]SP Organize Imports', icon = '󰶘' },
      { '<leader>lh', toggle_inlay_hints, desc = '[L]SP Inlay Hints', icon = '󰊠' },
      { '<leader>ld', toggle_diagnostics, desc = '[L]SP Diagnostics', icon = '' },
      { '<leader>r', vim.lsp.buf.rename, desc = 'Refactor', icon = '' },
      { '<leader>la', vim.lsp.buf.code_action, desc = '[L]SP Code Action', icon = '' },
      { '<leader>lf', vim.diagnostic.open_float, desc = '[L]SP Floating Diagnostics', icon = '󰉪' },
      { '<leader>li', '<cmd> LspInfo <cr>', desc = '[L]SP Server Info', icon = '' },
      { '<leader>lR', '<cmd> LspRestart <cr>', desc = '[L]SP Restart Servers', icon = '' },
    }, additional_keymaps or {}),
  })
end

---@param client vim.lsp.Client
---@param bufnr integer,
function U.on_attach(client, bufnr)
  U.set_lsp_mappings()
  svelte(client)
  ts(client, bufnr)
  setup_signature_helper(bufnr, client)
  -- cpp_setup(client)
end

U.capabilities = vim.lsp.protocol.make_client_capabilities()
U.capabilities.textDocument.completion.completionItem = {
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

---@param key string
---@param mode string
function _G.feed(key, mode)
  api.nvim_feedkeys(api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

---@param diagnostics vim.Diagnostic[]
function U.add_missing_commas(diagnostics)
  vim.iter(diagnostics):each(function(diag)
    if diag.message == 'Miss symbol `,` or `;` .' or diag.message == 'Missed symbol `,`.' then
      api.nvim_buf_set_text(0, diag.lnum, diag.col, diag.lnum, diag.col, { ',' })
    end
  end)
end

function U.close_buf()
  -- if #api.nvim_list_wins() == 1 and string.sub(api.nvim_buf_get_name(0), -10) == 'NvimTree_1' then
  --   vim.cmd([[ q ]])
  -- else
  require('local.tabufline').close_buffer()
  -- end
end

function U.send_to_black_hole()
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

function U.ctrl_x()
  if not toggle_text() then
    feed('<C-x>', 'n')
  end
end

function U.ctrl_a()
  if not toggle_text() then
    feed('<C-a>', 'n')
  end
end

---@param filename string
function U.has_file(filename)
  return fn.filereadable(fn.getcwd() .. '/' .. filename) == 1 and true or false
end

---@type fun(ctx: {buf: integer, event?: string, file?: string, id?: integer, match?: string}): nil
function U.create_backdrop(ctx)
  local backdrop_bufnr = vim.api.nvim_create_buf(false, true)
  local winnr = vim.api.nvim_open_win(backdrop_bufnr, false, {
    relative = 'editor',
    row = 0,
    col = 0,
    width = vim.o.columns,
    height = vim.o.columns,
    focusable = false,
    style = 'minimal',
    zindex = 10,
  })

  vim.api.nvim_set_hl(0, 'Backdrop', { bg = '#000000', default = true })
  vim.wo[winnr].winhighlight = 'Normal:Backdrop'
  vim.wo[winnr].winblend = 50
  vim.bo[backdrop_bufnr].buftype = 'nofile'

  vim.api.nvim_set_hl(0, 'MsgArea', { bg = '#101215' })
  vim.api.nvim_create_autocmd({ 'WinClosed', 'BufLeave' }, {
    once = true,
    buffer = ctx.buf,
    callback = function()
      vim.api.nvim_set_hl(0, 'MsgArea', { bg = require('plugins.colorscheme.palette').black3 })
      if vim.api.nvim_win_is_valid(winnr) then
        vim.api.nvim_win_close(winnr, true)
      end
      if vim.api.nvim_buf_is_valid(backdrop_bufnr) then
        vim.api.nvim_buf_delete(backdrop_bufnr, { force = true })
      end
    end,
  })
end

--- Gets a path to a package in the Mason registry.
--- Prefer this to `get_package`, since the package might not always be
--- available yet and trigger errors.
---@param pkg string
---@param path? string
---@param opts? { warn?: boolean }
function U.get_pkg_path(pkg, path, opts)
  pcall(require, 'mason')
  local root = vim.env.MASON or (vim.fn.stdpath('data') .. '/mason')
  opts = opts or {}
  opts.warn = opts.warn == nil and true or opts.warn
  path = path or ''
  local ret = root .. '/packages/' .. pkg .. '/' .. path
  if opts.warn and not vim.uv.fs_stat(ret) then
    Snacks.notify.warn(('Mason package path not found for **%s**:\n- `%s`\nYou may need to force update the package.'):format(pkg, path))
  end
  return ret
end

--- Recursively gets a given node's anscestor of a given type
---@param types string[] will return the first node that matches one of these types
---@param node TSNode? current node
---@return TSNode?
function U.find_node_ancestor(types, node)
  if not node then
    return nil
  end

  if vim.tbl_contains(types, node:type()) then
    return node
  end

  return U.find_node_ancestor(types, node:parent())
end

return U
