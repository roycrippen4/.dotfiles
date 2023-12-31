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
    message = {
      enabled = true,
      view = 'mini',
    },
    documentation = {
      view = 'hover',
      opts = {
        lang = 'markdown',
        replace = true,
        render = 'plain',
        format = { '{message}' },
        win_options = { concealcursor = 'n', conceallevel = 3 },
      },
    },
  },
  messages = {
    enabled = true,
    view_search = false,
    view = 'mini',
    view_error = 'mini',
    view_warn = 'mini',
    view_history = 'mini',
  },
  markdown = {
    hover = {
      ['|(%S-)|'] = vim.cmd.help,
      ['%[.-%]%((%S-)%)'] = require('noice.util').open,
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
  popupmenu = {
    enabled = true,
    backend = 'cmp',
    kind_icons = {},
  },
  views = {
    cmdline_popup = {
      position = {
        col = 0,
        row = 65,
      },
      size = {
        width = 150,
      },
    },
    split = {
      enter = true,
    },
    hover = {
      scrollbar = false,
    },
  },
  cmdline = {
    format = {
      cmdline = {
        icon = '  EXCOMMAND ',
        icon_hl_group = 'CmdlineEx',
      },
      lua = {
        icon = '  EVAL LUA ',
        icon_hl_group = 'CmdlineLua',
      },
      selectionfilter = {
        pattern = "^:%s*%'<,%'>",
        icon = '   VISUAL SUB ',
        icon_hl_group = 'CmdlineVisualSub',
      },
      substitute = {
        pattern = '^:%%?s/',
        icon = '  SUBSTITUTE ',
        icon_hl_group = 'CmdlineSub',
        ft = 'regex',
      },
      search_up = {
        icon = '  SEARCH ',
        icon_hl_group = 'CmdlineSearch',
      },
      search_down = {
        icon = '  SEARCH ',
        icon_hl_group = 'CmdlineSearch',
      },
      help = {
        icon = ' 󰋖 MAN PAGES ',
        icon_hl_group = 'CmdlineHelp',
      },
    },
    enabled = true,
    opts = {
      border = 'none',
    },
  },
  routes = {
    {
      filter = {
        event = 'msg_show',
        any = {
          { find = '%d+L, %d+B' },
          { find = '; after #%d+' },
          { find = '; before #%d+' },
        },
      },
      view = 'mini',
    },
    -- { filter = { find = 'E162' }, view = 'mini' },
    -- { filter = { find = 'E37' }, skip = true },
    -- { filter = { find = 'E486' }, opts = { skip = true } },
    -- { filter = { event = 'emsg', find = 'E23' }, skip = true },
    -- { filter = { event = 'emsg', find = 'E20' }, skip = true },
    -- { filter = { find = 'No signature help' }, skip = true },
    -- { filter = { event = 'msg_show', kind = '', find = 'written' }, opts = { skip = true } },
    -- { filter = { event = 'msg_show', kind = '', find = 'lines' }, opts = { skip = true } },
    -- { filter = { event = 'msg_show', kind = '', find = 'yanked' }, opts = { skip = true } },
    -- { filter = { event = 'msg_show', kind = '', find = '%s/*' }, opts = { skip = true } },
    -- { filter = { event = 'msg_show', find = 'search hit BOTTOM' }, skip = true },
    -- { filter = { event = 'msg_show', find = 'search hit TOP' }, skip = true },
  },

  presets = {
    long_message_to_split = true,
  },
})

vim.keymap.set({ 'n', 'i', 's' }, '<C-S-N>', function()
  if not require('noice.lsp').scroll(4) then
    return '<C-S-N>'
  end
end, { silent = true, expr = true })

vim.keymap.set({ 'n', 'i', 's' }, '<C-S-P>', function()
  if not require('noice.lsp').scroll(-4) then
    return '<C-S-P>'
  end
end, { silent = true, expr = true })
