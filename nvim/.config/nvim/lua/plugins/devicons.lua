return {
  'nvim-tree/nvim-web-devicons', -- https://github.com/nvim-tree/nvim-web-devicons
  config = function()
    require('nvim-web-devicons').setup({
      override = {
        default_icon = {
          icon = require('core.icons').devicon.default,
          name = 'Default',
        },

        c = {
          icon = require('core.icons').devicon.c,
          name = 'c',
        },

        css = {
          icon = require('core.icons').devicon.css,
          name = 'css',
        },

        dart = {
          icon = require('core.icons').devicon.dart,
          name = 'dart',
        },

        deb = {
          icon = require('core.icons').devicon.deb,
          name = 'deb',
        },

        Dockerfile = {
          icon = require('core.icons').devicon.Dockerfile,
          name = 'Dockerfile',
        },

        html = {
          icon = require('core.icons').devicon.html,
          name = 'html',
        },

        jpeg = {
          icon = require('core.icons').devicon.jpeg,
          name = 'jpeg',
        },

        jpg = {
          icon = require('core.icons').devicon.jpg,
          name = 'jpg',
        },

        js = {
          icon = require('core.icons').devicon.js,
          name = 'js',
        },

        kt = {
          icon = require('core.icons').devicon.kt,
          name = 'kt',
        },

        lock = {
          icon = require('core.icons').devicon.lock,
          name = 'lock',
        },

        lua = {
          icon = require('core.icons').devicon.lua,
          name = 'lua',
        },

        mp3 = {
          icon = require('core.icons').devicon.mp,
          name = 'mp3',
        },

        mp4 = {
          icon = require('core.icons').devicon.mp,
          name = 'mp4',
        },

        out = {
          icon = require('core.icons').devicon.out,
          name = 'out',
        },

        png = {
          icon = require('core.icons').devicon.png,
          name = 'png',
        },

        py = {
          icon = require('core.icons').devicon.py,
          name = 'py',
        },

        ['robots.txt'] = {
          icon = require('core.icons').devicon['robots.txt'],
          name = 'robots',
        },

        toml = {
          icon = require('core.icons').devicon.toml,
          name = 'toml',
        },

        ts = {
          icon = require('core.icons').devicon.ts,
          name = 'ts',
          color = require('core.colors').light_blue,
        },

        ttf = {
          icon = require('core.icons').devicon.ttf,
          name = 'TrueTypeFont',
        },

        rb = {
          icon = require('core.icons').devicon.rb,
          name = 'rb',
        },

        rpm = {
          icon = require('core.icons').devicon.rpm,
          name = 'rpm',
        },

        vue = {
          icon = require('core.icons').devicon.vue,
          name = 'vue',
        },

        woff = {
          icon = require('core.icons').devicon.woff,
          name = 'WebOpenFontFormat',
        },

        woff2 = {
          icon = require('core.icons').devicon.woff,
          name = 'WebOpenFontFormat2',
        },

        xz = {
          icon = require('core.icons').devicon.xz,
          name = 'xz',
        },

        zip = {
          icon = require('core.icons').devicon.zip,
          name = 'zip',
        },

        ['jsx'] = {
          icon = require('core.icons').devicon['jsx'],
          color = '#ccaa00',
          name = 'bun.lockb',
        },
        ['bun.lockb'] = {
          icon = require('core.icons').devicon['bun.lockb'],
          color = '#EEEE00',
          name = 'bun.lockb',
        },
        ['.env'] = {
          icon = require('core.icons').devicon['.env'],
          color = 'gray',
          name = '.env',
        },
        ['.development.env'] = {
          icon = require('core.icons').devicon['.development.env'],
          color = 'gray',
          name = '.development.env',
        },
        ['.eslintignore'] = {
          icon = require('core.icons').devicon['.eslintignore'],
          color = '#1a455f',
          name = '.eslintignore',
        },
        ['.eslintrc'] = {
          icon = require('core.icons').devicon['.eslintrc'],
          color = '#2c739e',
          name = 'Eslintrc',
        },
        ['.eslintrc.js'] = {
          icon = require('core.icons').devicon['.eslintrc.js'],
          color = '#2c739e',
          name = 'Eslintrc',
        },
        ['.eslintrc.cjs'] = {
          icon = require('core.icons').devicon['.eslintrc.cjs'],
          color = '#2c739e',
          name = 'Eslintrc',
        },
        ['.eslintrc.json'] = {
          icon = require('core.icons').devicon['.eslintrc.json'],
          color = '#2c739e',
          name = 'Eslintrc',
        },
        ['.eslintrc.yaml'] = {
          icon = require('core.icons').devicon['.eslintrc.yaml'],
          color = '#2c739e',
          name = 'Eslintrc',
        },
        ['http'] = {
          icon = require('core.icons').devicon['http'],
          color = '#519aba',
          name = 'Http',
        },
        ['makefile'] = {
          icon = require('core.icons').devicon['makefile'],
          color = '#f1502f',
          name = 'Makefile',
        },
        ['.nvmrc'] = {
          icon = require('core.icons').devicon['.nvmrc'],
          color = '#005500',
          name = '.nvmrc',
        },
        ['.npmrc'] = {
          icon = require('core.icons').devicon['.npmrc'],
          color = '#007700',
          name = '.npmrc',
        },
        ['package.json'] = {
          icon = require('core.icons').devicon['package.json'],
          color = '#e8274b',
          name = 'PackageJson',
        },
        ['package-lock.json'] = {
          icon = require('core.icons').devicon['package-lock.json'],
          color = '#7a0d21',
          name = 'PackageLockJson',
        },
        ['.prettierrc'] = {
          icon = require('core.icons').devicon['.prettierrc'],
          color = '#b11a7c',
          name = '.prettierrc',
        },
        ['.prettierignore'] = {
          icon = require('core.icons').devicon['.prettierignore'],
          color = '#580d3e',
          name = '.prettierignore',
        },
        ['tags'] = {
          icon = require('core.icons').devicon['tags'],
          color = '#bbbbbb',
          name = 'Tags',
        },
        ['tailwind.config.js'] = {
          icon = require('core.icons').devicon['tailwind.config.js'],
          color = '#4DB6AC',
          name = 'tailwind',
        },
        ['tailwind.config.cjs'] = {
          icon = require('core.icons').devicon['tailwind.config.cjs'],
          color = '#4DB6AC',
          name = 'tailwind',
        },
        ['tailwind.config.ts'] = {
          icon = '󱏿',
          color = '#4DB6AC',
          name = 'tailwind',
        },
        ['tailwind.config.cts'] = {
          icon = require('core.icons').devicon['tailwind.config.cts'],
          color = '#4DB6AC',
          name = 'tailwind',
        },
        ['tsconfig.json'] = {
          icon = require('core.icons').devicon['tsconfig.json'],
          color = '#519aba',
          name = 'tsconfig.json',
        },
        ['tsconfig.node.json'] = {
          icon = '',
          color = '#519aba',
          name = 'tsconfig.node.json',
        },
        ['tsconfig.test.json'] = {
          icon = require('core.icons').devicon['tsconfig.test.json'],
          color = '#519aba',
          name = 'tsconfig.json',
        },
        ['vite.config.cts'] = {
          icon = '󰹭',
          color = '#7c0e8a',
          name = 'vite.config.ts',
        },
        ['vite.config.cjs'] = {
          icon = require('core.icons').devicon['vite.config.cjs'],
          color = '#7c0e8a',
          name = 'vite.config.ts',
        },
        ['vite.config.js'] = {
          icon = '󰹭',
          color = '#7c0e8a',
          name = 'vite.config.ts',
        },
        ['vite.config.ts'] = {
          icon = require('core.icons').devicon['vite.config.ts'],
          color = '#7c0e8a',
          name = 'vite.config.ts',
        },
      },
    })
  end,
}
