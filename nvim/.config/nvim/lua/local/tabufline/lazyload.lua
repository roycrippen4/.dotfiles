local api = vim.api
local autocmd = api.nvim_create_autocmd
local get_buf = api.nvim_get_current_buf
local valid_buf = api.nvim_buf_is_valid
local get_name = api.nvim_buf_get_name
local get_option = api.nvim_get_option_value
local t = vim.t

t.bufs = api.nvim_list_bufs()
local listed_bufs = {}

for _, val in ipairs(t.bufs) do
  if vim.bo[val].buflisted then
    table.insert(listed_bufs, val)
  end
end

t.bufs = listed_bufs

-- autocmds for tabufline -> store bufnrs on bufadd, bufenter events
-- thx to https://github.com/ii14 & stores buffer per tab -> table
autocmd({ E.BufAdd, E.BufEnter, E.TabNew }, {
  callback = function(args)
    local bufs = t.bufs

    if t.bufs == nil then
      t.bufs = get_buf() == args.buf and {} or { args.buf }
    else
      -- check for duplicates
      if
        not vim.tbl_contains(bufs, args.buf)
        and (args.event == E.BufEnter or vim.bo[args.buf].buflisted or args.buf ~= get_buf())
        and valid_buf(args.buf)
        and vim.bo[args.buf].buflisted
        and vim.bo.ft ~= 'undotree' -- This was a super annoying bug
      then
        table.insert(bufs, args.buf)
        t.bufs = bufs
      end
    end

    -- remove unnamed buffer which isnt current buf & modified
    if args.event == 'BufAdd' then
      local first_buf = t.bufs[1]

      -- if #get_name(first_buf) == 0 and not  get_option(first_buf, 'modified') then
      if #get_name(first_buf) == 0 and not get_option('modified', { buf = first_buf }) then
        table.remove(bufs, 1)
        t.bufs = bufs
      end
    end
  end,
})

autocmd(E.BufDelete, {
  callback = function(args)
    for _, tab in ipairs(api.nvim_list_tabpages()) do
      local bufs = t[tab].bufs
      if bufs then
        for i, bufnr in ipairs(bufs) do
          if bufnr == args.buf then
            table.remove(bufs, i)
            t[tab].bufs = bufs
            break
          end
        end
      end
    end
  end,
})

autocmd({ E.BufNew, E.BufNewFile, E.BufRead, E.TabEnter, E.TermOpen }, {
  pattern = '*',
  callback = function()
    if #vim.fn.getbufinfo({ buflisted = 1 }) >= 2 or #api.nvim_list_tabpages() >= 2 then
      vim.opt.showtabline = 2
      vim.opt.tabline = "%!v:lua.require('local.tabufline.modules').run()"
    end
  end,
})
