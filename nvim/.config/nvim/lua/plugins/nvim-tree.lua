local prev = { new_name = '', old_name = '' } -- Prevents duplicate events
vim.api.nvim_create_autocmd('User', {
  pattern = 'NvimTreeSetup',
  callback = function()
    local events = require('nvim-tree.api').events
    events.subscribe(events.Event.NodeRenamed, function(data)
      if prev.new_name ~= data.new_name or prev.old_name ~= data.old_name then
        prev = data
        Snacks.rename.on_rename_file(data.old_name, data.new_name)
      end
    end)
  end,
})

---@type LazyPluginSpec
return {
  'nvim-tree/nvim-tree.lua', -- https://github.com/nvim-tree/nvim-tree.lua
  event = 'VeryLazy',
  opts = {
    ---@param bufnr integer
    on_attach = function(bufnr)
      local api = require('nvim-tree.api')
      api.config.mappings.default_on_attach(bufnr)

      vim.keymap.del('n', '<C-]>', { buffer = bufnr })
      vim.keymap.del('n', '<C-t>', { buffer = bufnr })
      vim.keymap.del('n', '<C-e>', { buffer = bufnr })
      vim.keymap.del('n', '.', { buffer = bufnr })
      vim.keymap.del('n', '-', { buffer = bufnr })
      vim.keymap.del('n', 'g?', { buffer = bufnr })
      vim.keymap.del('n', 'f', { buffer = bufnr })
      vim.keymap.del('n', 'I', { buffer = bufnr })

      ---@param desc string keymap description
      ---@return vim.keymap.set.Opts
      local opts = function(desc)
        return { buffer = bufnr, noremap = true, silent = true, nowait = true, desc = desc }
      end

      vim.keymap.set('n', '.', api.tree.change_root_to_node, opts('Change root to node'))
      vim.keymap.set('n', '?', api.tree.toggle_help, opts('Toggle help'))
      vim.keymap.set('n', 'K', api.node.show_info_popup, opts('Show info popup'))
      vim.keymap.set('n', 'I', api.tree.toggle_enable_filters, opts('Toggle gitignore and custom filters'))
    end,
    filters = {
      dotfiles = false,
      exclude = { vim.fn.stdpath('config') .. '/lua/custom' },
      custom = { '.git' },
    },
    disable_netrw = true,
    hijack_netrw = true,
    hijack_cursor = true,
    hijack_unnamed_buffer_when_opening = false,
    sync_root_with_cwd = true,
    update_focused_file = { enable = true, update_root = false },
    notify = { threshold = vim.log.levels.WARN },
    view = {
      signcolumn = 'auto',
      adaptive_size = true,
      side = 'left',
      width = 10,
      preserve_window_proportions = true,
    },
    git = { enable = true, ignore = true },
    filesystem_watchers = { enable = true },
    actions = {
      open_file = { resize_window = true, eject = true },
      file_popup = { open_win_config = { border = 'rounded' } },
    },
    renderer = {
      root_folder_label = function(path) ---@param path string
        return './' .. vim.fn.fnamemodify(path, ':t')
      end,
      highlight_git = true,
      highlight_opened_files = 'name',
      highlight_bookmarks = 'all',
      indent_markers = { enable = true },
      icons = {
        show = {
          bookmarks = false,
          file = true,
          folder = true,
          folder_arrow = true,
          git = true,
        },
        glyphs = {
          default = '󰈚',
          symlink = '',
          folder = {
            default = '',
            empty = '',
            empty_open = '',
            open = '',
            symlink = '',
            symlink_open = '',
            arrow_open = '',
            arrow_closed = '',
          },
          git = {
            unstaged = '✗',
            staged = '✓',
            unmerged = '',
            renamed = '➜',
            untracked = '★',
            deleted = '',
            ignored = '◌',
          },
        },
      },
    },
  },
}
