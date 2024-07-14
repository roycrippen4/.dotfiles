local api = vim.api
local augroup = api.nvim_create_augroup
local autocmd = api.nvim_create_autocmd
local clear_autocmds = api.nvim_clear_autocmds
local builtin = require('telescope.builtin')
local wk = require('which-key')

local M = {}

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

local function organize_imports()
  ---@diagnostic disable-next-line
  vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
end

-- local function goto_definition()
--   vim.lsp.buf.definition({ reuse_win = false })
-- end

---@param additional_keymaps? wk.Mapping[]
function M.set_lsp_mappings(additional_keymaps)
  local keymaps = {
    -- stylua: ignore start
    mode = 'n',
    { 'gr', builtin.lsp_references,            desc = 'Goto References',            icon = '' },
    { 'gd', vim.lsp.buf.definition,            desc = 'Goto Definition',            icon = '󰼭' },
    { 'gi', builtin.lsp_implementations,       desc = 'Goto Implementation',        icon = '󰡱' },
    { '<leader>li', organize_imports,          desc = '[L]SP Organize Imports',     icon = '󰶘' },
    { '<leader>lh', toggle_inlay_hints,        desc = '[L]SP Inlay Hints',          icon = '󰊠' },
    { '<leader>ld', toggle_diagnostics,        desc = '[L]SP Diagnostics',                     },
    { '<leader>r',  vim.lsp.buf.rename,        desc = 'Refactor',                   icon = '' },
    { '<leader>la', vim.lsp.buf.code_action,   desc = '[L]SP Code Action',          icon = '' },
    { '<leader>lf', vim.diagnostic.open_float, desc = '[L]SP Floating Diagnostics', icon = '󰉪' },
    { '<leader>li', '<cmd> LspInfo <cr>',      desc = '[L]SP Server Info',          icon = '' },
    { '<leader>li', '<cmd> LspRestart <cr>',   desc = '[L]SP Restart Servers',      icon = '' },
    -- stylua: ignore end
  }

  keymaps = vim.tbl_deep_extend('force', keymaps, additional_keymaps or {})

  wk.add({ keymaps })
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

return M
