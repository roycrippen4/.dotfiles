local del = vim.keymap.del
local map = vim.keymap.set

---@type LazyPluginSpec
return {
  'nvim-tree/nvim-tree.lua', -- https://github.com/nvim-tree/nvim-tree.lua
  config = function()
    require('nvim-tree').setup({
      ---@param bufnr integer
      on_attach = function(bufnr)
        require('nvim-tree.api').config.mappings.default_on_attach(bufnr)
        local opts = { buffer = bufnr, noremap = true, silent = true, nowait = true }
        del('n', '<C-]>', { buffer = bufnr })
        del('n', '<C-t>', { buffer = bufnr })
        del('n', '<C-e>', { buffer = bufnr })
        del('n', '.', { buffer = bufnr })
        del('n', '-', { buffer = bufnr })
        del('n', 'g?', { buffer = bufnr })
        del('n', 'f', { buffer = bufnr })
        map('n', '.', require('nvim-tree.api').tree.change_root_to_node, opts)
        map('n', '?', require('nvim-tree.api').tree.toggle_help, opts)
      end,
      filters = { dotfiles = false, exclude = { vim.fn.stdpath('config') .. '/lua/custom' } },
      disable_netrw = true,
      hijack_netrw = true,
      hijack_cursor = true,
      hijack_unnamed_buffer_when_opening = false,
      sync_root_with_cwd = true,
      update_focused_file = { enable = true, update_root = false },
      view = {
        signcolumn = 'auto',
        adaptive_size = true,
        side = 'left',
        width = 10,
        preserve_window_proportions = true,
      },
      git = { enable = true, ignore = true },
      filesystem_watchers = { enable = true },
      actions = { open_file = { resize_window = true, eject = true } },
      renderer = {
        root_folder_label = function(path) ---@param path string
          return './' .. vim.fn.fnamemodify(path, ':t')
        end,
        highlight_git = true,
        highlight_opened_files = 'name',
        highlight_bookmarks = 'all',
        indent_markers = { enable = true },
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
