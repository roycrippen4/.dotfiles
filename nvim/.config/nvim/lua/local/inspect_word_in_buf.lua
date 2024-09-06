local api = vim.api

local ns = api.nvim_create_namespace('inspect_word')

---@param inspect_info InspectInfo
---@return FormattedLine[]
local function format_inspect_info(inspect_info)
  ---@type FormattedLine[]
  local result = {}
  local idx = 1

  ---@param ... FormattedLinePart
  local function insert(...)
    local parts = { ... }
    result[idx] = result[idx] or {}

    for _, part in ipairs(parts) do
      table.insert(result[idx], part)
    end
  end

  local function newline()
    table.insert(result, {})
    idx = idx + 1
  end

  if #vim.tbl_keys(inspect_info.treesitter) > 0 then
    insert({ text = 'Treesitter', col_start = 0, col_end = 9, hl_group = '@function.call.lua' })

    for _, entry in ipairs(inspect_info.treesitter) do
      newline()
      local hl_group = {
        text = '  - ' .. entry.hl_group,
        col_start = 4,
        col_end = #entry.hl_group + 4,
        hl_group = entry.hl_group,
      }
      local links_to = {
        text = ' links to ',
        col_start = hl_group.col_end,
        col_end = hl_group.col_end + #' links to ',
        hl_group = '@function.call.lua',
      }
      local hl_link = {
        text = entry.hl_group_link,
        col_start = links_to.col_end,
        col_end = #entry.hl_group_link + links_to.col_end,
        hl_group = entry.hl_group_link,
      }
      local lang = {
        text = ' ' .. entry.lang,
        col_start = hl_link.col_end,
        col_end = #entry.lang + hl_link.col_end,
        hl_group = '@comment',
      }
      insert(hl_group, links_to, hl_link, lang)
    end

    newline()
  end

  if #vim.tbl_keys(inspect_info.semantic_tokens) > 0 then
    newline()
    insert({ text = 'Semantic Tokens', col_start = 0, col_end = 15, hl_group = '@function.lua' })

    for _, entry in ipairs(inspect_info.semantic_tokens) do
      newline()
      local hl_group = {
        text = '  - ' .. entry.opts.hl_group,
        col_start = 4,
        col_end = #entry.opts.hl_group + 4,
        hl_group = entry.opts.hl_group,
      }
      local links_to = {
        text = ' links to ',
        col_start = hl_group.col_end,
        col_end = hl_group.col_end + #' links to ',
        hl_group = '@function.call.lua',
      }
      local hl_link = {
        text = entry.opts.hl_group_link,
        col_start = links_to.col_end,
        col_end = #entry.opts.hl_group_link + links_to.col_end,
        hl_group = entry.opts.hl_group_link,
      }
      local priority_str = ' priority: ' .. entry.opts.priority
      local priority = {
        text = priority_str,
        col_start = hl_link.col_end,
        col_end = #priority_str + hl_link.col_end,
        hl_group = '@comment',
      }
      insert(hl_group, links_to, hl_link, priority)
    end

    newline()
  end

  if #vim.tbl_keys(inspect_info.extmarks) > 0 then
    newline()
    insert({ text = 'Extmarks', col_start = 0, col_end = 8, hl_group = '@function.lua' })

    for _, entry in ipairs(inspect_info.extmarks) do
      newline()
      insert({
        text = '  - ' .. entry.opts.hl_group,
        col_start = 4,
        col_end = #entry.opts.hl_group + 4,
        hl_group = entry.opts.hl_group,
      })

      if #entry.ns ~= 0 then
        insert({
          text = ' ' .. entry.ns,
          col_start = #entry.opts.hl_group + 4,
          col_end = #entry.opts.hl_group + 4 + #entry.ns,
          hl_group = '@comment',
        })
      end
    end

    newline()
  end

  if #result > 0 then
    newline()
  end

  return result
end

---@param info FormattedLine[]
---@param buf integer
local function set_lines(info, buf)
  if #info == 0 then
    return
  end

  ---@param acc string
  ---@param part FormattedLinePart
  local concatenate = function(acc, part)
    return acc .. part.text
  end

  ---@param idx integer
  ---@param parts FormattedLine
  local insert_lines = function(idx, parts)
    local it = vim.iter(parts)
    api.nvim_buf_set_lines(buf, idx - 1, idx, false, { it:fold('', concatenate) })

    it:each(
      ---@param part FormattedLinePart
      function(part)
        api.nvim_buf_set_extmark(buf, ns, idx - 1, part.col_start, {
          end_row = idx - 1,
          end_col = part.col_end + 1,
          hl_group = part.hl_group,
          strict = false,
        })
      end
    )
  end

  vim.iter(ipairs(info)):each(insert_lines)
end

return function()
  local pos = api.nvim_win_get_cursor(0)
  local _info = vim.inspect_pos(0, pos[1] - 1, pos[2])
  local info = format_inspect_info(_info)

  if #info == 0 then
    vim.notify('No information found', vim.log.levels.WARN)
    return
  end

  local buf = api.nvim_create_buf(false, true)
  set_lines(info, buf)
  vim.cmd('botright split')
  vim.cmd('set nonumber')
  vim.cmd('set norelativenumber')
  api.nvim_win_set_buf(0, buf)
  api.nvim_win_set_height(0, #info)
  api.nvim_set_option_value('foldcolumn', '0', { win = 0 })
  local quit = '<cmd>q<cr><c-w>l'

  vim.keymap.set('n', 'q', quit, { buffer = buf })
  api.nvim_buf_set_extmark(buf, ns, #info - 1, 0, {
    virt_text = { { 'q', '@keyword' }, { ' - Exit the window' } },
  })
end
