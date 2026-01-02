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
    "zbirenbaum/copilot.lua",
    event = { "InsertEnter" },
    config = function()
      require("copilot").setup({
        suggestion = {
          enable = true,
          auto_trigger = true,
          keymap = {
            accept = "<Tab>",
          }
        }
      }
      )
    end,
  },
  {
    {
      "CopilotC-Nvim/CopilotChat.nvim",
      branch = "main",
      dependencies = {
        { "zbirenbaum/copilot.lua" },
        { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
      },
      opts = {
        debug = true, -- Enable debugging
        -- See Configuration section for rest
      },
      -- See Commands section for default commands if you want to lazy load on them
    },
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {},
  },
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = function()
      require("claudecode").setup({
        terminal = {
          split_side = "right",
          split_width_percentage = 0.30,
          provider = "auto",
          auto_close = true
        },
        diff_opts = {
          auto_close_on_accept = true,
          vertical_split = true
        }
      })
    end,
    keys = {
      { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
    },
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false,
    opts = {
      provider = "copilot",
      auto_suggestions_provider = "copilot",

      -- 動作設定
      behaviour = {
        auto_suggestions = false,
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
        minimize_diff = true,
      },

      -- ウィンドウ設定
      windows = {
        position = "bottom", -- サイドバーの位置
        wrap = true,         -- テキストの折り返し
        width = 30,          -- サイドバーの幅
      },
    },
    build = "make",
    -- 依存関係の設定
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "nvim-tree/nvim-web-devicons",   -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua",        -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
    }
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
