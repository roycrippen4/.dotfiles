local autocmd = vim.api.nvim_create_autocmd

local M = {}

---@param colors ThemeTable
---@return custom_colors
function M.convert_custom_colors_to_hex(colors)
  local custom_colors = require('custom.chadrc').ui.custom_colors
  local lighten_darken = require('base46.colors').change_hex_lightness

  ---@type custom_colors
  local converted_colors = {
    black = colors.base_30.black,
    cursorline = '#252931',
    d_red = lighten_darken(colors.base_30.red, custom_colors.d_red[2]),
    d_yellow = lighten_darken(colors.base_30.yellow, custom_colors.d_yellow[2]),
    darkest_black = lighten_darken(colors.base_30.black, custom_colors.darkest_black[2]),
    green = lighten_darken(colors.base_30.green, custom_colors.green[2]),
    l_blue = '#00C5FF',
    orange = lighten_darken(colors.base_30.orange, custom_colors.orange[2]),
    pink = lighten_darken(colors.base_30.pink, custom_colors.pink[2]),
    sep_color = '#454951',
  }
  return converted_colors
end

---@param colors ThemeTable
---@return KittyTable
M.build_kitty_color_table = function(colors)
  local kitty_colors = {
    color0 = '',
    color1 = '',
    color2 = '',
    color3 = '',
    color4 = '',
    color5 = '',
    color6 = '',
    color7 = '',
    color8 = '',
    color9 = '',
    color10 = '',
    color11 = '',
    color12 = '',
    color13 = '',
    color14 = '',
    color15 = '',
  }
  local base16 = colors.base_16
  for k, v in pairs(base16) do
    local num = k:match('base0(%x)')
    local index = tonumber(num, 16)
    kitty_colors['color' .. index] = v
  end

  local custom_colors = M.convert_custom_colors_to_hex(colors)

  kitty_colors['inactive_tab_foreground'] = colors.base_30.light_grey
  kitty_colors['background'] = colors.base_16.base00
  kitty_colors['selection_foreground'] = colors.base_30.one_bg
  kitty_colors['active_tab_foreground'] = custom_colors.d_yellow
  kitty_colors['tab_bar_background'] = colors.base_30.darker_black
  kitty_colors['inactive_tab_background'] = custom_colors.darkest_black
  kitty_colors['active_tab_background'] = colors.base_30.one_bg
  kitty_colors['selection_background'] = colors.base_16.base02
  kitty_colors['color1'] = custom_colors.d_red
  kitty_colors['color2'] = custom_colors.green
  kitty_colors['color4'] = custom_colors.l_blue
  kitty_colors['color6'] = custom_colors.d_yellow
  kitty_colors['foreground'] = '#dddddd'

  return kitty_colors
end

---@param theme string the name of the `theme.lua` file
function M.write_kitty_theme(theme)
  local theme_file = 'base46.themes.' .. theme
  ---@type ThemeTable
  local colors = require(theme_file)
  local kitty_colors = M.build_kitty_color_table(colors)

  local path = vim.fn.expand('$HOME') .. '/.dotfiles/kitty/.config/kitty/current-theme.conf'
  local file = assert(io.open(path, 'w+'))
  for k, v in pairs(kitty_colors) do
    file:write(k .. ' ' .. v .. '\n')
  end
  file:close()

  local command = '!kitty @ set-colors -a -c ' .. path
  vim.api.nvim_command(command)
end

autocmd('User', {
  pattern = 'NvChadThemeReload',
  callback = function()
    local theme = require('nvconfig').ui.theme
    vim.defer_fn(function()
      M.write_kitty_theme(theme)
    end, 100)
  end,
})
