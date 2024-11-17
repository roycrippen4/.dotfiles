---@module 'neo-tree'

---@type LazyPluginSpec
return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
    {
      's1n7ax/nvim-window-picker',
      version = '2.*',
      config = function()
        require('window-picker').setup({
          filter_rules = {
            include_current_win = false,
            autoselect_one = true,
            bo = {
              filetype = { 'neo-tree', 'neo-tree-popup', 'notify' },
              buftype = { 'terminal', 'quickfix' },
            },
          },
        })
      end,
    },
  },
  opts = {
    auto_clean_after_session_restore = true, -- Automatically clean up broken neo-tree buffers saved in sessions
    close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
    enable_cursor_hijack = true, -- If enabled neotree will keep the cursor on the first letter of the filename when moving in the tree.
    open_files_in_last_window = true, -- false = open files in top left window
    open_files_do_not_replace_types = { 'terminal', 'Trouble', 'qf', 'edgy', 'lazy' }, -- when opening files, do not use windows containing these filetypes or buftypes
    --                           -- NOTE: this will speed up to 50 ms for 1 second following a resize
    sort_case_insensitive = false, -- used when sorting files and directories in the tree
    sort_function = nil, -- uses a custom function for sorting files and directories in the tree
    use_popups_for_input = true, -- If false, inputs will use vim.ui.input() instead of custom floats.
    use_default_mappings = true,
    -- source_selector provides clickable tabs to switch between sources.
    source_selector = {
      winbar = false, -- toggle to show selector on winbar
      statusline = false, -- toggle to show selector on statusline
      show_scrolled_off_parent_node = false, -- this will replace the tabs with the parent path
      -- of the top visible node when scrolled down.
      sources = {
        { source = 'filesystem' },
        { source = 'buffers' },
        { source = 'git_status' },
      },
      content_layout = 'start', -- only with `tabs_layout` = "equal", "focus"
      --                start  : |/ 󰓩 bufname     \/...
      --                end    : |/     󰓩 bufname \/...
      --                center : |/   󰓩 bufname   \/...
      tabs_layout = 'equal', -- start, end, center, equal, focus
      --             start  : |/  a  \/  b  \/  c  \            |
      --             end    : |            /  a  \/  b  \/  c  \|
      --             center : |      /  a  \/  b  \/  c  \      |
      --             equal  : |/    a    \/    b    \/    c    \|
      --             active : |/  focused tab    \/  b  \/  c  \|
      truncation_character = '…', -- character to use when truncating the tab label
      tabs_min_width = nil, -- nil | int: if int padding is added based on `content_layout`
      tabs_max_width = nil, -- this will truncate text even if `text_trunc_to_fit = false`
      padding = 0, -- can be int or table
      -- padding = { left = 2, right = 0 },
      -- separator = "▕", -- can be string or table, see below
      separator = { left = '▏', right = '▕' },
      -- separator = { left = "/", right = "\\", override = nil },     -- |/  a  \/  b  \/  c  \...
      -- separator = { left = "/", right = "\\", override = "right" }, -- |/  a  \  b  \  c  \...
      -- separator = { left = "/", right = "\\", override = "left" },  -- |/  a  /  b  /  c  /...
      -- separator = { left = "/", right = "\\", override = "active" },-- |/  a  / b:active \  c  \...
      -- separator = "|",                                              -- ||  a  |  b  |  c  |...
      separator_active = nil, -- set separators around the active tab. nil falls back to `source_selector.separator`
      show_separator_on_edge = false,
      --                       true  : |/    a    \/    b    \/    c    \|
      --                       false : |     a    \/    b    \/    c     |
      highlight_tab = 'NeoTreeTabInactive',
      highlight_tab_active = 'NeoTreeTabActive',
      highlight_background = 'NeoTreeTabInactive',
      highlight_separator = 'NeoTreeTabSeparatorInactive',
      highlight_separator_active = 'NeoTreeTabSeparatorActive',
    },
    --
    --event_handlers = {
    --  {
    --    event = "before_render",
    --    handler = function (state)
    --      -- add something to the state that can be used by custom components
    --    end
    --  },
    --  {
    --    event = "file_opened",
    --    handler = function(file_path)
    --      --auto close
    --      require("neo-tree.command").execute({ action = "close" })
    --    end
    --  },
    --  {
    --    event = "file_opened",
    --    handler = function(file_path)
    --      --clear search after opening a file
    --      require("neo-tree.sources.filesystem").reset_search()
    --    end
    --  },
    --  {
    --    event = "file_renamed",
    --    handler = function(args)
    --      -- fix references to file
    --      print(args.source, " renamed to ", args.destination)
    --    end
    --  },
    --  {
    --    event = "file_moved",
    --    handler = function(args)
    --      -- fix references to file
    --      print(args.source, " moved to ", args.destination)
    --    end
    --  },
    --  {
    --    event = "neo_tree_buffer_enter",
    --    handler = function()
    --      vim.cmd 'highlight! Cursor blend=100'
    --    end
    --  },
    --  {
    --    event = "neo_tree_buffer_leave",
    --    handler = function()
    --      vim.cmd 'highlight! Cursor guibg=#5f87af blend=0'
    --    end
    --  },
    -- {
    --   event = "neo_tree_window_before_open",
    --   handler = function(args)
    --     print("neo_tree_window_before_open", vim.inspect(args))
    --   end
    -- },
    -- {
    --   event = "neo_tree_window_after_open",
    --   handler = function(args)
    --     vim.cmd("wincmd =")
    --   end
    -- },
    -- {
    --   event = "neo_tree_window_before_close",
    --   handler = function(args)
    --     print("neo_tree_window_before_close", vim.inspect(args))
    --   end
    -- },
    -- {
    --   event = "neo_tree_window_after_close",
    --   handler = function(args)
    --     vim.cmd("wincmd =")
    --   end
    -- }
    --},
    default_component_configs = {
      container = {
        enable_character_fade = true,
        width = '100%',
        right_padding = 0,
      },
      --diagnostics = {
      --  symbols = {
      --    hint = "H",
      --    info = "I",
      --    warn = "!",
      --    error = "X",
      --  },
      --  highlights = {
      --    hint = "DiagnosticSignHint",
      --    info = "DiagnosticSignInfo",
      --    warn = "DiagnosticSignWarn",
      --    error = "DiagnosticSignError",
      --  },
      --},
      indent = {
        indent_size = 2,
        padding = 1,
        -- indent guides
        with_markers = true,
        indent_marker = '│',
        last_indent_marker = '└',
        highlight = 'NeoTreeIndentMarker',
        -- expander config, needed for nesting files
        with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
        expander_collapsed = '',
        expander_expanded = '',
        expander_highlight = 'NeoTreeExpander',
      },
      icon = {
        folder_closed = '',
        folder_open = '',
        folder_empty = '󰉖',
        folder_empty_open = '󰷏',
        -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
        -- then these will never be used.
        default = '*',
        highlight = 'NeoTreeFileIcon',
        provider = function(icon, node, state) -- default icon provider utilizes nvim-web-devicons if available
          if node.type == 'file' or node.type == 'terminal' then
            local success, web_devicons = pcall(require, 'nvim-web-devicons')
            local name = node.type == 'terminal' and 'terminal' or node.name
            if success then
              local devicon, hl = web_devicons.get_icon(name)
              icon.text = devicon or icon.text
              icon.highlight = hl or icon.highlight
            end
          end
        end,
      },
      modified = {
        symbol = '[+] ',
        highlight = 'NeoTreeModified',
      },
      name = {
        trailing_slash = false,
        highlight_opened_files = false, -- Requires `enable_opened_markers = true`.
        -- Take values in { false (no highlight), true (only loaded),
        -- "all" (both loaded and unloaded)}. For more information,
        -- see the `show_unloaded` config of the `buffers` source.
        use_git_status_colors = true,
        highlight = 'NeoTreeFileName',
      },
      git_status = {
        symbols = {
          -- Change type
          added = '✚', -- NOTE: you can set any of these to an empty string to not show them
          deleted = '✖',
          modified = '',
          renamed = '󰁕',
          -- Status type
          untracked = '',
          ignored = '',
          unstaged = '󰄱',
          staged = '',
          conflict = '',
        },
        align = 'right',
      },
      -- If you don't want to use these columns, you can set `enabled = false` for each of them individually
      file_size = {
        enabled = true,
        required_width = 64, -- min width of window required to show this column
      },
      type = {
        enabled = true,
        required_width = 110, -- min width of window required to show this column
      },
      last_modified = {
        enabled = true,
        required_width = 88, -- min width of window required to show this column
      },
      created = {
        enabled = false,
        required_width = 120, -- min width of window required to show this column
      },
      symlink_target = {
        enabled = false,
      },
    },
    renderers = {
      directory = {
        { 'indent' },
        { 'icon' },
        { 'current_filter' },
        {
          'container',
          content = {
            { 'name', zindex = 10 },
            {
              'symlink_target',
              zindex = 10,
              highlight = 'NeoTreeSymbolicLinkTarget',
            },
            { 'clipboard', zindex = 10 },
            { 'diagnostics', errors_only = true, zindex = 20, align = 'right', hide_when_expanded = true },
            { 'git_status', zindex = 10, align = 'right', hide_when_expanded = true },
            { 'file_size', zindex = 10, align = 'right' },
            { 'type', zindex = 10, align = 'right' },
            { 'last_modified', zindex = 10, align = 'right' },
            { 'created', zindex = 10, align = 'right' },
          },
        },
      },
      file = {
        { 'indent' },
        { 'icon' },
        {
          'container',
          content = {
            {
              'name',
              zindex = 10,
            },
            {
              'symlink_target',
              zindex = 10,
              highlight = 'NeoTreeSymbolicLinkTarget',
            },
            { 'clipboard', zindex = 10 },
            { 'bufnr', zindex = 10 },
            { 'modified', zindex = 20, align = 'right' },
            { 'diagnostics', zindex = 20, align = 'right' },
            { 'git_status', zindex = 10, align = 'right' },
            { 'file_size', zindex = 10, align = 'right' },
            { 'type', zindex = 10, align = 'right' },
            { 'last_modified', zindex = 10, align = 'right' },
            { 'created', zindex = 10, align = 'right' },
          },
        },
      },
      message = {
        { 'indent', with_markers = false },
        { 'name', highlight = 'NeoTreeMessage' },
      },
      terminal = {
        { 'indent' },
        { 'icon' },
        { 'name' },
        { 'bufnr' },
      },
    },
    nesting_rules = {},
    -- Global custom commands that will be available in all sources (if not overridden in `opts[source_name].commands`)
    --
    -- You can then reference the custom command by adding a mapping to it:
    --    globally    -> `opts.window.mappings`
    --    locally     -> `opt[source_name].window.mappings` to make it source specific.
    --
    -- commands = {              |  window {                 |  filesystem {
    --   hello = function()      |    mappings = {           |    commands = {
    --     print("Hello world")  |      ["<C-c>"] = "hello"  |      hello = function()
    --   end                     |    }                      |        print("Hello world in filesystem")
    -- }                         |  }                        |      end
    --
    -- see `:h neo-tree-custom-commands-global`
    commands = {}, -- A list of functions

    window = { -- see https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/popup for
      -- possible options. These can also be functions that return these options.
      position = 'left', -- left, right, top, bottom, float, current
      width = 40, -- applies to left and right positions
      height = 15, -- applies to top and bottom positions
      auto_expand_width = false, -- expand the window when file exceeds the window width. does not work with position = "float"
      popup = { -- settings that apply to float position only
        size = {
          height = '80%',
          width = '50%',
        },
        position = '50%', -- 50% means center it
        -- you can also specify border here, if you want a different setting from
        -- the global popup_border_style.
      },
      same_level = false, -- Create and paste/move files/directories on the same level as the directory under cursor (as opposed to within the directory under cursor).
      insert_as = 'child', -- Affects how nodes get inserted into the tree during creation/pasting/moving of files if the node under the cursor is a directory:
      -- "child":   Insert nodes as children of the directory under cursor.
      -- "sibling": Insert nodes  as siblings of the directory under cursor.
      -- Mappings for tree window. See `:h neo-tree-mappings` for a list of built-in commands.
      -- You can also create your own commands by providing a function instead of a string.
      mapping_options = {
        noremap = true,
        nowait = true,
      },
      mappings = {
        ['<space>'] = {
          'toggle_node',
          nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
        },
        ['<2-LeftMouse>'] = 'open',
        ['<cr>'] = 'open',
        -- ["<cr>"] = { "open", config = { expand_nested_files = true } }, -- expand nested file takes precedence
        ['<esc>'] = 'cancel', -- close preview or floating neo-tree window
        ['P'] = { 'toggle_preview', config = { use_float = true, use_image_nvim = false } },
        ['<C-f>'] = { 'scroll_preview', config = { direction = -10 } },
        ['<C-b>'] = { 'scroll_preview', config = { direction = 10 } },
        ['l'] = 'focus_preview',
        ['S'] = 'split_with_window_picker',
        ['s'] = 'open_vsplit',
        ['t'] = 'open_tabnew',
        ['w'] = 'open_with_window_picker',
        ['C'] = 'close_node',
        ['z'] = 'close_all_nodes',
        ['R'] = 'refresh',
        ['a'] = { 'add', config = { show_path = 'none' } },
        ['A'] = 'add_directory', -- also accepts the config.show_path and config.insert_as options.
        ['d'] = 'delete',
        ['r'] = 'rename',
        ['y'] = 'copy_to_clipboard',
        ['x'] = 'cut_to_clipboard',
        ['p'] = 'paste_from_clipboard',
        ['c'] = 'copy', -- takes text input for destination, also accepts the config.show_path and config.insert_as options
        ['m'] = 'move', -- takes text input for destination, also accepts the config.show_path and config.insert_as options
        ['e'] = 'toggle_auto_expand_width',
        ['q'] = 'close_window',
        ['?'] = 'show_help',
        ['<'] = 'prev_source',
        ['>'] = 'next_source',
      },
    },
    filesystem = {
      window = {
        mappings = {
          ['H'] = 'toggle_hidden',
          ['/'] = 'fuzzy_finder',
          ['D'] = 'fuzzy_finder_directory',
          ['#'] = 'fuzzy_sorter', -- fuzzy sorting using the fzy algorithm
          ['f'] = 'filter_on_submit',
          ['<C-x>'] = 'clear_filter',
          ['<bs>'] = 'navigate_up',
          ['.'] = 'set_root',
          ['[g'] = 'prev_git_modified',
          [']g'] = 'next_git_modified',
          ['K'] = 'show_file_details',
          ['?'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
          ['oc'] = { 'order_by_created', nowait = false },
          ['od'] = { 'order_by_diagnostics', nowait = false },
          ['og'] = { 'order_by_git_status', nowait = false },
          ['om'] = { 'order_by_modified', nowait = false },
          ['on'] = { 'order_by_name', nowait = false },
          ['os'] = { 'order_by_size', nowait = false },
          ['ot'] = { 'order_by_type', nowait = false },
        },
      },
      check_gitignore_in_search = true, -- check gitignore status for files/directories when searching
      filtered_items = {
        visible = false, -- when true, they will just be displayed differently than normal items
        force_visible_in_empty_folder = false, -- when true, hidden files will be shown if the root folder is otherwise empty
        show_hidden_count = true, -- when true, the number of hidden items in each folder will be shown as the last entry
        hide_dotfiles = false,
        hide_gitignored = true,
        hide_by_name = { '.DS_Store', 'thumbs.db', 'node_modules' },
      },
    },
  },
}
