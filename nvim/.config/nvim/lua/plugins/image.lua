---@type LazyPluginSpec
return {
  '3rd/image.nvim', -- https://github.com/3rd/image.nvim
  dependencies = {
    {
      'vhyrro/luarocks.nvim', -- https://github.com/vhyrro/luarocks.nvim
      priority = 1001,
      opts = { rocks = { 'lua-cjson', 'http', 'magick' } },
    },
  },
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
