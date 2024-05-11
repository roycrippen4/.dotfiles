local devicons = require('core.icons').devicon
return {
  'nvim-tree/nvim-web-devicons', -- https://github.com/nvim-tree/nvim-web-devicons
  lazy = false,
  config = function()
    require('nvim-web-devicons').setup({
      override = {
        default_icon = {
          icon = devicons.default,
          name = 'Default',
        },

        c = {
          icon = devicons.c,
          name = 'c',
        },

        css = {
          icon = devicons.css,
          name = 'css',
          color = '#2196f3',
        },

        postcss = {
          icon = '',
          color = '#DE4012',
          name = 'Postcss',
        },

        dart = {
          icon = devicons.dart,
          name = 'dart',
        },

        deb = {
          icon = devicons.deb,
          name = 'deb',
        },

        Dockerfile = {
          icon = devicons.Dockerfile,
          name = 'Dockerfile',
        },

        html = {
          icon = devicons.html,
          name = 'html',
          color = '#ff9408',
        },

        jpeg = {
          icon = devicons.jpeg,
          name = 'jpeg',
        },

        jpg = {
          icon = devicons.jpg,
          name = 'jpg',
        },

        js = {
          icon = devicons.js,
          name = 'js',
          color = '#f7e025',
        },

        kt = {
          icon = devicons.kt,
          name = 'kt',
        },

        lock = {
          icon = devicons.lock,
          name = 'lock',
        },

        lua = {
          icon = devicons.lua,
          name = 'lua',
        },

        mp3 = {
          icon = devicons.mp3,
          name = 'mp3',
        },

        mp4 = {
          icon = devicons.mp4,
          name = 'mp4',
        },

        out = {
          icon = devicons.out,
          name = 'out',
        },

        png = {
          icon = devicons.png,
          name = 'png',
        },

        py = {
          icon = devicons.py,
          name = 'py',
        },

        ['robots.txt'] = {
          icon = devicons['robots.txt'],
          name = 'robots',
        },

        toml = {
          icon = devicons.toml,
          name = 'toml',
          color = '#838383',
        },

        ts = {
          icon = devicons.ts,
          name = 'ts',
          color = require('core.colors').light_blue,
        },

        ttf = {
          icon = devicons.ttf,
          name = 'TrueTypeFont',
        },

        rb = {
          icon = devicons.rb,
          name = 'rb',
        },

        rpm = {
          icon = devicons.rpm,
          name = 'rpm',
        },

        vue = {
          icon = devicons.vue,
          name = 'vue',
        },

        woff = {
          icon = devicons.woff,
          name = 'WebOpenFontFormat',
        },

        woff2 = {
          icon = devicons.woff,
          name = 'WebOpenFontFormat2',
        },

        xz = {
          icon = devicons.xz,
          name = 'xz',
        },

        zip = {
          icon = devicons.zip,
          name = 'zip',
        },

        ['jsx'] = {
          icon = devicons['jsx'],
          color = '#ccaa00',
          name = 'bun.lockb',
        },
        ['bun.lockb'] = {
          icon = devicons['bun.lockb'],
          color = '#fbf0df',
          name = 'bun.lockb',
        },
        ['.env'] = {
          icon = devicons['.env'],
          color = 'gray',
          name = '.env',
        },
        ['.development.env'] = {
          icon = devicons['.development.env'],
          color = 'gray',
          name = '.development.env',
        },
        ['.ignore'] = {
          icon = devicons['.ignore'],
          color = '#aaaaaa',
          name = '.ignore',
        },
        ['.eslintignore'] = {
          icon = devicons['.eslintignore'],
          color = '#1a455f',
          name = '.eslintignore',
        },
        ['eslint.config.js'] = {
          icon = devicons['eslint'],
          color = '#2c739e',
          name = 'Eslintrc',
        },
        ['.eslintrc'] = {
          icon = devicons['eslint'],
          color = '#2c739e',
          name = 'Eslintrc',
        },
        ['.eslintrc.js'] = {
          icon = devicons['eslint'],
          color = '#2c739e',
          name = 'Eslintrc',
        },
        ['.eslintrc.cjs'] = {
          icon = devicons['eslint'],
          color = '#2c739e',
          name = 'Eslintrc',
        },
        ['.eslintrc.json'] = {
          icon = devicons['eslint'],
          color = '#2c739e',
          name = 'Eslintrc',
        },
        ['.eslintrc.yaml'] = {
          icon = devicons['eslint'],
          color = '#2c739e',
          name = 'Eslintrc',
        },
        ['http'] = {
          icon = devicons['http'],
          color = '#519aba',
          name = 'Http',
        },
        ['makefile'] = {
          icon = devicons['makefile'],
          color = '#f1502f',
          name = 'Makefile',
        },
        ['.nvmrc'] = {
          icon = devicons['.nvmrc'],
          color = '#005500',
          name = '.nvmrc',
        },
        ['.npmrc'] = {
          icon = devicons['.npmrc'],
          color = '#007700',
          name = '.npmrc',
        },
        ['package.json'] = {
          icon = devicons['package.json'],
          color = '#e8274b',
          name = 'PackageJson',
        },
        ['package-lock.json'] = {
          icon = devicons['package-lock.json'],
          color = '#7a0d21',
          name = 'PackageLockJson',
        },
        ['.prettierrc'] = {
          icon = devicons['.prettierrc'],
          color = '#b11a7c',
          name = '.prettierrc',
        },
        ['.prettierignore'] = {
          icon = devicons['.prettierignore'],
          color = '#580d3e',
          name = '.prettierignore',
        },
        ['tags'] = {
          icon = devicons['tags'],
          color = '#bbbbbb',
          name = 'Tags',
        },
        ['tailwind.config.js'] = {
          icon = devicons['tailwind.config.js'],
          color = '#4DB6AC',
          name = 'tailwind',
        },
        ['tailwind.config.cjs'] = {
          icon = devicons['tailwind.config.cjs'],
          color = '#4DB6AC',
          name = 'tailwind',
        },
        ['tailwind.config.ts'] = {
          icon = '󱏿',
          color = '#4DB6AC',
          name = 'tailwind',
        },
        ['tailwind.config.cts'] = {
          icon = devicons['tailwind.config.cts'],
          color = '#4DB6AC',
          name = 'tailwind',
        },
        ['tsconfig.json'] = {
          icon = devicons['tsconfig.json'],
          color = '#519aba',
          name = 'tsconfig.json',
        },
        ['tsconfig.node.json'] = {
          icon = '',
          color = '#519aba',
          name = 'tsconfig.node.json',
        },
        ['tsconfig.test.json'] = {
          icon = devicons['tsconfig.test.json'],
          color = '#519aba',
          name = 'tsconfig.json',
        },
        ['vite.config.cts'] = {
          icon = devicons['vite.config'],
          color = '#7c0e8a',
          name = 'vite.config.cts',
        },
        ['vite.config.cjs'] = {
          icon = devicons['vite.config'],
          color = '#7c0e8a',
          name = 'vite.config.cs',
        },
        ['vite.config.js'] = {
          icon = devicons['vite.config'],
          color = '#7c0e8a',
          name = 'vite.config.js',
        },
        ['vite.config.ts'] = {
          icon = devicons['vite.config'],
          color = '#7c0e8a',
          name = 'vite.config.ts',
        },
      },
    })
  end,
}
