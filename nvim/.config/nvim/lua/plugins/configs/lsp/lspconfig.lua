local map = vim.keymap.set
local methods = vim.lsp.protocol.Methods
local M = {}

local diagnostic_status = true
local toggle_diagnostics = function()
  diagnostic_status = not diagnostic_status
  if diagnostic_status then
    vim.api.nvim_echo({ { 'Show diagnostics' } }, false, {})
    vim.diagnostic.enable()
  else
    vim.api.nvim_echo({ { 'Hide diagnostics' } }, false, {})
    vim.diagnostic.disable()
  end
end

---@param chars string[]
local function check_trigger_chars(chars)
  local cur_line = vim.api.nvim_get_current_line()
  local pos = vim.api.nvim_win_get_cursor(0)[2]

  cur_line = cur_line:gsub('%s+', '')

  for _, char in ipairs(chars) do
    if cur_line:sub(pos, pos) == char then
      return true
    end
  end
end

local function toggle_hints()
  vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled(0))
  print('inlay hints: ' .. tostring(vim.lsp.inlay_hint.is_enabled()))
end

M.on_attach = function(client, bufnr)
  map('n', 'gr', require('telescope.builtin').lsp_references, { desc = 'Goto References  ' })
  map('n', 'gi', require('telescope.builtin').lsp_implementations, { desc = 'Goto Implementation 󰡱 ' })
  map('n', 'gd', require('telescope.builtin').lsp_definitions, { desc = 'Goto Definition 󰼭 ' })
  map('n', '<leader>la', vim.lsp.buf.code_action, { desc = 'Code Action  ' })
  map('n', '<leader>ld', toggle_diagnostics, { desc = 'Toggle Diagnostics 󰨚 ' })
  map('n', '<leader>lf', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message 󰉪 ' })
  map('n', '<leader>lh', toggle_hints, { desc = 'Toggle lsp inlay hints 󰊠 ' })
  map('n', '<leader>li', '<cmd> LspInfo<CR>', { desc = 'Show Lsp Info  ' })
  map('n', '<leader>lR', '<cmd> LspRestart<CR>', { desc = 'Restart language servers  ' })
  map('n', '<leader>r', require('plugins.local.renamer').open, { desc = 'LSP Rename 󰑕 ' })

  if client.name == 'svelte' then
    vim.api.nvim_create_autocmd('BufWritePost', {
      group = vim.api.nvim_create_augroup('svelte_ondidchangetsorjsfile', { clear = true }),
      pattern = { '*.js', '*.ts' },
      callback = function(ctx)
        client.notify('$/onDidChangeTsOrJsFile', { uri = ctx.match })
      end,
    })
  end

  if client.server_capabilities.signatureHelpProvider then
    local group = vim.api.nvim_create_augroup('LspSignature', { clear = false })
    vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })

    vim.api.nvim_create_autocmd('TextChangedI', {
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

local cwd = vim.fn.getcwd(-1, -1)
if cwd ~= nil then
  if string.sub(cwd, -4) == 'nvim' then
    require('neodev').setup()
  end
end

-- Override the virtual text diagnostic handler so that the most severe diagnostic is shown first.
local show_handler = vim.diagnostic.handlers.virtual_text.show
assert(show_handler)
local hide_handler = vim.diagnostic.handlers.virtual_text.hide
vim.diagnostic.handlers.virtual_text = {
  show = function(ns, bufnr, diagnostics, opts)
    table.sort(diagnostics, function(diag1, diag2)
      return diag1.severity > diag2.severity
    end)
    return show_handler(ns, bufnr, diagnostics, opts)
  end,
  hide = hide_handler,
}

local md_namespace = vim.api.nvim_create_namespace('lsp_float')

--- Adds extra inline highlights to the given buffer.
---@param buf integer
local function add_inline_highlights(buf)
  for l, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    for pattern, hl_group in pairs({
      ['@%S+'] = '@parameter',
      ['^%s*(Parameters:)'] = '@text.title',
      ['^%s*(Return:)'] = '@text.title',
      ['^%s*(See also:)'] = '@text.title',
      ['{%S-}'] = '@parameter',
      ['|%S-|'] = '@text.reference',
    }) do
      local from = 1 ---@type integer?
      while from do
        local to
        from, to = line:find(pattern, from)
        if from then
          vim.api.nvim_buf_set_extmark(buf, md_namespace, l - 1, from - 1, {
            end_col = to,
            hl_group = hl_group,
          })
        end
        from = to and to + 1 or nil
      end
    end
  end
end

--- LSP handler that adds extra inline highlights, keymaps, and window options.
--- Code inspired from `noice`.
---@param handler fun(err: any, result: any, ctx: any, config: any): integer?, integer?
---@param focusable boolean
---@return fun(err: any, result: any, ctx: any, config: any)
local function enhanced_float_handler(handler, focusable)
  local limit = vim.o.lines * 0.5
  return function(err, result, ctx, config)
    local bufnr, winnr = handler(
      err,
      result,
      ctx,
      vim.tbl_deep_extend('force', config or {}, {
        border = 'rounded',
        focusable = focusable,
        max_height = math.floor(limit),
        max_width = math.floor(vim.o.columns * 0.4),
      })
    )

    if not bufnr or not winnr then
      return
    end

    -- Conceal everything.
    vim.wo[winnr].concealcursor = 'n'

    -- Extra highlights.
    add_inline_highlights(bufnr)

    -- Add keymaps for opening links.
    if focusable and not vim.b[bufnr].markdown_keys then
      vim.keymap.set('n', 'K', function()
        -- Vim help links.
        local url = (vim.fn.expand('<cWORD>') --[[@as string]]):match('|(%S-)|')
        if url then
          return vim.cmd.help(url)
        end

        -- Markdown links.
        local col = vim.api.nvim_win_get_cursor(0)[2] + 1
        local from, to
        from, to, url = vim.api.nvim_get_current_line():find('%[.-%]%((%S-)%)')
        if from and col >= from and col <= to then
          vim.system({ 'open', url }, nil, function(res)
            if res.code ~= 0 then
              vim.notify('Failed to open URL' .. url, vim.log.levels.ERROR)
            end
          end)
        end
      end, { buffer = bufnr, silent = true })
      vim.b[bufnr].markdown_keys = true
    end
  end
end

vim.lsp.handlers[methods.textDocument_hover] = enhanced_float_handler(vim.lsp.handlers.hover, true)
vim.lsp.handlers[methods.textDocument_signatureHelp] = enhanced_float_handler(vim.lsp.handlers.signature_help, false)

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

  add_inline_highlights(bufnr)

  return contents
end

return M
