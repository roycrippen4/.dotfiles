---@module "gitsigns"
---@type LazyPluginSpec
return {
  'lewis6991/gitsigns.nvim', -- https://github.com/lewis6991/gitsigns.nvim
  keys = {
    {
      '<leader>gb',
      '<cmd> Gitsigns blame_line <cr>',
      desc = 'Blame line',
    },
    {
      '<leader>gB',
      '<cmd> Gitsigns blame_line full=true <cr>',
      desc = 'Blame line [full]',
    },
    {
      '<leader>gd',
      '<cmd> Gitsigns diffthis <cr>',
      desc = 'Diff file',
    },
    {
      '<leader>gr',
      '<cmd> Gitsigns reset_buffer <cr>',
      desc = 'Reset buffer',
    },
    {
      '<leader>gs',
      '<cmd> Gitsigns stage_hunk <cr>',
      desc = 'Stage hunk',
    },
    {
      '<leader>gS',
      '<cmd> Gitsigns stage_buffer <cr>',
      desc = 'Stage buffer',
    },
    {
      '<leader>gt',
      '<cmd> Gitsigns toggle_current_line_blame <cr>',
      desc = 'Toggle current line blame hint',
    },
    {
      ']g',
      function()
        if vim.wo.diff then
          return '[g'
        end
        vim.cmd('Gitsigns nav_hunk next')
        return '<Ignore>'
      end,
      desc = 'Next change hunk',
      expr = true,
      buffer = true,
    },
    {
      '[g',
      function()
        if vim.wo.diff then
          return '[g'
        end
        vim.cmd('Gitsigns nav_hunk prev')
        return '<Ignore>'
      end,
      desc = 'Previous change hunk',
      expr = true,
      buffer = true,
    },
  },
  ---@type Gitsigns.Config
  opts = {
    current_line_blame = true,
    current_line_blame_opts = { virt_text_priority = 5000 },
    signs = {
      add = { text = '│' },
      change = { text = '│' },
      delete = { text = '│' },
      topdelete = { text = '│' },
      changedelete = { text = '│' },
      untracked = { text = '│' },
    },
    signs_staged = {
      add = { text = '│' },
      change = { text = '│' },
      delete = { text = '│' },
      topdelete = { text = '│' },
      changedelete = { text = '│' },
      untracked = { text = '│' },
    },
  },
}
