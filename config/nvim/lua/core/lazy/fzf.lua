return (
  {
    { "junegunn/fzf", dir = "@fzfWrapper@", merged = 0 },
    {
      "nvim-telescope/telescope.nvim",
      dir = "@telescopeNvim@",
      tag = "0.1.4",
      dependencies = {
        { "nvim-lua/plenary.nvim",              dir = "@plenaryNvim@" },
        { 'Penpen7/telescope-co-author.nvim',   dir = "@telescopeCoAuthor@" },
      },
      keys = { "<leader>f" },
      config = function()
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>fp', builtin.find_files, {})
        vim.keymap.set('n', '<leader>fgr', builtin.live_grep, {})
        vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
        vim.keymap.set('n', '<leader>fgc', builtin.git_commits, {})
        vim.keymap.set('n', '<leader>fgs', builtin.git_status, {})

        local telescope = require("telescope")

        telescope.setup({
          extensions = {
            co_author = {}
          },
        })
        telescope.load_extension('co_author')

        -- GoTo code navigation
        vim.keymap.set("n", "gd", builtin.lsp_definitions,      { silent = true })
        vim.keymap.set("n", "gy", builtin.lsp_type_definitions,  { silent = true })
        vim.keymap.set("n", "gi", builtin.lsp_implementations,   { silent = true })
        vim.keymap.set("n", "gr", builtin.lsp_references,        { silent = true })
        vim.keymap.set("n", "<leader>fc", ":Telescope co_author<CR>", { silent = true })

        -- LSP ピッカー
        vim.keymap.set("n", "<space>a", builtin.diagnostics,           { silent = true })
        vim.keymap.set("n", "<space>o", builtin.lsp_document_symbols,  { silent = true })
        vim.keymap.set("n", "<space>s", builtin.lsp_workspace_symbols, { silent = true })
      end
    },
  }
)
