-- vim settings
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.netrw_banner = 0									-- gets rid of the annoying banner for netrw
vim.g.netrw_altv = 1									-- change from left splitting to right splitting
vim.g.netrw_liststyle=3									-- tree style view in netrw
vim.opt.syntax = "on"
vim.opt.backup = false
vim.opt.compatible = false								-- turn off vi compatibility mode
vim.opt.number = true									-- turn on line numbers
vim.opt.mouse = 'r'										-- enable the mouse in all modes
vim.opt.ignorecase = true								-- enable case insensitive searching
vim.opt.smartcase = true								-- all searches are case insensitive unless there's a capital letter
vim.opt.incsearch = true								-- enable incremental searching
vim.opt.wrap = true										-- enable text wrapping
vim.opt.tabstop = 4										-- tabs=4spaces
vim.opt.shiftwidth = 4
vim.opt.fileencoding = "utf-8"							-- encoding set to utf-8
vim.opt.pumheight = 10									-- number of items in popup menu
vim.opt.signcolumn = "auto"
vim.opt.expandtab = false								-- expand tab 
vim.opt.smartindent = true
vim.opt.showmode = true
vim.opt.scrolloff = 10									-- scroll page when cursor is 10 lines from top/bottom
vim.opt.sidescrolloff = 30								-- scroll page when cursor is 30 spaces from left/right
vim.opt.guifont = "monospace:h18"						-- set font + size	
vim.opt.clipboard = unnamedplus
vim.opt.completeopt= { "menuone", "noselect" }			-- don't select first option when autocompleting
vim.opt.splitbelow = true								-- split go below
vim.opt.splitright = true								-- vertical split to the right
vim.opt.termguicolors = true							-- terminal gui colors

-- vim cmd commands:
-- set path: search down recursively from root
vim.cmd [[
	set path+=**
	colorscheme rosepine
	filetype plugin on
	set wildmenu
]]

-- functional wrapper for mapping custom keybindings
function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- NORMAL MODE --

-- Tab bindings 
map("n", "<leader>t", ":tabnew<CR>")					-- creates new tab
map("n", "<leader>x", ":tabclose<CR>")					-- closes current tab
map("n", "<leader>j", ":tabprevious<CR>")				-- moves to previous tab
map("n", "<leader>k", ":tabnext<CR>")					-- moves to next tab

-- easy split generation
map("n", "<leader>v", ":vsplit ")						-- creates a veritcal split
map("n", "<leader>h", ":split ")						-- creates a horizontal split

-- easy split navigation
map("n", "<C-h>", "<C-w>h")								-- switches to left split
map("n", "<C-l>", "<C-w>l")								-- switches to right split
map("n", "<C-j>", "<C-w>j")								-- switches to bottom split
map("n", "<C-k>", "<C-w>k")								-- switches to top split

-- buffer navigation
map("n", "<Tab>", ":bnext<CR>")							-- cycle next buffer
map("n", "<S-Tab>", ":bprevious<CR>")					-- cycle previous buffer

-- adjust split sizes easier
map("n", "<C-Left>", ":vertical resize +3<CR>")			-- resizes vertical split +
map("n", "<C-Right>", ":vertical resize -3<CR>")		-- resizes vertical split -

-- misc
map('n', '<Esc>', '<cmd>nohlsearch<CR>')				-- remove highlight when esc is pressed	
map('n', '<leader>f', ':find ')							-- find file and open it in :edit
map('n', '<leader>m', ':!ctags -R .<CR><ESC>')			-- gen ctags

-- VISUAL MODE--

map("v", "<leader>r", "\"hy:%s/<C-r>h//g<left><left>")	-- Replace all instances of highlighted words 
map("v", "<C-s>", ":sort<CR>")							-- Sort highlighted text in visual mode with Control+S
map("v", "J", ":m '>+1<CR>gv=gv")						-- Move current line down
map("v", "K", ":m '>-2<CR>gv=gv")						-- Move current line up 

-- INSERT MODE --

map("i", "<C-c>", "<Esc>")								-- Ctrl-C for Esc
