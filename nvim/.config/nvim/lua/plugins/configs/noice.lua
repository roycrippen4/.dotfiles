return { ---@type NoiceConfig
  routes = {
    {
      filter = {
        event = 'msg_show',
        any = {
          { find = '%d+L, %d+B' },
          { find = '; after #%d+' },
          { find = '; before #%d+' },
          { find = 'fewer lines' },
        },
      },
      view = 'mini',
    },
  },
  cmdline = {
    format = {
      cmdline = { icon = '>' },
      search_down = { icon = '' },
      search_up = { icon = '' },
      lua = { icon = '' },
    },
  },
  presets = { long_message_to_split = true, lsp_doc_border = true },
  messages = { view_search = false },
}
