---@type LazyPluginSpec
return {
  'nvim-tree/nvim-tree.lua', -- https://github.com/nvim-tree/nvim-tree.lua
  lazy = false,
  config = function()
    local api = require('nvim-tree.api')

    local Event = api.events.Event
    api.events.subscribe(Event.TreeOpen, function()
      if api.tree.is_visible() then
        local bufnr = vim.api.nvim_get_current_buf()
        if api.tree.is_tree_buf(bufnr) and vim.api.nvim_buf_is_valid(bufnr) then
          vim.opt_local.scrolloff = 0
        end
      end
    end)

    api.events.subscribe(Event.Resize, function()
      local bufnr = vim.api.nvim_get_current_buf()
      if api.tree.is_tree_buf(bufnr) and vim.api.nvim_buf_is_valid(bufnr) then
        vim.opt_local.scrolloff = 0
      end
    end)

    require('nvim-tree').setup({
      on_attach = function(bufnr) ---@param bufnr integer
        require('nvim-tree.api').config.mappings.default_on_attach(bufnr)

        vim.keymap.del('n', '<C-]>', { buffer = bufnr })
        vim.keymap.del('n', '<C-t>', { buffer = bufnr })
        vim.keymap.del('n', '<C-e>', { buffer = bufnr })
        vim.keymap.del('n', '.', { buffer = bufnr })
        vim.keymap.del('n', '-', { buffer = bufnr })
        vim.keymap.del('n', 'g?', { buffer = bufnr })
        vim.keymap.del('n', 'f', { buffer = bufnr })

        vim.keymap.set(
          'n',
          '.',
          require('nvim-tree.api').tree.change_root_to_node,
          { desc = 'CD', buffer = bufnr, noremap = true, silent = true, nowait = true }
        )
        vim.keymap.set(
          'n',
          '?',
          require('nvim-tree.api').tree.toggle_help,
          { desc = 'Help', buffer = bufnr, noremap = true, silent = true, nowait = true }
        )
      end,
      filters = {
        dotfiles = false,
        exclude = { vim.fn.stdpath('config') .. '/lua/custom' },
      },
      disable_netrw = true,
      hijack_netrw = true,
      hijack_cursor = true,
      hijack_unnamed_buffer_when_opening = false,
      sync_root_with_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = false,
      },
      view = {
        signcolumn = 'auto',
        adaptive_size = true,
        side = 'left',
        width = 10,
        preserve_window_proportions = true,
      },
      git = {
        enable = true,
        ignore = true,
      },
      filesystem_watchers = {
        enable = true,
      },
      actions = {
        open_file = {
          resize_window = true,
          eject = true,
        },
      },
      renderer = {
        root_folder_label = function(path) ---@param path string
          return './' .. vim.fn.fnamemodify(path, ':t')
        end,
        highlight_git = true,
        highlight_opened_files = 'name',
        highlight_bookmarks = 'all',

        indent_markers = {
          enable = true,
        },

        icons = {
          bookmarks_placement = 'signcolumn',
          show = {
            bookmarks = true,
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
    })
  end,
}
