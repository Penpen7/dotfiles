return (
  {
    { "junegunn/fzf", build = "./install --all", merged = 0 },
    {
      "nvim-telescope/telescope.nvim",
      tag = "0.1.4",
      dependencies = "nvim-lua/plenary.nvim",
      keys = { "<leader>f" },
      config = function()
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>fp', builtin.find_files, {})
        vim.keymap.set('n', '<leader>fgr', builtin.live_grep, {})
        vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
        vim.keymap.set('n', '<leader>fgc', builtin.git_commits, {})
        vim.keymap.set('n', '<leader>fgs', builtin.git_status, {})
      end
    },
  }
)
