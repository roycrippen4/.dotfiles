-- local Path = require('plenary.path')
-- local conf = require('telescope.config').values
-- local from_entry = require('telescope.from_entry')
-- local image_api = require('image')
-- local image = nil
-- local is_image_preview = false
-- local last_file_path = ''
-- local supported_images = { 'svg', 'png', 'jpg', 'jpeg', 'gif', 'webp', 'avif' }

-- local is_supported_image = function(filepath)
--   local split_path = vim.split(filepath:lower(), '.', { plain = true })
--   local extension = split_path[#split_path]
--   return vim.tbl_contains(supported_images, extension)
-- end

-- local delete_image = function()
--   if not image then
--     return
--   end

--   image:clear()

--   is_image_preview = false
-- end

-- local create_image = function(filepath, winid, bufnr)
--   image = image_api.hijack_buffer(filepath, winid, bufnr)

--   if not image then
--     return
--   end

--   vim.schedule(function()
--     image:render()
--   end)

--   is_image_preview = true
-- end

-- local function defaulter(f, default_opts)
--   default_opts = default_opts or {}
--   return {
--     new = function(opts)
--       if conf.preview == false and not opts.preview then
--         return false
--       end
--       opts.preview = type(opts.preview) ~= 'table' and {} or opts.preview
--       if type(conf.preview) == 'table' then
--         for k, v in pairs(conf.preview) do
--           opts.preview[k] = vim.F.if_nil(opts.preview[k], v)
--         end
--       end
--       return f(opts)
--     end,
--     __call = function()
--       local ok, err = pcall(f(default_opts))
--       if not ok then
--         error(debug.traceback(err))
--       end
--     end,
--   }
-- end

-- local file_previewer = defaulter(function(opts)
--   opts = opts or {}
--   local cwd = opts.cwd or vim.uv.cwd()
--   return previewers.new_buffer_previewer({
--     title = 'File Preview',
--     dyn_title = function(_, entry)
--       return Path:new(from_entry.path(entry, true)):normalize(cwd)
--     end,

--     get_buffer_by_name = function(_, entry)
--       return from_entry.path(entry, true)
--     end,

--     define_preview = function(self, entry, _)
--       local p = from_entry.path(entry, true)
--       if p == nil or p == '' then
--         return
--       end

--       conf.buffer_previewer_maker(p, self.state.bufnr, {
--         bufname = self.state.bufname,
--         winid = self.state.winid,
--         preview = opts.preview,
--       })
--     end,

--     teardown = function(_)
--       if is_image_preview then
--         delete_image()
--       end
--     end,
--   })
-- end, {}).new

-- ---@param filepath string
-- ---@param bufnr integer
-- ---@param opts table
-- local buffer_previewer_maker = function(filepath, bufnr, opts)
--   if is_image_preview and last_file_path ~= filepath then
--     delete_image()
--   end

--   last_file_path = filepath

--   if is_supported_image(filepath) then
--     create_image(filepath, opts.winid, bufnr)
--   else
--     previewers.buffer_previewer_maker(filepath, bufnr, opts)
--   end
-- end

local function lsp_definitions()
  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0, 'textDocument/definition', params, function(_, result, ctx)
    if not result or vim.tbl_isempty(result) then
      vim.notify('No definitions found', vim.log.levels.INFO)
      return
    end

    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if not client then
      return
    end

    local locations = vim.lsp.util.locations_to_items(result, client.offset_encoding)
    if #locations > 1 then
      require('telescope.builtin').lsp_definitions({
        cwd = vim.fn.getcwd(),
        locations = locations,
        client_id = ctx.client_id,
      })
    else
      vim.lsp.util.jump_to_location(result[1], client.offset_encoding)
    end
  end)
end

