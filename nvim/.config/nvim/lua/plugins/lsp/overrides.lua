local api = vim.api
local fn = vim.fn
local map = vim.keymap.set
local ms = vim.lsp.protocol.Methods
local md_namespace = api.nvim_create_namespace('lsp_float')

--- Returns the height of the buffer in the window
---@param winnr integer
---@return integer
local function win_buf_height(winnr)
  local buf = api.nvim_win_get_buf(winnr)

  if not vim.wo[winnr].wrap then
    return api.nvim_buf_line_count(buf)
  end

  local width = api.nvim_win_get_width(winnr)
  local lines = api.nvim_buf_get_lines(buf, 0, -1, false)
  local height = 0
  for _, l in ipairs(lines) do
    height = height + math.max(1, (math.ceil(vim.fn.strwidth(l) / width)))
  end
  return height
end

--- Scrolls the window by delta lines
---@param winnr integer
---@param delta integer
local function scroll(winnr, delta)
  local info = vim.fn.getwininfo(winnr)[1] or {}
  local top = info.topline or 1
  local buf = api.nvim_win_get_buf(winnr)
  top = top + delta
  top = math.max(top, 1)
  top = math.min(top, win_buf_height(winnr) - info.height + 1)

  vim.defer_fn(function()
    api.nvim_buf_call(buf, function()
      api.nvim_command('noautocmd silent! normal! ' .. top .. 'zt')
      api.nvim_exec_autocmds('WinScrolled', { modeline = false })
    end)
  end, 0)
end

--- Adds extra inline highlights to the given buffer.
---@param buf integer
local function add_inline_highlights(buf)
  for l, line in ipairs(api.nvim_buf_get_lines(buf, 0, -1, false)) do
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
          api.nvim_buf_set_extmark(buf, md_namespace, l - 1, from - 1, {
            end_col = to,
            hl_group = hl_group,
          })
        end
        from = to and to + 1 or nil
      end
    end
  end
end

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

--- LSP handler that adds extra inline highlights, keymaps, and window options.
--- Code inspired from `noice`.
---@param handler fun(err: any, result: any, ctx: any, config: any): integer?, integer?
---@param focusable boolean
---@return fun(err: any, result: any, ctx: any, config: any)
local function enhanced_float_handler(handler, focusable)
  local limit = vim.o.lines * 0.3
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

    add_inline_highlights(bufnr)
    vim.wo[winnr].concealcursor = 'n'
    vim.wo[winnr].scrolloff = 0

    -- stylua: ignore start
    map({ 'n', 'i' }, '<C-S-N>', function() scroll(winnr, 4) end, { buffer = true })
    map({ 'n', 'i' }, '<C-S-P>', function() scroll(winnr, -4) end, { buffer = true })
    -- stylua: ignore end

    if focusable and not vim.b[bufnr].markdown_keys then
      map('n', 'K', function()
        local url = (fn.expand('<cWORD>') --[[@as string]]):match('|(%S-)|')
        if url then
          return vim.cmd.help(url)
        end

        local col = api.nvim_win_get_cursor(0)[2] + 1
        local from, to
        from, to, url = api.nvim_get_current_line():find('%[.-%]%((%S-)%)')
        if from and col >= from and col <= to then
          vim.system({ 'xdg-open', url }, nil, function(res)
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

vim.lsp.handlers[ms.textDocument_hover] = enhanced_float_handler(vim.lsp.handlers.hover, true)
vim.lsp.handlers[ms.textDocument_signatureHelp] = enhanced_float_handler(vim.lsp.handlers.signature_help, false)

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
  api.nvim_buf_set_lines(bufnr, 0, -1, false, contents)

  add_inline_highlights(bufnr)

  return contents
end
