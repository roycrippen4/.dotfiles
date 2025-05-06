---@param opts snacks.picker.files.Config
---@type snacks.picker.finder
local function multigrep(opts, ctx)
  local cwd = not (opts.rtp or (opts.dirs and #opts.dirs > 0)) and vim.fs.normalize(opts and opts.cwd or vim.uv.cwd() or '.') or nil
  local parts = vim.split(ctx.filter.search, '  ')
  local args = {}

  if parts[1] then
    table.insert(args, '-e')
    table.insert(args, parts[1])
  end

  if parts[2] then
    table.insert(args, '-g')
    table.insert(args, parts[2])
  end

  vim.list_extend(args, { '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case' })

  return require('snacks.picker.source.proc').proc({
    opts,
    {
      cmd = 'rg',
      args = args,
      notify = false,
      transform = function(item)
        local file, line, col, text = item.text:match('^(.+):(%d+):(%d+):(.*)$')
        item.cwd = cwd
        if not file then
          if not item.text:match('WARNING') then
            print('Invalid grep output: ' .. item.text, vim.log.levels.ERROR)
            vim.notify('Invalid grep output: ' .. item.text, vim.log.levels.ERROR)
          end
          return false
        else
          item.line = text
          item.file = file
          item.pos = { tonumber(line), tonumber(col) - 1 }
        end
      end,
    },
  }, ctx)
end

---@module "snacks"
---@type LazyPluginSpec
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  dependencies = {
    {
      'cargo-bins/cargo-binstall',
      build = "curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash",
    },
    { 'sharkdp/fd', build = 'cargo binstall fd-find -y', dependencies = 'cargo-bins/cargo-binstall' },
    { 'BurntSushi/ripgrep', build = 'cargo binstall ripgrep', dependencies = 'cargo-bins/cargo-binstall' },
    { 'dandavison/delta', build = 'cargo binstall git-delta', dependencies = 'cargo-bins/cargo-binstall' },
  },

  -- stylua: ignore
  keys = {
    { 'gd', function() Snacks.picker.lsp_definitions() end, desc = 'Goto Definition' },
    { 'gr', function() Snacks.picker.lsp_references() end, desc = 'Goto References' },
    { "<leader>ut", function() Snacks.picker.undo() end, desc = "View Undo History" },
    { '<leader>z', function() Snacks.zen() end },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>fa", function() Snacks.picker.autocmds() end, desc = "Find Autocmds" },
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Find Buffers" },
    { "<leader>fc", function() Snacks.picker.command_history() end, desc = "Find Command History" },
    { "<leader>fC", function() Snacks.picker.commands() end,  desc = "Find Commands"  },
    { "<leader>fh", function() Snacks.picker.help() end, desc = "Find Help" },
    { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Find Keymaps" },
    { "<leader>fl", function() Snacks.picker.highlights({ confirm = { "copy", "close" } }) end, desc = "Find Highlights" },
    { "<leader>fm", function() Snacks.picker.marks() end, desc = "Find Marks" },
    { "<leader>fo", function() Snacks.picker.recent({ filter = { cwd = vim.fn.getcwd() } }) end, desc = "Find Recent Files" },
    { "<leader>fr", function() Snacks.picker.resume() end, desc = "Resume previous search" },
    { "<leader>fw", function() Snacks.picker.grep({ finder = multigrep }) end, desc = "Find word" },
    { "<leader>fW", function() Snacks.picker.grep_word() end, desc = "Grep word under cursor" },
    { "<leader>lg", function() Snacks.lazygit() end, desc = "Launch Lazygit" },
  },
  ---@type snacks.Config
  opts = {
    styles = {
      input = {
        relative = 'cursor',
        row = 1,
      },
      notification = { wo = { wrap = true } },
      zen = {
        max_height = 63,
        width = 160,
        backdrop = { blend = 20 },
      },
    },
    notifier = { timeout = 5000, enabled = true },
    bigfile = { enabled = true },
    input = { enabled = true },
    image = { enabled = true },
    picker = {
      backdrop = false,
      previewers = {
        diff = {
          cmd = { 'delta' },
        },
      },
      prompt = '   ',
      layout = { preset = 'custom' },
      layouts = {
        select = {
          layout = {
            box = 'vertical',
            width = 0.5,
            height = 0.2,
            {
              win = 'input',
              height = 1,
              border = 'rounded',
              title = '{title} {live} {flags}',
            },
            {
              win = 'list',
              border = 'solid',
              height = 10,
              wo = { foldcolumn = '0' },
            },
          },
        },
        custom = {
          layout = {
            box = 'horizontal',
            width = 0.87,
            height = 0.8,
            {
              box = 'vertical',
              {
                win = 'input',
                height = 1,
                border = 'rounded',
                title = '{title} {live} {flags}',
              },
              {
                win = 'list',
                border = 'solid',
                wo = { foldcolumn = '0' },
              },
            },
            {
              win = 'preview',
              title = '{title} Preview',
              border = 'rounded',
              width = 0.55,
              wo = { foldcolumn = '0' },
            },
          },
        },
      },
      win = {
        input = {
          keys = {
            ['K'] = { 'preview_scroll_up', mode = { 'n' } },
            ['J'] = { 'preview_scroll_down', mode = { 'n' } },
          },
        },
      },
    },
    zen = {
      toggles = { dim = false },
      show = { statusline = true, tabline = true },
    },
  },
  init = function()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      callback = function()
        _G.log = function(...)
          Snacks.debug.inspect(...)
        end
        _G.trace = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.log
      end,
    })
  end,
}
