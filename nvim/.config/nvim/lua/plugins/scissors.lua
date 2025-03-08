---@class SnacksObj: snacks.picker.Item
---@field snippet Scissors.SnippetObj
---@field display_name string

local function add_snippet()
  require('scissors').addNewSnippet()
end

---@return SnacksObj[]?
local function make_items()
  local convert = require('scissors.vscode-format.convert-object')
  local ft = vim.bo.filetype
  local all_snippets = {} ---@type Scissors.SnippetObj[]
  for _, absPath in pairs(convert.getSnippetfilePathsForFt(ft)) do
    local filetypeSnippets = convert.readVscodeSnippetFile(absPath, ft)
    vim.list_extend(all_snippets, filetypeSnippets)
  end
  for _, absPath in pairs(convert.getSnippetfilePathsForFt('all')) do
    local globalSnippets = convert.readVscodeSnippetFile(absPath, 'plaintext')
    vim.list_extend(all_snippets, globalSnippets)
  end

  -- GUARD
  if #all_snippets == 0 then
    vim.notify('No snippets found for filetype: ' .. ft, 'warn')
    return
  end

  local items = {}
  for i, snip in ipairs(all_snippets) do
    local filename = vim.fs.basename(snip.fullPath):gsub('%.json$', '')
    local display_name = require('scissors.utils').snipDisplayName(snip)
    local name = display_name .. '\t' .. filename

    table.insert(items, {
      idx = i,
      score = i,
      text = display_name .. ' ' .. table.concat(snip.body, '\n'),
      name = name,
      snippet = snip,
      display_name = display_name,
    })

    table.sort(items, function(a, b)
      return a.name < b.name
    end)
  end

  return items
end

local function edit_snippet()
  local icon = require('scissors.config').config.icons.scissors
  local prompt = vim.trim(icon .. ' Select Snippet: '):gsub(': ?$', ' ')
  return Snacks.picker({
    prompt = prompt,
    items = make_items(),
    ---@param item SnacksObj
    format = function(item, _)
      local ret = {}
      ret[#ret + 1] = { item.display_name, 'SnacksPickerFile' }
      ret[#ret + 1] = { ' ' }
      ret[#ret + 1] = { '[' .. item.snippet.filetype .. ']', '@comment' }
      return ret
    end,
    preview = function(ctx)
      local snip = ctx.item.snippet
      local bufnr = ctx.buf
      vim.bo[bufnr].modifiable = true
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, snip.body)

      vim.bo[bufnr].filetype = snip.filetype
      vim.defer_fn(function()
        require('scissors.utils').tokenHighlight(bufnr)
      end, 1)
    end,

    ---@param item SnacksObj,
    confirm = function(picker, item)
      picker:close()
      if item then
        require('scissors.3-edit-popup').editInPopup(item.snippet, 'update')
      end
    end,
  })
end

-- Snacks.picker['snippets'] = edit_snippet

---@type LazyPluginSpec
return {
  'chrisgrieser/nvim-scissors', -- https://github.com/chrisgrieser/nvim-scissors
  opts = { snippetDir = vim.fn.stdpath('config') .. '/snippets' },
  keys = {
    { mode = { 'n', 'x' }, '<leader>sa', add_snippet, desc = '[A]dd snippet' },
    { mode = 'n', '<leader>se', edit_snippet, desc = '[S]cissors [e]dit snippet' },
  },
}
