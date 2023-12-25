local ok, noice = pcall(require, 'noice')

if not ok then
  return
end

noice.setup({
  routes = {
    {
      filter = {
        event = 'msg_show',
        kind = '',
        find = 'written',
      },
      opts = {
        skip = true,
      },
    },
    {
      filter = {
        event = 'msg_show',
        kind = '',
        find = 'lines',
      },
      opts = {
        skip = true,
      },
    },
    {
      view = 'notify',
      filter = {
        event = 'msg_showmode',
      },
      opts = {
        skip = true,
      },
    },
    {
      view = 'virtualtext',
      filter = {
        event = 'msg_show',
        kind = 'search_count',
      },
    },
  },
  lsp = {
    progress = {
      enabled = false,
    },
    override = {
      ['vim.lsp.util.convert_input_to_markdown_lines'] = false,
      ['vim.lsp.util.stylize_markdown'] = false,
      ['cmp.entry.get_documentation'] = false,
    },
    hover = {
      enabled = true,
      silent = true,
      view = nil,
      opts = {},
    },
    signature = {
      enabled = true,
      auto_open = {
        enabled = true,
        trigger = true,
        luasnip = true,
        throttle = 100,
      },
    },
  },
  markdown = {
    hover = {
      ['|(%S-)|'] = vim.cmd.help, -- vim help links
      ['%[.-%]%((%S-)%)'] = require('noice.util').open, -- markdown links
    },
    highlights = {
      ['|%S-|'] = '@text.reference',
      ['@%S+'] = '@parameter',
      ['^%s*(Parameters:)'] = '@text.title',
      ['^%s*(Return:)'] = '@text.title',
      ['^%s*(See also:)'] = '@text.title',
      ['{%S-}'] = '@parameter',
    },
  },
  views = {
    cmdline_popup = {
      position = {
        row = 70,
        height = 1,
      },
    },
  },
  cmdline = {
    enabled = true,
    opts = {
      border = 'none',
    },
  },
  presets = {
    bottom_search = false,
  },
})
