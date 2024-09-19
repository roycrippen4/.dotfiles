---@type LazyPluginSpec
return {
  '3rd/image.nvim', -- https://github.com/3rd/image.nvim
  dependencies = { 'vhyrro/luarocks.nvim' },
  ft = {
    'apng',
    'avif',
    'bmp',
    'cur',
    'gif',
    'ico',
    'jfif',
    'jpeg',
    'jpg',
    'markdown',
    'pjp',
    'pjpeg',
    'png',
    'svg',
    'tif',
    'tiff',
    'webp',
  },
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
