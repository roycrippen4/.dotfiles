local present, whichkey = pcall(require, 'which-key')

if not present then
  return
end

whichkey.register({
  ------------------------------DEBUG------------------------------
  -- ['<leader>d'] = { name = 'Debug', _ = 'which_key_ignore' },
  -- ['<leader>ds'] = { name = 'Step', _ = 'which_key_ignore' },
  -- ['<Leader>c'] = { name = 'Continue', _ = 'which_key_ignore' },
  -- ['<Leader>o'] = { name = 'Step over', _ = 'which_key_ignore' },
  -- ['<Leader>i'] = { name = 'Step into', _ = 'which_key_ignore' },
  -- ['<Leader>O'] = { name = 'Step out', _ = 'which_key_ignore' },
  -- ['<leader>b'] = { name = 'Toggle breakpoint', _ = 'which_key_ignore' },
  -- ['<Leader>dB'] = { name = 'Set breakpoint', _ = 'which_key_ignore' },
  -- ['<Leader>dr'] = { name = 'Repl Open', _ = 'which_key_ignore' },
  -- ['<Leader>dl'] = { name = 'Run Last', _ = 'which_key_ignore' },
  -- ['<Leader>dh'] = { name = 'Hover', _ = 'which_key_ignore' },
  -- ['<Leader>dv'] = { name = 'Preview', _ = 'which_key_ignore' },
  -- ['<Leader>df'] = { name = 'Show frames', _ = 'which_key_ignore' },
  -- ['<Leader>ds'] = { name = 'Show scopes', _ = 'which_key_ignore' },
  -- ['<Leader>dt'] = { name = 'Toggle Debug UI', _ = 'which_key_ignore' },
  -- ['<Leader>dp'] = { name = 'Toggle Log Point', _ = 'which_key_ignore' },

  ------------------------------      DEBUG     ------------------------------
  ['<leader>f'] = { name = 'Find', _ = 'which_key_ignore' },
  ['<leader>l'] = { name = 'LSP', _ = 'which_key_ignore' },

  ------------------------------MARKDOWN PREVIEW------------------------------
  ['<leader>m'] = { name = 'Markdown Preview', _ = 'which_key_ignore' },
  ['<leader>mt'] = { name = 'Toggle Markdown Preview', _ = 'which_key_ignore' },
  ['<leader>mp'] = { name = 'Start Markdown Preview', _ = 'which_key_ignore' },
  ['<leader>ms'] = { name = 'Stop Markdown Preview', _ = 'which_key_ignore' },

  ------------------------------      MISC     ------------------------------
  -- ['<leader>a'] = { name = 'Autosave', _ = 'which_key_ignore' },
  ['<leader>t'] = { name = 'Trouble', _ = 'which_key_ignore' },
  ['<leader>w'] = { name = 'Lookup Keymaps', _ = 'which_key_ignore' },
  ['<leader>z'] = { name = 'Zen', _ = 'which_key_ignore' },
})
