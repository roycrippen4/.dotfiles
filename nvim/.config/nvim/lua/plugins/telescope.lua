local map = vim.keymap.set
local function create_mappings()
  -- stylua: ignore start
  map('n', '<leader>fa',  '<cmd> Telescope autocommands              <CR>', { desc = '󱚟  Find autocommands'      })
  map('n', '<leader>fb',  '<cmd> Telescope buffers                   <CR>', { desc = '  Find buffers'           })
  map('n', '<leader>fc',  '<cmd> Telescope commands                  <CR>', { desc = '󰘳  Find commands'          })
  map('n', '<leader>ff',  '<cmd> Telescope find_files                <CR>', { desc = '  Find files'             })
  map('n', '<leader>fh',  '<cmd> Telescope help_tags                 <CR>', { desc = '󰋖  Find help'              })
  map('n', '<leader>fk',  '<cmd> Telescope keymaps                   <CR>', { desc = '  Find keymaps'           })
  map('n', '<leader>fl',  '<cmd> Telescope highlights                <CR>', { desc = '󰸱  Find highlight groups'  })
  map('n', '<leader>fm',  '<cmd> Telescope marks                     <CR>', { desc = '  Find bookmarks'         })
  map('n', '<leader>fo',  '<cmd> Telescope oldfiles                  <CR>', { desc = '  Find oldfiles'          })
  map('n', '<leader>fr',  '<cmd> Telescope resume                    <CR>', { desc = '  Resume previous search' })
  map('n', '<leader>fw',  '<cmd> Telescope live_grep                 <CR>', { desc = '  Find word (cwd)'        })
  map('n', '<leader>fz',  '<cmd> Telescope current_buffer_fuzzy_find <CR>', { desc = '  Find in current buffer' })
  map('n', '<leader>fgc', '<cmd> Telescope git_commits               <CR>', { desc = '  Find commits'           })
  map('n', '<leader>fgs', '<cmd> Telescope git_status                <CR>', { desc = '󱖫  Find Git status'        })
  -- stylua: ignore end
end

return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  tag = '0.1.6',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  config = function()
    local opts = {
      defaults = {
        vimgrep_arguments = {
          'rg',
          '-L',
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case',
        },
        prompt_prefix = '   ',
        selection_caret = '  ',
        entry_prefix = '  ',
        initial_mode = 'insert',
        selection_strategy = 'reset',
        sorting_strategy = 'ascending',
        layout_strategy = 'horizontal',
        layout_config = {
          horizontal = { prompt_position = 'top', preview_width = 0.55, results_width = 0.8 },
          vertical = { mirror = false },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        file_sorter = require('telescope.sorters').get_fuzzy_file,
        file_ignore_patterns = { 'node_modules' },
        generic_sorter = require('telescope.sorters').get_generic_fuzzy_sorter,
        path_display = { 'truncate' },
        winblend = 0,
        border = {},
        borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
        color_devicons = true,
        set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
        file_previewer = require('telescope.previewers').vim_buffer_cat.new,
        grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
        qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
        buffer_previewer_maker = require('telescope.previewers').buffer_previewer_maker,
        mappings = { n = { ['q'] = require('telescope.actions').close } },
      },
      extensions = { fzf = { fuzzy = true, override_generic_sorter = true, override_file_sorter = true, case_mode = 'smart_case' } },
    }

    require('telescope').setup(opts)

    require('telescope').load_extension('fzf')
    require('telescope').load_extension('ui-select')
    create_mappings()
  end,
}
