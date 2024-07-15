return {
  "tpope/vim-endwise",
  "tpope/vim-surround",
  "tpope/vim-fugitive",
  "tomtom/tcomment_vim",
  "godlygeek/tabular",
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {}, -- this is equalent to setup({}) function
    config = function()
      -- Enterを押した際にcoc.nvimでの候補が表示されているときには候補を確定させる
      -- coc.nvimでも必要な設定なので、削除する場合にはcoc.nvimに移動させること
      local remap = vim.api.nvim_set_keymap
      local npairs = require('nvim-autopairs')
      npairs.setup({ map_cr = false })

      -- skip it, if you use another global object
      _G.MUtils = {}

      -- old version
      -- MUtils.completion_confirm=function()
      -- if vim.fn["coc#pum#visible"]() ~= 0 then
      -- return vim.fn["coc#_select_confirm"]()
      -- else
      -- return npairs.autopairs_cr()
      -- end
      -- end

      -- new version for custom pum
      MUtils.completion_confirm = function()
        if vim.fn["coc#pum#visible"]() ~= 0 then
          return vim.fn["coc#pum#confirm"]()
        else
          return npairs.autopairs_cr()
        end
      end

      remap('i', '<CR>', 'v:lua.MUtils.completion_confirm()', { expr = true, noremap = true })
    end,
  },
  {
    "github/copilot.vim",
    event = "VimEnter",
    config = function()
      vim.g.copilot_filetypes = { markdown = true, gitcommit = true, yaml = true }
    end
  },
  { "dhruvasagar/vim-table-mode", event = { "InsertEnter" } },
  {
    "Penpen7/IMEswitcher.nvim",
    build = "make",
    events = { "InsertEnter", "InsertLeave" },
    config = function()
      if vim.fn.has("mac") == 1 then
        vim.api.nvim_create_augroup("IMEswitcher", { clear = true })
        vim.api.nvim_create_autocmd("InsertLeave",
          { group = "IMEswitcher", pattern = "*", command = "call IMEswitcher#InsertLeave()" })
        vim.api.nvim_create_autocmd("InsertEnter",
          { group = "IMEswitcher", pattern = "*", command = "call IMEswitcher#InsertEnter()" })
      end
    end,
  },
}
