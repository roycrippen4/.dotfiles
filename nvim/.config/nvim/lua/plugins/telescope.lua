local map = vim.keymap.set

return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'cargo-bins/cargo-binstall', -- https://github.com/cargo-bins/cargo-binstall
      build = "curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash",
    },
    { 'sharkdp/fd', build = 'cargo bindstall fd-find', dependencies = 'cargo-bins/cargo-binstall' },
    { 'BurntSushi/ripgrep', build = 'cargo binstall ripgrep', dependencies = 'cargo-bins/cargo-binstall' },
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release',
    },
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    'sharkdp/fd',
    'BurntSushi/ripgrep',
    'nvim-telescope/telescope-ui-select.nvim',
    'roycrippen4/telescope-treesitter-info.nvim',
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
    }

    require('telescope').setup(opts)
    require('telescope').load_extension('fzf')
    require('telescope').load_extension('ui-select')
    require('telescope').load_extension('treesitter_info')
    require('which-key').add({
      {
      -- stylua: ignore start
      mode = 'n',
      { '<leader>fa',  '<cmd> Telescope autocommands    <CR>', desc = 'Find autocommands',      icon =  "󱚟" },
      { '<leader>fb',  '<cmd> Telescope buffers         <CR>', desc = 'Find buffers',           icon =  "" },
      { '<leader>fc',  '<cmd> Telescope commands        <CR>', desc = 'Find commands',          icon =  "󰘳" },
      { '<leader>ff',  '<cmd> Telescope find_files      <CR>', desc = 'Find files',             icon =  "" },
      { '<leader>fh',  '<cmd> Telescope help_tags       <CR>', desc = 'Find help',              icon =  "󰋖" },
      { '<leader>fk',  '<cmd> Telescope keymaps         <CR>', desc = 'Find keymaps',           icon =  "" },
      { '<leader>fl',  '<cmd> Telescope highlights      <CR>', desc = 'Find highlight groups',  icon =  "󰸱" },
      { '<leader>fm',  '<cmd> Telescope marks           <CR>', desc = 'Find bookmarks',         icon =  "" },
      { '<leader>fo',  '<cmd> Telescope oldfiles        <CR>', desc = 'Find oldfiles',          icon =  "" },
      { '<leader>fr',  '<cmd> Telescope resume          <CR>', desc = 'Resume previous search', icon =  "" },
      { '<leader>fw',  '<cmd> Telescope live_grep       <CR>', desc = 'Find word (cwd)',        icon =  "" },
      { '<leader>fgc', '<cmd> Telescope git_commits     <CR>', desc = 'Find commits',           icon =  "" },
      { '<leader>fgs', '<cmd> Telescope git_status      <CR>', desc = 'Find Git status',        icon =  "󱖫" },
      { '<leader>fp',  '<cmd> Telescope treesitter_info <CR>', desc = 'Find treesitter info',   icon =  "" },
        -- stylua: ignore end
      },
    })
  end,
}
