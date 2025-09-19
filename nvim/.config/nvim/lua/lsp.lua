vim
  .iter({
    DapBreakpoint = { text = '', texthl = 'DapBreakpoint', linehl = '', numhl = '' },
    DapBreakpointCondition = { text = '', texthl = 'DapBreakpointCondition', linehl = '', numhl = '' },
    DapLogPoint = { text = '', texthl = 'DapLogPoint', linehl = '', numhl = '' },
    DapStopped = { text = '', texthl = 'DapStopped', linehl = '', numhl = '' },
    DapBreakpointRejected = { text = '', texthl = 'DapBreakpointRejected', linehl = '', numhl = '' },
  })
  :each(vim.fn.sign_define)

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.HINT] = '󱡴',
      [vim.diagnostic.severity.INFO] = '',
    },
  },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  virtual_text = true,
  float = {
    style = 'minimal',
    source = 'if_many',
    header = 'Diagnostic',
    prefix = '',
  },
})

vim.api.nvim_create_user_command('LspOrganizeImports', function()
  vim.lsp.buf.code_action({
    apply = true,
    context = { only = { 'source.organizeImports' } },
  })
end, { desc = 'Organize imports via LSP' })

vim.api.nvim_create_user_command('LspToggleInlayHints', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }))
  local msg = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }) and 'Lsp inlay hints enabled' or 'Lsp inlay hints disabled'
  vim.notify(msg, vim.log.levels.INFO)
end, { desc = 'Toggle LSP Inaly Hints' })

vim.api.nvim_create_user_command('LspToggleDiagnostics', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = 'Toggle LSP diagnostics' })

local locations_to_items = vim.lsp.util.locations_to_items
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.util.locations_to_items = function(locations, offset_encoding)
  local lines = {}
  local loc_i = 1
  for _, loc in ipairs(vim.deepcopy(locations)) do
    local uri = loc.uri or loc.targetUri
    local range = loc.range or loc.targetSelectionRange
    if lines[uri .. range.start.line] then -- already have a location on this line
      table.remove(locations, loc_i) -- remove from the original list
    else
      loc_i = loc_i + 1
    end
    lines[uri .. range.start.line] = true
  end

  return locations_to_items(locations, offset_encoding)
end

local M = {}

---@param client vim.lsp.Client
---@param bufnr integer,
---@diagnostic disable-next-line: unused-local
function M.on_attach(client, bufnr)
  require('which-key').add({
    {
      mode = 'n',
      { '<leader>lo', '<cmd> LspOrganizeImports <cr>', desc = '[L]SP Organize Imports', icon = '󰶘' },
      { '<leader>lh', '<cmd> LspToggleInlayHints <cr>', desc = '[L]SP Inlay Hints', icon = '󰊠' },
      { '<leader>ld', '<cmd> LspToggleDiagnostics <cr>', desc = '[L]SP Diagnostics', icon = '' },
      { '<leader>r', vim.lsp.buf.rename, desc = 'Refactor', icon = '' },
      { '<leader>la', vim.lsp.buf.code_action, desc = '[L]SP Code Action', icon = '' },
      { '<leader>lf', vim.diagnostic.open_float, desc = '[L]SP Floating Diagnostics', icon = '󰉪' },
      { '<leader>li', '<cmd> LspInfo <cr>', desc = '[L]SP Server Info', icon = '' },
      { '<leader>lR', '<cmd> LspRestart <cr>', desc = '[L]SP Restart Servers', icon = '' },
    },
  })

  vim.lsp.document_color.enable(true, bufnr)
end

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'Configure LSP keymaps',
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- I don't think this can happen but it's a wild world out there.
    if not client then
      return
    end

    M.on_attach(client, args.buf)
  end,
})

vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, { callback = vim.lsp.codelens.refresh })

local hover = vim.lsp.buf.hover
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.hover = function()
  return hover({
    max_height = math.floor(vim.o.lines * 0.5),
    max_width = math.floor(vim.o.columns * 0.4),
  })
end

--- HACK: Override `vim.lsp.util.stylize_markdown` to use Treesitter.
---
---@param bufnr integer
---@param contents string[]
---@param opts table
---@return string[]
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.util.stylize_markdown = function(bufnr, contents, opts)
  contents = vim.lsp.util._normalize_markdown(contents, {
    width = vim.lsp.util._make_floating_popup_size(contents, opts),
  })
  vim.bo[bufnr].filetype = 'markdown'
  vim.treesitter.start(bufnr)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, contents)

  return contents
end

-- Update mappings when registering dynamic capabilities.
local register_capability = vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability]
vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability] = function(err, res, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if not client then
    return
  end

  M.on_attach(client, vim.api.nvim_get_current_buf())

  return register_capability(err, res, ctx)
end

vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
  once = true,
  callback = function()
    local configs = vim
      .iter(vim.api.nvim_get_runtime_file('lsp/*.lua', true))
      :map(function(file)
        return vim.fn.fnamemodify(file, ':t:r')
      end)
      :totable()

    vim.lsp.enable(configs)
  end,
})

return M
