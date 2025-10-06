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

local is_startup = true

---@type LazyPluginSpec
return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons', 'MunifTanjim/nui.nvim' },
  keys = { { '<c-n>', '<cmd> Neotree toggle=true <cr>' } },
  lazy = false,
  ---@module "neo-tree"
  ---@type neotree.Config?
  opts = {
    use_popups_for_input = false,
    close_if_last_window = true,
    default_component_configs = {
      indent = {
        with_expanders = true,
        expander_collapsed = '',
        expander_expanded = '',
        expander_highlight = 'NeoTreeExpander',
      },
    },
    filesystem = {
      bind_to_cwd = false,
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
      window = { mappings = { ['/'] = 'noop' } },
    },
    window = {
      mappings = {
        ['Y'] = copy_path,
        ['gy'] = copy_absolute_path,
      },
    },
    event_handlers = {
      {
        -- open the primary mark if we have marked files
        event = 'neo_tree_window_before_open',
        handler = function()
          local poon = require('poon')

          if is_startup and poon.has_marks() then
            is_startup = false
            vim.cmd.PoonJump()

            vim.schedule(function()
              vim.cmd.wincmd('l')
            end)
          end
        end,
      },
      {
        event = 'file_moved',
        handler = function(data)
          Snacks.rename.on_rename_file(data.source, data.destination)
        end,
      },
      {
        event = 'file_renamed',
        handler = function(data)
          Snacks.rename.on_rename_file(data.source, data.destination)
        end,
      },
    },
  },
}
