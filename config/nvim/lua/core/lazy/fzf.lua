return (
  {
    { "junegunn/fzf", build = "./install --all", merged = 0 },
    {
      "nvim-telescope/telescope.nvim",
      tag = "0.1.4",
      dependencies = {
        "nvim-lua/plenary.nvim",
        'fannheyward/telescope-coc.nvim',
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
            coc = {
              theme = 'dropdown',
              prefer_locations = true,    -- always use Telescope locations to preview definitions/declarations/implementations etc
              push_cursor_on_edit = true, -- save the cursor position to jump back in the future
              timeout = 3000,             -- timeout for coc commands
            }
          },
        })
        telescope.load_extension('coc')

        -- GoTo code navigation
        vim.keymap.set("n", "gd", ":Telescope coc definitions<CR>", { silent = true })
        vim.keymap.set("n", "gy", ":Telescope coc type_definitions<CR>", { silent = true })
        vim.keymap.set("n", "gi", ":Telescope coc implementations<CR>", { silent = true })
        vim.keymap.set("n", "gr", ":Telescope coc references<CR>", { silent = true })
      end
    },
  }
)
