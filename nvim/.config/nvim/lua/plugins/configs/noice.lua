local ok, noice = pcall(require, 'noice')

if not ok then
  return
end

noice.setup({
  lsp = {
    progress = {
      enabled = false,
    },
    override = {
      ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      ['vim.lsp.util.stylize_markdown'] = true,
      ['cmp.entry.get_documentation'] = true,
    },
    hover = {
      enabled = true,
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
        col = 15,
        row = 70,
        height = 1,
      },
    },
  },
  cmdline = {
    format = {
      cmdline = {
        icon = '',
      },
      selectionfilter = {
        kind = 'Filter',
        pattern = "^:%s*%'<,%'>%s*.*",
        -- icon = '',
        icon = '',
      },
      substitute = {
        pattern = '^:%%?s/',
        icon = '',
        -- icon = ' ',
        ft = 'regex',
      },
      search_up = {
        icon = '',
      },
      search_down = {
        icon = '',
      },
      help = {
        icon = '❔',
      },
    },
    enabled = true,
    opts = {
      border = 'none',
    },
  },
  messages = {
    view_search = false,
  },
  routes = {
    { filter = { find = 'E162' }, view = 'mini' },
    { filter = { find = 'E37' }, skip = true },
    { filter = { find = 'E486' }, opts = { skip = true } },
    { filter = { event = 'emsg', find = 'E23' }, skip = true },
    { filter = { event = 'emsg', find = 'E20' }, skip = true },
    { filter = { find = 'No signature help' }, skip = true },
    { filter = { event = 'msg_show', kind = '', find = 'written' }, opts = { skip = true } },
    { filter = { event = 'msg_show', kind = '', find = 'lines' }, opts = { skip = true } },
    { filter = { event = 'msg_show', kind = '', find = 'yanked' }, opts = { skip = true } },
    { filter = { event = 'msg_show', kind = '', find = '%s/*' }, opts = { skip = true } },
    { filter = { event = 'msg_show', find = 'search hit BOTTOM' }, skip = true },
    { filter = { event = 'msg_show', find = 'search hit TOP' }, skip = true },
  },
})
