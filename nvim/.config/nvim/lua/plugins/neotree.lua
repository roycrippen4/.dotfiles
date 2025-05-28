local function copy_path(state)
  local node = state.tree:get_node()
  local filepath = node:get_id()
  local filename = node.name
  local modify = vim.fn.fnamemodify

  local results = {
    filepath,
    modify(filepath, ':.'),
    modify(filepath, ':~'),
    filename,
    modify(filename, ':r'),
    modify(filename, ':e'),
  }

  vim.ui.select({
    '1. Absolute path: ' .. results[1],
    '2. Path relative to CWD: ' .. results[2],
    '3. Path relative to HOME: ' .. results[3],
    '4. Filename: ' .. results[4],
    '5. Filename without extension: ' .. results[5],
    '6. Extension of the filename: ' .. results[6],
  }, { prompt = 'Choose to copy to clipboard:' }, function(choice)
    if choice then
      local i = tonumber(choice:sub(1, 1))
      if i then
        local result = results[i]
        vim.fn.setreg('+', result)
        vim.notify('Copied: ' .. result)
      else
        vim.notify('Invalid selection')
      end
    else
      vim.notify('Selection cancelled')
    end
  end)
end

local function copy_absolute_path(state)
  local node = state.tree:get_node()
  local filepath = node:get_id()
  vim.fn.setreg('+', filepath)
  vim.notify('Copied absolute path to clipboard')
end

return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons', 'MunifTanjim/nui.nvim' },
  keys = { { '<c-n>', '<cmd> Neotree toggle=true <cr>' } },
  lazy = false,
  ---@module "neo-tree"
  ---@type neotree.Config?
  opts = {
    close_if_last_window = true,
    filesystem = {
      follow_current_file = { enabled = true },
      window = { mappings = { ['/'] = 'noop' } },
    },
    window = {
      mappings = {
        ['Y'] = copy_path,
        ['gy'] = copy_absolute_path,
      },
    },
  },
}
