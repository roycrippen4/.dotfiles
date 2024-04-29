return {
  'stevearc/dressing.nvim', -- https://github.com/stevearc/dressing.nvim
  event = 'VimEnter',
  opts = {
    input = {
      get_config = function(opts)
        if opts.prompt == 'Create file ' then
          return {
            min_width = (function()
              local path_length = #opts.default
              return path_length + 8
            end)(),
            title_pos = 'center',
          }
        end

        if opts.prompt == 'Move to: ' then
          opts.default = opts.default .. '/'
          return {
            min_width = (function()
              local path_length = #opts.default
              return path_length + 5
            end)(),
            title_pos = 'left',
          }
        end

        if string.find(opts.prompt, ' y/N: ') then
          opts.prompt = 'Delete: y/n'
          return {
            width = nil,
            min_width = (function()
              local length = #opts.prompt
              return length
            end)(),
            max_width = 15,
            title_pos = 'center',
          }
        end

        if opts.prompt == 'Rename to ' then
          local name = require('nvim-tree.api').tree.get_node_under_cursor().name
          opts.prompt = ' Rename ' .. name .. '? '
          return {
            width = nil,
            min_width = (function()
              local length = #opts.prompt + 4
              return length
            end)(),
            title_pos = 'center',
          }
        end
        return nil
      end,
      win_options = {
        winhighlight = 'Normal:DressingNormal,FloatBorder:DressingBorder,Title:DressingTitle',
      },
    },
  },
}
