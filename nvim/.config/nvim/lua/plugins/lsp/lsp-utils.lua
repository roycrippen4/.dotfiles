local api = vim.api
local augroup = api.nvim_create_augroup
local autocmd = api.nvim_create_autocmd
local clear_autocmds = api.nvim_clear_autocmds
local lsp = vim.lsp
local map = vim.keymap.set

local M = {}

local diagnostic_status = true
local function toggle_diagnostics()
  diagnostic_status = not diagnostic_status
  if diagnostic_status then
    api.nvim_echo({ { 'Show diagnostics' } }, false, {})
    vim.diagnostic.enable()
  else
    api.nvim_echo({ { 'Hide diagnostics' } }, false, {})
    vim.diagnostic.enable(false)
  end
end

local function toggle_inlay_hints()
  lsp.inlay_hint.enable(not lsp.inlay_hint.is_enabled(0))
  print('inlay hints: ' .. tostring(lsp.inlay_hint.is_enabled()))
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
---@param client table
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

---@param client table
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

--- Sets basic LSP mappings
function M.set_lsp_mappings()
  map('n', 'gr', require('telescope.builtin').lsp_references, { desc = 'Goto References  ' })
  map('n', 'gi', require('telescope.builtin').lsp_implementations, { desc = 'Goto Implementation 󰡱 ' })
  map('n', 'gd', require('telescope.builtin').lsp_definitions, { desc = 'Goto Definition 󰼭 ' })
  map('n', '<leader>la', lsp.buf.code_action, { desc = 'Code Action  ' })
  map('n', '<leader>ld', toggle_diagnostics, { desc = 'Toggle Diagnostics 󰨚 ' })
  map('n', '<leader>lf', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message 󰉪 ' })
  map('n', '<leader>lh', toggle_inlay_hints, { desc = 'Toggle lsp inlay hints 󰊠 ' })
  map('n', '<leader>li', '<cmd> LspInfo<CR>', { desc = 'Show Lsp Info  ' })
  map('n', '<leader>lR', '<cmd> LspRestart<CR>', { desc = 'Restart language servers  ' })
  map('n', '<leader>r', vim.lsp.buf.rename, { desc = 'LSP Rename 󰑕 ' })
end

---@param client table
---@param bufnr integer
function M.on_attach(client, bufnr)
  M.set_lsp_mappings()
  svelte_change_check(client)
  setup_signature_helper(bufnr, client)
end

M.capabilities = lsp.protocol.make_client_capabilities()
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

return M
