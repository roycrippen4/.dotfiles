---@type LazyPluginSpec
return {
  '3rd/image.nvim',
  dependencies = { 'luarocks.nvim' },
  ---@module 'image'
  ---@type Options
  opts = {
    backend = 'kitty',
    integrations = {
      html = {
        enabled = true,
        only_render_image_at_cursor = true,
      },
    },
    kitty_method = 'normal',
  },
}
