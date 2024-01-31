local map = vim.keymap.set
local U = require('plugins.local_plugs.utils')

---@class Highlight
---@field bufnr integer
---@field ns_id integer
---@field ext_id integer[]
---@field pos HLPosition

---@class HLPosition
---@field line_start integer Starting row to highlight
---@field line_end   integer Ending row to highlight
---@field col_start integer Starting col to highlight
---@field col_end   integer Ending col to highlight

---@class Highlighter
---@field highlights Highlight[] The list of { bufnr, extmarks } for the highlighter

---@class Highlighter
local M = {
  highlights = {},
}

---@return HLPosition
function M.get_cursor_word_pos()
  log('get_cursor_word_pos() called')
  local word = vim.fn.expand('<cword>')
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local text = vim.api.nvim_get_current_line()
  local col_start, col_end = text:find('%f[%w]' .. word .. '%f[%W]')

  return {
    line_start = row - 1,
    line_end = row,
    col_start = (col_start or col) - 1,
    col_end = (col_end or col),
  }
end

local visual_modes = { 'v', 'V', '' }

---@return HLPosition|HLPosition[]|nil
function M.get_visual_pos()
  local mode = vim.fn.mode()

  if mode == 'V' then
    local curline = vim.fn.line('.')
    local vline = vim.fn.line('v')

    if curline and vline then
      if curline == vline then
        return {
          line_start = curline - 1,
          line_end = curline,
          col_start = 0,
          col_end = -1,
        }
      end
      local positions = {} ---@type HLPosition[]
      local smaller = math.min(curline, vline)
      local bigger = math.max(curline, vline)
      for i = smaller - 1, bigger - 1, 1 do
        table.insert(positions, {
          line_start = i,
          line_end = bigger,
          col_start = 0,
          col_end = -1,
        })
      end
      return positions
    end
  end

  -- if mode == 'v' then
  --   log('standard visual')
  -- end

  -- if mode == '' then
  --   log('block visual')
  -- end

  -- local line_start, col_start = vim.fn.line('.'), vim.fn.col('.')
  -- local line_end, col_end = vim.fn.line('v'), vim.fn.col('v')

  -- if line_start and line_end and col_start and col_end then
  --   return {
  --     line_start = line_start,
  --     line_end = line_end,
  --     col_start = col_start,
  --     col_end = col_end,
  --   }
  -- end

  return nil
end

---@param pos HLPosition|HLPosition[]|nil
function M.highlight(pos)
  if not pos then
    return
  end

  if vim.tbl_contains(visual_modes, vim.fn.mode()) then
    if type(pos[1]) == 'table' then
      for _, hl in ipairs(pos) do
        M.highlight(hl)
      end
      return
    end
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local ns_id = vim.api.nvim_buf_add_highlight(bufnr, 0, 'Search', pos.line_start, pos.col_start, pos.col_end)
  local extmark = vim.api.nvim_buf_get_extmarks(bufnr, ns_id, {
    pos.line_start,
    pos.col_start,
  }, {
    pos.line_end,
    pos.col_end,
  }, {
    type = 'highlight',
  })

  ---@type Highlight
  local hl = {
    bufnr = bufnr,
    ns_id = ns_id,
    pos = {
      line_start = pos.line_start,
      line_end = pos.line_end,
      col_start = pos.col_start,
      col_end = pos.col_end,
    },
    ext_id = extmark,
  }

  table.insert(M.highlights, hl)
end

function M.clear_all()
  log('clearing highlights')
  for _, hl in ipairs(M.highlights) do
    vim.api.nvim_buf_clear_namespace(hl.bufnr, hl.ns_id, hl.pos.line_start, hl.pos.line_end)
  end
end

--- Checks the position tables of the current word under the cursor
--- against all positions in `M.highlights`. If a match is found,
--- we return the `ext_id` and `ns_id` for the highlight from the table.
--- Else we return nil.
---
---@param pos HLPosition
---@param bufnr integer
---@return integer[][]|nil ext_id
---@return integer|nil ns_id
---@return integer|nil idx
function M.has_match(pos, bufnr)
  for i = 1, #M.highlights do
    local hl = M.highlights[i]
    if U.deep_equals(hl.pos, pos) and bufnr == hl.bufnr then
      return hl.ext_id, hl.ns_id, i
    end
  end
  return nil, nil
end

---@return HLPosition|HLPosition[]
function M.get_hl_pos()
  local pos
  local mode = vim.fn.mode()

  if vim.tbl_contains(visual_modes, mode) then
    pos = M.get_visual_pos()
  else
    pos = M.get_cursor_word_pos()
  end

  if not pos then
    error('Highlighter - function M.toggle_hl() - Could not determine visual position.')
  end
  return pos
end

---Toggles highlights on and off
function M.toggle_hl()
  local pos = M.get_hl_pos()

  local bufnr = vim.api.nvim_get_current_buf()
  local ext_table, ns_id, idx = M.has_match(pos, bufnr)
  local ext_id = nil

  if ext_table then
    ext_id = ext_table[1][1]
  end

  if not ext_id or not ns_id or not idx then
    M.highlight(pos)
    return
  else
    vim.api.nvim_buf_del_extmark(bufnr, ns_id, ext_id)
    table.remove(M.highlights, idx)
  end
end

local function set_keymaps()
  map('n', '<C-y>', function()
    M.toggle_hl()
  end, { nowait = true, silent = true, desc = 'Highlights word under the cursor' })

  map('n', '<C-S-Y>', function()
    M.clear_all()
    M.highlights = {}
  end, { nowait = true, silent = true, desc = 'Highlights word under the cursor' })

  map('v', '<C-y>', function()
    M.toggle_hl()
    return '<Esc>'
  end, { nowait = true, silent = true, desc = 'Highlights word under the cursor' })
end

function M.setup()
  log('highlighter setup called')
  set_keymaps()
end

return M
