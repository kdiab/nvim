-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- vim settings
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.netrw_banner = 0                                  -- gets rid of the annoying banner for netrw
vim.g.netrw_altv = 1                                    -- change from left splitting to right splitting
vim.g.netrw_liststyle = 3                               -- tree style view in netrw
vim.opt.backup = false
vim.opt.compatible = false                              -- turn off vi compatibility mode
vim.opt.number = true                                   -- turn on line numbers
vim.opt.cursorline = true                               -- add cursor line
vim.opt.mouse = 'r'                                     -- enable the mouse in all modes
vim.opt.ignorecase = true                               -- enable case insensitive searching
vim.opt.smartcase = true                                -- all searches are case insensitive unless there's a capital letter
vim.opt.incsearch = true                                -- enable incremental searching
vim.opt.wrap = true                                     -- enable text wrapping
vim.opt.tabstop = 2                                     -- tabs=4spaces
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.fileencoding = "utf-8"                          -- encoding set to utf-8
vim.opt.pumheight = 10                                  -- number of items in popup menu
vim.opt.signcolumn = "yes"
vim.opt.expandtab = true                                -- expand tab 
vim.opt.smartindent = true
vim.opt.showmode = true
vim.opt.scrolloff = 10                                  -- scroll page when cursor is 10 lines from top/bottom
vim.opt.sidescrolloff = 30                              -- scroll page when cursor is 30 spaces from left/right
vim.opt.guifont = "monospace:h18"                       -- set font + size	
vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt = { "menuone", "noselect" }         -- don't select first option when autocompleting
vim.opt.splitbelow = true                               -- split go below
vim.opt.splitright = true                               -- vertical split to the right
vim.opt.termguicolors = true                            -- terminal gui colors
vim.opt.undofile = true                                 -- enable persistent undo
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"     -- set undo directory

-- vim cmd commands:
-- functional wrapper for mapping custom keybindings
function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- open file and place cursor at last known location
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
      vim.cmd("normal! g`\"")
    end
  end,
})

-- NORMAL MODE --

-- Tab bindings 
map("n", "<leader>n", ":tabnew<CR>")                    -- creates new tab
map("n", "<leader>d", ":tabclose<CR>")                  -- closes current tab
map("n", "<leader>[", ":tabprevious<CR>")               -- moves to previous tab
map("n", "<leader>]", ":tabnext<CR>")                   -- moves to next tab

-- easy split generation
map("n", "<leader>\\", ":vsplit ")                      -- creates a veritcal split
map("n", "<leader>-", ":split ")                        -- creates a horizontal split

-- easy split navigation
map("n", "<C-h>", "<C-w>h")                             -- switches to left split
map("n", "<C-l>", "<C-w>l")                             -- switches to right split
map("n", "<C-j>", "<C-w>j")                             -- switches to bottom split
map("n", "<C-k>", "<C-w>k")                             -- switches to top split

-- buffer navigation
map("n", "<Tab>", ":bnext<CR>")                         -- cycle next buffer
map("n", "<S-Tab>", ":bprevious<CR>")                   -- cycle previous buffer

-- adjust split sizes easier
map("n", "<C-Left>", ":vertical resize +3<CR>")         -- resizes vertical split +
map("n", "<C-Right>", ":vertical resize -3<CR>")        -- resizes vertical split -

-- misc
map('n', '<Esc>', '<cmd>nohlsearch<CR>')                -- remove highlight when esc is pressed	
map('n', '<leader>f', ':find ')                         -- find file and open it in :edit
map('n', '<leader>m', ':!ctags -R .<CR><ESC>')          -- gen ctags
map("n", "K", ":m .-2<CR>==")						                -- move current line up 
map("n", "J", ":m .+1<CR>==")                           -- move current line down

-- VISUAL MODE--
map("v", "<C-s>", ":sort<CR>")                          -- sort highlighted text
map("v", "J", ":m '>+1<CR>gv-gv")                       -- move selection down
map("v", "K", ":m '<-2<CR>gv-gv")                       -- move selection up

