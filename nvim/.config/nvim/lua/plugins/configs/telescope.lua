local set = function(value)
  vim.fn.setreg('+', value)
end

local options = {
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
      horizontal = {
        prompt_position = 'top',
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
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

    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require('telescope.previewers').buffer_previewer_maker,
    mappings = {
      n = {
        ['q'] = require('telescope.actions').close,
        ['<C-Q>'] = false,
        ['<M-q>'] = false,
        ['<C-d>'] = function(prompt_bufnr)
          require('telescope.actions').results_scrolling_down(prompt_bufnr)
        end,
        ['<C-u>'] = function(prompt_bufnr)
          require('telescope.actions').results_scrolling_up(prompt_bufnr)
        end,
        ['<M-t>'] = require('telescope.actions').send_to_qflist + require('telescope.actions').open_qflist,
        ['yy'] = function()
          local buf = vim.api.nvim_get_current_buf()
          local state = require('telescope.actions.state')
          local title = state.get_current_picker(buf).prompt_title
          local selected = state.get_selected_entry()

          if title == 'Find Files' then
            set(selected[1])
            vim.notify('Yanked ' .. selected[1] .. ' into register.')
          end

          if title == 'Live Grep' then
            set(selected.filename)
            vim.notify('Yanked ' .. selected.filename .. ' into register.')
          end

          if title == 'Highlights' then
            set(selected.ordinal)
            vim.notify('Yanked ' .. selected.ordinal .. ' into register.')
          end
        end,
      },
      i = {
        ['<M-t>'] = require('telescope.actions').send_to_qflist + require('telescope.actions').open_qflist,
        ['<M-q>'] = false,
        ['<C-Q>'] = false,
      },
    },
  },

  extensions_list = {
    --'colors'
    'themes',
    'fzf',
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = 'smart_case',
    },
  },
}

return options