---@type LazyPluginSpec
return {
  'nvim-telescope/telescope.nvim', -- https://github.com/nvim-telescope/telescope.nvim
  keys = {
    { '<leader>ff', '<cmd> Telescope find_files      <cr>' },
    { '<leader>fa', '<cmd> Telescope autocommands    <cr>' },
    { '<leader>fb', '<cmd> Telescope buffers         <cr>' },
    { '<leader>fc', '<cmd> Telescope commands        <cr>' },
    { '<leader>fh', '<cmd> Telescope help_tags       <cr>' },
    { '<leader>fk', '<cmd> Telescope keymaps         <cr>' },
    { '<leader>fl', '<cmd> Telescope highlights      <cr>' },
    { '<leader>fm', '<cmd> Telescope marks           <cr>' },
    { '<leader>fo', '<cmd> Telescope oldfiles        <cr>' },
    { '<leader>fr', '<cmd> Telescope resume          <cr>' },
    { '<leader>fw', '<cmd> Telescope live_grep       <cr>' },
    { '<leader>fgc', '<cmd> Telescope git_commits    <cr>' },
    { '<leader>fgs', '<cmd> Telescope git_status     <cr>' },
    { '<leader>fp', '<cmd> Telescope treesitter_info <cr>' },
    { '<leader>ft', '<cmd> TodoTelescope             <cr>' },
    { 'gd', lsp_definitions },
    { 'gr', require('telescope.builtin').lsp_references },
  },
  dependencies = {
    {
      'cargo-bins/cargo-binstall', -- https://github.com/cargo-bins/cargo-binstall
      build = "curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash",
    },
    { 'sharkdp/fd', build = 'cargo binstall fd-find -y', dependencies = 'cargo-bins/cargo-binstall' },
    { 'BurntSushi/ripgrep', build = 'cargo binstall ripgrep', dependencies = 'cargo-bins/cargo-binstall' },
    {
      'nvim-telescope/telescope-fzf-native.nvim', -- https://github.com/nvim-telescope/telescope-fzf-native.nvim
      build = 'make',
    },
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'nvim-telescope/telescope-ui-select.nvim',
    'roycrippen4/telescope-treesitter-info.nvim',
    'folke/which-key.nvim',
  },
  config = function()
    local builtin = require('telescope.builtin')
    local previewers = require('telescope.previewers')
    local telescope = require('telescope')
    require('which-key').add({
      {
        mode = 'n',
        { 'gd', lsp_definitions, desc = 'Goto Definition', icon = '󰼭' },
        { 'gr', builtin.lsp_references, desc = 'Goto References', icon = '' },
        { '<leader>ff', '<cmd> Telescope find_files      <CR>', desc = '[F]ind files', icon = '' },
        { '<leader>fa', '<cmd> Telescope autocommands    <CR>', desc = '[F]ind autocommands', icon = '󱚟' },
        { '<leader>fb', '<cmd> Telescope buffers         <CR>', desc = '[F]ind buffers', icon = '' },
        { '<leader>fc', '<cmd> Telescope commands        <CR>', desc = '[F]ind commands', icon = '󰘳' },
        { '<leader>fh', '<cmd> Telescope help_tags       <CR>', desc = '[F]ind help', icon = '󰋖' },
        { '<leader>fk', '<cmd> Telescope keymaps         <CR>', desc = '[F]ind keymaps', icon = '' },
        { '<leader>fl', '<cmd> Telescope highlights      <CR>', desc = '[F]ind highlight groups', icon = '󰸱' },
        { '<leader>fm', '<cmd> Telescope marks           <CR>', desc = '[F]ind bookmarks', icon = '' },
        { '<leader>fo', '<cmd> Telescope oldfiles        <CR>', desc = '[F]ind oldfiles', icon = '' },
        { '<leader>fr', '<cmd> Telescope resume          <CR>', desc = '[R]esume previous search', icon = '' },
        { '<leader>fw', '<cmd> Telescope live_grep       <CR>', desc = '[F]ind word (cwd)', icon = '' },
        { '<leader>fgc', '<cmd> Telescope git_commits    <CR>', desc = '[F]ind [G]it commits', icon = '' },
        { '<leader>fgs', '<cmd> Telescope git_status     <CR>', desc = '[F]ind [G]it status', icon = '󱖫' },
        { '<leader>fp', '<cmd> Telescope treesitter_info <CR>', desc = '[F]ind treesitter info', icon = '' },
        { '<leader>ft', '<cmd> TodoTelescope             <CR>', desc = '[F]ind [T]odos', icon = '' },
      },
    })

    telescope.setup({
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
        -- file_previewer = file_previewer,
        -- buffer_previewer_maker = buffer_previewer_maker,
        grep_previewer = previewers.vim_buffer_vimgrep.new,
        qflist_previewer = previewers.vim_buffer_qflist.new,
        mappings = { n = { ['q'] = require('telescope.actions').close } },
      },
    })

    telescope.load_extension('fzf')
    telescope.load_extension('ui-select')
    telescope.load_extension('treesitter_info')
  end,
}