-- INSERT MODE --
map("i", '<C-c>', "<Esc>")								              -- Ctrl-C for Esc

-- setup lazy.nvim
require("lazy").setup({
  spec = {
    -- theme
    {
      "rose-pine/neovim",
      name = "rose-pine",
      config = function()
        require("rose-pine").setup({
          styles = {
            italic = false,
          },
        })
        vim.cmd.colorscheme("rose-pine")
      end,
    },
    -- telescope
    {
      'nvim-telescope/telescope.nvim', tag = 'v0.1.9',
      dependencies = { 'nvim-lua/plenary.nvim' },
      config = function()
        local builtin = require('telescope.builtin')

        vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
        vim.keymap.set('n', '<leader>fg', builtin.git_files, { desc = 'Find git files' })
        vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = 'Recent files' })
        vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })
        vim.keymap.set('n', '<leader>/', builtin.live_grep, { desc = 'Live grep' })
        vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = 'Find word under cursor' })
        vim.keymap.set('n', '<C-f>', builtin.current_buffer_fuzzy_find, { desc = 'Find in current buffer' })
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
        vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = 'Keymaps' })
        vim.keymap.set('n', '<leader>fm', builtin.marks, { desc = 'Marks' })
        vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = 'Git commits' })
        vim.keymap.set('n', '<leader>gs', builtin.git_status, { desc = 'Git status' })
      end,
    },
    -- treesitter
    {
      "nvim-treesitter/nvim-treesitter",
      branch = 'master',
      lazy = false,
      build = ":TSUpdate",
      config = function()
        local configs = require("nvim-treesitter.configs")
        configs.setup({
          ensure_installed = { "c", "lua", "cpp", "vim", "vimdoc","markdown", "markdown_inline" },
          sync_install = false,
          auto_install = true,
          highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
          },
          indent = { enable = true },
        })
      end
    },
    -- LSP 
    {
      "neovim/nvim-lspconfig",
      dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
      },
      config = function()
        require("mason").setup()
        require("mason-lspconfig").setup({
          ensure_installed = { "lua_ls", "clangd" },
          automatic_installation = true,
        })
        local coq = require("coq")

        vim.lsp.config('*', {
          capabilities = {
            workspace = {
              didChangeWatchedFiles = {
                dynamicRegistration = true,
              },
            },
          },
        })

        vim.api.nvim_create_autocmd('LspAttach', {
          callback = function(args)
            local opts = { buffer = args.buf, noremap = true, silent = true }
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts) -- goto definition
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts) -- goto declaration
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts) -- goto references
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts) -- goto implementation
            vim.keymap.set('n', '<C-d>', vim.lsp.buf.hover, opts) -- docs
            vim.keymap.set('n', '<C-a>', vim.lsp.buf.code_action, opts) -- show fixes
            vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts) -- global rename
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
          end,
        })

        vim.lsp.config('lua_ls', coq.lsp_ensure_capabilities({
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
            },
          },
        }))

        vim.lsp.enable('lua_ls')
        vim.lsp.config('clangd', coq.lsp_ensure_capabilities({}))
        vim.lsp.enable('clangd')
      end,
    },
    -- coq
    {
      'ms-jpq/coq_nvim',
      branch = 'coq',
      build = ':COQdeps',
      init = function()
        vim.g.coq_settings = {
          auto_start = 'shut-up',
          keymap = {
            recommended = false,
          },
        }
      end,
    },
    {
      'ms-jpq/coq.artifacts',
      branch = 'artifacts',
    },
    -- undo tree
    {
      'mbbill/undotree',
      config = function()
        vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
      end,
    },
  },
  -- misc
  install = { colorscheme = { "rose-pine" } },
  checker = { enabled = false },
  rocks = { enabled = false },
})

-- Disable stuff
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.python3_host_prog = vim.fn.expand('~/.pyenv/versions/neovim/bin/python')
