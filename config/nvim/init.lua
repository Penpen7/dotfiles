require("core")
require("key_mapping")
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	"folke/which-key.nvim",
	{
		"morhetz/gruvbox",
		config = function()
			vim.cmd([[
        let g:airline_powerline_fonts = 1
        let g:gruvbox_contrast_dark = 'medium'
        let g:gruvbox_transparent_bg = 1
        autocmd SourcePost * highlight Normal     ctermbg=NONE guibg=NONE
        \ |    highlight LineNr     ctermbg=NONE guibg=NONE
        \ |    highlight SignColumn ctermbg=NONE guibg=NONE
        colorscheme gruvbox
      ]])
		end,
	},
	"tpope/vim-endwise",
	"tpope/vim-surround",
	"tpope/vim-fugitive",
	"tomtom/tcomment_vim",
	"github/copilot.vim",
	"SirVer/ultisnips",
	"honza/vim-snippets",
	"rickhowe/diffchar.vim",
	"dhruvasagar/vim-table-mode",
	"machakann/vim-highlightedyank",
	"godlygeek/tabular",
	"rbgrouleff/bclose.vim",
	{
		"mbbill/undotree",
		config = function()
			vim.api.nvim_set_keymap("n", "<Leader>u", "[undotree-p]", {})
			vim.api.nvim_set_keymap("n", "[undotree-p]", ":UndotreeToggle<CR>", { noremap = true })
		end,
	},
	{
		"phaazon/hop.nvim",
		config = function()
			require("hop").setup()
			vim.api.nvim_set_keymap("n", "<Leader><Leader>", "[hop]", {})
			vim.api.nvim_set_keymap("x", "<Leader><Leader>", "[hop]", {})
			vim.api.nvim_set_keymap("n", "[hop]w", ":HopWord<CR>", { silent = true, noremap = true })
			vim.api.nvim_set_keymap("n", "[hop]l", ":HopLine<CR>", { silent = true, noremap = true })
			vim.api.nvim_set_keymap("n", "[hop]f", ":HopChar1<CR>", { silent = true, noremap = true })
		end,
	},
	{ "folke/neoconf.nvim", cmd = "Neoconf" },
	"folke/neodev.nvim",
	"diepm/vim-rest-console",
	{ "hashivim/vim-terraform", ft = "tf" },
	"aklt/plantuml-syntax",
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},
	"lambdalisue/nerdfont.vim",
	{ "lambdalisue/fern-renderer-nerdfont.vim", dependencies = "lambdalisue/fern.vim" },
	{ "lambdalisue/fern-git-status.vim", dependencies = "lambdalisue/fern.vim" },
	{
		"lambdalisue/glyph-palette.vim",
		config = function()
			vim.cmd([[
        augroup my-glyph-palette
          autocmd! *
          autocmd FileType fern call glyph_palette#apply()
          autocmd FileType nerdtree,startify call glyph_palette#apply()
        augroup END
    ]])
		end,
	},
	{
		"lambdalisue/fern.vim",
		config = function()
			vim.cmd([[
let g:fern#default_hidden=1
let g:fern#renderer = 'nerdfont'
    ]])
			vim.api.nvim_set_keymap("n", "<C-e>", ":Fern . -reveal=% -drawer -toggle -width=40<CR>", { noremap = true })
			vim.api.nvim_set_keymap("n", "<C-e><C-e", ":Fern .<CR>", { noremap = true })
		end,
	},
	{
		"vim-test/vim-test",
		config = function()
			vim.api.nvim_set_keymap("n", "<Leader>t", "[vim-test]", {})
			vim.api.nvim_set_keymap("x", "<Leader>t", "[vim-test]", {})
			vim.api.nvim_set_keymap("n", "[vim-test]n", ":TestNearest<CR>", { silent = true })
			vim.api.nvim_set_keymap("n", "[vim-test]f", ":TestFile<CR>", { silent = true })
			vim.api.nvim_set_keymap("n", "[vim-test]s", ":TestSuite<CR>", { silent = true })
			vim.api.nvim_set_keymap("n", "[vim-test]l", ":TestLast<CR>", { silent = true })
			vim.api.nvim_set_keymap("n", "[vim-test]v", ":TestVisit<CR>", { silent = true })
		end,
	},
	{
		"iberianpig/tig-explorer.vim",
		config = function()
			vim.api.nvim_set_keymap("n", "<Space>g", "<cmd>Tig<CR>", { noremap = true, silent = true })
		end,
		dependencies = { "bclose.vim" },
	},
	{
		"tyru/open-browser.vim",
		config = function()
			vim.g.netrw_nogx = 1 -- disable netrw's gx mapping.
			vim.api.nvim_set_keymap("n", "gx", "<Plug>(openbrowser-smart-search)", {})
			vim.api.nvim_set_keymap("v", "gx", "<Plug>(openbrowser-smart-search)", {})
			vim.api.nvim_set_keymap(
				"n",
				"<Leader>o",
				"<cmd>execute 'OpenBrowser' 'file:///' .. expand('%:p:gs?\\?/?')<CR>",
				{ noremap = true }
			)
		end,
	},
	{
		"liuchengxu/vista.vim",
		config = function()
			vim.api.nvim_set_keymap("n", "<Leader>v", "<cmd>Vista coc<CR>", { noremap = true, silent = true })
		end,
	},
	{
		"ryanoasis/vim-devicons",
		config = function()
			vim.cmd("let g:WebDevIconsUnicodeDecorateFolderNodes = 1")
		end,
	},
	{ "junegunn/fzf", build = "./install --all", merged = 0 },
	{
		"yuki-yano/fzf-preview.vim",
		branch = "release/rpc",
		dependencies = { "fzf" },
		config = function()
			vim.api.nvim_set_keymap("n", "<Leader>f", "[fzf-p]", {})
			vim.api.nvim_set_keymap("x", "<Leader>f", "[fzf-p]", {})
			vim.api.nvim_set_keymap(
				"n",
				"[fzf-p]p",
				":<C-u>FzfPreviewFromResourcesRpc project_mru git<CR>",
				{ silent = true }
			)
			vim.api.nvim_set_keymap("n", "[fzf-p]gs", ":<C-u>FzfPreviewGitStatusRpc<CR>", { silent = true })
			vim.api.nvim_set_keymap("n", "[fzf-p]ga", ":<C-u>FzfPreviewGitActionsRpc<CR>", { silent = true })
			vim.api.nvim_set_keymap("n", "[fzf-p]b", ":<C-u>FzfPreviewBuffersRpc<CR>", { silent = true })
			vim.api.nvim_set_keymap("n", "[fzf-p]B", ":<C-u>FzfPreviewAllBuffersRpc<CR>", { silent = true })
			vim.api.nvim_set_keymap(
				"n",
				"[fzf-p]o",
				":<C-u>FzfPreviewFromResourcesRpc buffer project_mru<CR>",
				{ silent = true }
			)
			vim.api.nvim_set_keymap("n", "[fzf-p]<C-o>", ":<C-u>FzfPreviewJumpsRpc<CR>", { silent = true })
			vim.api.nvim_set_keymap("n", "[fzf-p]g;", ":<C-u>FzfPreviewChangesRpc<CR>", { silent = true })
			vim.api.nvim_set_keymap(
				"n",
				"[fzf-p]/",
				':<C-u>FzfPreviewLinesRpc -- add-fzf-arg=--no-sort --add-fzf-arg=--query="\'"<CR>',
				{ silent = true }
			)
			vim.api.nvim_set_keymap(
				"n",
				"[fzf-p]*",
				':<C-u>FzfPreviewLinesRpc --add-fzf-arg=--no-sort --add-fzf-arg=--query="\'".expand("<cword>")."\'"<CR>',
				{ silent = true }
			)
			vim.api.nvim_set_keymap("n", "[fzf-p]gr", ":<C-u>FzfPreviewProjectGrepRpc<Space>", { silent = true })
			vim.api.nvim_set_keymap(
				"x",
				"[fzf-p]gr",
				"\"sy:FzfPreviewProjectGrepRpc<Space>-F<Space>\".substitute(substitute(@s, '\\n', '', 'g'), '/', '\\\\/', 'g')<CR>",
				{ noremap = true }
			)
			vim.api.nvim_set_keymap("n", "[fzf-p]t", ":<C-u>FzfPreviewBufferTagsRpc<CR>", { silent = true })
			vim.api.nvim_set_keymap("n", "[fzf-p]q", ":<C-u>FzfPreviewQuickFixRpc<CR>", { silent = true })
			vim.api.nvim_set_keymap("n", "[fzf-p]l", ":<C-u>FzfPreviewLocationListRpc<CR>", { silent = true })
		end,
	},
	"itchyny/calendar.vim",
	"mattn/emmet-vim",
	{
		"nvim-treesitter/nvim-treesitter",
		version = false,
		event = { "CursorHold", "CursorHoldI" },
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "c" },
				ignore_install = { "phpdoc", "swift" },
				highlight = {
					enable = true,
				},
			})
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		config = function()
			require("nvim-ts-autotag").setup({
				autotag = { enable = true },
			})
		end,
	},
	{
		"p00f/nvim-ts-rainbow",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-treesitter.configs").setup({
				rainbow = {
					enable = true,
					extended_mode = true,
					max_file_lines = 1000,
				},
			})
		end,
	},
	{
		"thinca/vim-quickrun",
		config = function()
			if not vim.g.quickrun_config then
				vim.g.quickrun_config = {}
			end
			vim.api.nvim_set_keymap("n", "<Leader>r", ":QuickRun<CR>", { silent = true })
			-- vim.cmd([[
      --       augroup rust_quickrun
      --         autocmd BufNewFile,BufRead *.crs setf rust
      --         autocmd BufNewFile,BufRead *.py  let g:quickrun_config.python = {'command' : 'python3'}
      --         autocmd BufNewFile,BufRead *.rs  let g:quickrun_config.rust = {'exec' : 'cargo run'}
      --         autocmd BufNewFile,BufRead *.crs let g:quickrun_config.rust = {'exec' : 'cargo script %s -- %a'}
      --       augroup END
      --       ]])
		end,
	},
	{
		"iamcco/markdown-preview.nvim",
		ft = { "markdown", "pandoc.markdown", "rmd", "plantuml" },
		build = 'sh -c "cd app && yarn install"',
		config = function()
			vim.g.mkdp_filetypes = { "markdown", "plantuml" }
		end,
	},
	{
		"mattn/sonictemplate-vim",
		config = function()
			vim.g.sonictemplate_vim_template_dir = { "$HOME/template" }
			vim.api.nvim_set_keymap("n", "<Space>y", ":e $HOME/template/cpp<CR>", {})
		end,
	},
	{
		"plasticboy/vim-markdown",
		config = function()
			vim.g.vim_markdown_math = 1
			vim.g.vim_markdown_folding_disabled = 1
			vim.g.vim_markdown_new_list_item_indent = 0
		end,
	},
	{
		"Penpen7/IMEswitcher.nvim",
		build = "make",
		config = function()
			vim.cmd([[
      if has('mac')
        autocmd InsertLeave * :call IMEswitcher#InsertLeave()
        autocmd InsertEnter * :call IMEswitcher#InsertEnter()
        endif
      ]])
		end,
	},
	"dstein64/vim-startuptime",
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup({
				options = {
					theme = "gruvbox",
					section_separators = { "", "" },
					component_separators = { "", "" },
					icons_enabled = true,
				},
			})
		end,
	},
	"nvim-tree/nvim-web-devicons",
	{
		"kdheepak/tabline.nvim",
		config = function()
			require("tabline").setup({
				-- Defaults configuration options
				enable = true,
				options = {
					-- If lualine is installed tabline will use separators configured in lualine by default.
					-- These options can be used to override those settings.
					section_separators = { "", "" },
					component_separators = { "", "" },
					max_bufferline_percent = 66, -- set to nil by default, and it uses vim.o.columns * 2/3
					show_tabs_always = false, -- this shows tabs only when there are more than one tab or if the first tab is named
					show_devicons = true, -- this shows devicons in buffer section
					show_bufnr = false, -- this appends [bufnr] to buffer section,
					show_filename_only = false, -- shows base filename only instead of relative path in filename
					modified_icon = "+ ", -- change the default modified icon
					modified_italic = false, -- set to true by default; this determines whether the filename turns italic if modified
					show_tabs_only = false, -- this shows only tabs instead of tabs + buffers
				},
			})
			vim.cmd([[
      set guioptions-=e " Use showtabline in gui vim
      set sessionoptions+=tabpages,globals " store tabpages and globals in session
    ]])
		end,
		requires = { { "hoob3rt/lualine.nvim", opt = true }, { "kyazdani42/nvim-web-devicons", opt = true } },
	},
	"neovim/nvim-lspconfig",
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup_handlers({
				function(server)
					local opt = {
						-- -- Function executed when the LSP server startup
						-- on_attach = function(client, bufnr)
						--   local opts = { noremap=true, silent=true }
						--   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
						--   vim.cmd 'autocmd BufWritePre * lua vim.lsp.buf.formatting_sync(nil, 1000)'
						-- end,
						capabilities = require("cmp_nvim_lsp").default_capabilities(
							vim.lsp.protocol.make_client_capabilities()
						),
					}
					require("lspconfig")[server].setup(opt)
				end,
			})
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body)
					end,
				},
				sources = {
					{ name = "nvim_lsp" },
					-- { name = "buffer" },
					-- { name = "path" },
				},
				mapping = cmp.mapping.preset.insert({
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-l>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				experimental = {
					ghost_text = true,
				},
			})
		end,
	},
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/vim-vsnip",
})
