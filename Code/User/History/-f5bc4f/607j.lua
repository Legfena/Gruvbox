-- ============================================================================
-- NEOVIM CONFIGURATION - init.lua
-- Place this file at: ~/.config/nvim/init.lua
-- ============================================================================

-- ============================================================================
-- BASIC SETTINGS
-- ============================================================================
vim.o.number = true              -- Show line numbers
vim.o.relativenumber = true      -- Relative line numbers
vim.o.expandtab = true           -- Use spaces instead of tabs
vim.o.shiftwidth = 2             -- Indent width
vim.o.tabstop = 2                -- Tab width
vim.o.termguicolors = true       -- True color support
vim.o.mouse = 'a'                -- Enable mouse
vim.o.ignorecase = true          -- Ignore case in search
vim.o.smartcase = true           -- Unless uppercase is used
vim.o.clipboard = 'unnamedplus'  -- Use system clipboard
vim.o.updatetime = 300           -- Faster completion
vim.o.signcolumn = 'yes'         -- Always show sign column

-- Set leader key (used for custom shortcuts)
vim.g.mapleader = ' '            -- Space as leader key

-- ============================================================================
-- PLUGIN MANAGER SETUP (lazy.nvim)
-- ============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ============================================================================
-- PLUGINS
-- ============================================================================
require("lazy").setup({

  -- ==========================================================================
  -- THEME: Gruvbox Material
  -- A warm, eye-friendly color scheme
  -- ==========================================================================
  {
    "sainnhe/gruvbox-material",
    priority = 1000,
    config = function()
      vim.o.background = "dark"
      vim.g.gruvbox_material_background = "medium"
      vim.g.gruvbox_material_enable_italic = 1
      vim.cmd("colorscheme gruvbox-material")
    end,
  },

  -- ==========================================================================
  -- FILE TREE: nvim-tree
  -- Visual file browser on the left side
  -- Keybinds: <C-n> to toggle, ? for help inside tree
  -- ==========================================================================
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = { width = 30 },
        renderer = { group_empty = true },
        filters = { dotfiles = false },
      })
    end,
  },

  -- ==========================================================================
  -- FUZZY FINDER: Telescope
  -- Quickly find files, search text, browse git history, etc.
  -- Keybinds: <leader>ff (find files), <leader>fg (live grep), etc.
  -- ==========================================================================
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = "move_selection_next",
              ["<C-k>"] = "move_selection_previous",
            },
          },
        },
      })
    end,
  },

  -- ==========================================================================
  -- SYNTAX HIGHLIGHTING: Treesitter
  -- Modern, accurate syntax highlighting and code understanding
  -- Automatically installs parsers for languages you use
  -- ==========================================================================
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { 
          "lua", "vim", "vimdoc", "python", "javascript", "typescript", 
          "html", "css", "json", "bash", "markdown" 
        },
        auto_install = true,
        highlight = { 
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
      })
    end,
  },

  -- ==========================================================================
  -- LSP CONFIGURATION: nvim-lspconfig
  -- Connects to language servers for code intelligence
  -- Provides: autocompletion, go-to-definition, error checking, etc.
  -- ==========================================================================
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",           -- LSP installer
      "williamboman/mason-lspconfig.nvim", -- Bridge between mason & lspconfig
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "pyright", "ts_ls" },
        automatic_installation = true,
      })

      -- Setup language servers using new vim.lsp.config API
      -- Lua
      vim.lsp.config('lua_ls', {
        cmd = { 'lua-language-server' },
        filetypes = { 'lua' },
        root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' },
      })
      
      -- Python
      vim.lsp.config('pyright', {
        cmd = { 'pyright-langserver', '--stdio' },
        filetypes = { 'python' },
        root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', '.git' },
      })
      
      -- JavaScript/TypeScript (updated from tsserver to ts_ls)
      vim.lsp.config('ts_ls', {
        cmd = { 'typescript-language-server', '--stdio' },
        filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' },
        root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' },
      })

      -- Enable language servers
      vim.lsp.enable({ 'lua_ls', 'pyright', 'ts_ls' })

      -- Keybindings for LSP
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover documentation' })
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename symbol' })
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code action' })
    end,
  },

  -- ==========================================================================
  -- AUTOCOMPLETION: nvim-cmp
  -- Smart autocomplete menu as you type
  -- Shows suggestions from LSP, snippets, buffer words, etc.
  -- ==========================================================================
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",     -- LSP completion source
      "hrsh7th/cmp-buffer",        -- Buffer words completion
      "hrsh7th/cmp-path",          -- File path completion
      "L3MON4D3/LuaSnip",          -- Snippet engine
      "saadparwaiz1/cmp_luasnip",  -- Snippet completion source
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        }),
      })
    end,
  },

  -- ==========================================================================
  -- GIT INTEGRATION: gitsigns
  -- Shows git changes in the gutter (added/modified/deleted lines)
  -- Provides git blame, hunk navigation, etc.
  -- ==========================================================================
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add          = { text = '│' },
          change       = { text = '│' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
        },
      })
    end,
  },

  -- ==========================================================================
  -- STATUS LINE: lualine
  -- Beautiful and informative status bar at the bottom
  -- Shows mode, file, git branch, diagnostics, etc.
  -- ==========================================================================
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "gruvbox-material",
          component_separators = '|',
          section_separators = '',
        },
      })
    end,
  },

  -- ==========================================================================
  -- KEYBINDING HELPER: which-key
  -- Shows popup with available keybindings as you type
  -- Example: Press <leader> and wait - shows all leader shortcuts
  -- ==========================================================================
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup({})
    end,
  },

  -- ==========================================================================
  -- COMMENTING: Comment.nvim
  -- Easily toggle comments with gcc (line) or gc (visual mode)
  -- Supports any language automatically
  -- ==========================================================================
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  -- ==========================================================================
  -- AUTO PAIRS: nvim-autopairs
  -- Automatically closes brackets, quotes, etc.
  -- Types: (), [], {}, "", '', etc.
  -- ==========================================================================
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
      -- Integration with nvim-cmp
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- ==========================================================================
  -- INDENT GUIDES: indent-blankline
  -- Shows vertical lines for indentation levels
  -- Makes it easier to see code structure
  -- ==========================================================================
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup({
        indent = { char = "│" },
        scope = { enabled = false },
      })
    end,
  },

})

-- ============================================================================
-- KEYBINDINGS
-- ============================================================================

-- File tree
vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', { desc = 'Toggle file tree' })
vim.keymap.set('n', '<leader>e', ':NvimTreeFocus<CR>', { desc = 'Focus file tree' })

-- Telescope (fuzzy finder)
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })

-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to bottom window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to top window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })

-- Buffer navigation
vim.keymap.set('n', '<S-l>', ':bnext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<S-h>', ':bprevious<CR>', { desc = 'Previous buffer' })

-- Save and quit
vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = 'Save file' })
vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = 'Quit' })

-- ============================================================================
-- END OF CONFIG
-- ============================================================================
-- After saving this file, restart Neovim
-- Plugins will install automatically on first launch
-- Press <leader> (Space) and wait to see available shortcuts
-- ============================================================================