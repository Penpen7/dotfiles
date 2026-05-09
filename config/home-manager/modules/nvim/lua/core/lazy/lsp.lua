return {
  -- LSPサーバー設定
  {
    "neovim/nvim-lspconfig",
    dir = "@nvimLspconfig@",
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- 全サーバー共通のデフォルト設定
      vim.lsp.config("*", { capabilities = capabilities })

      -- サーバー個別の設定
      vim.lsp.config("bashls", { filetypes = { "sh", "zsh" } })
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = { diagnostics = { globals = { "vim" } } },
        },
      })
      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            completeUnimported = true,
          },
        },
      })
      vim.lsp.config("golangci_lint_ls", {
        init_options = {
          command = {
            "golangci-lint", "run",
            "--output.json.path", "stdout",
            "--show-stats=false",
            "--issues-exit-code=1",
          },
        },
      })

      -- サーバーを有効化
      vim.lsp.enable({
        "clangd",
        "cssls",
        "cssmodules_ls",
        "jsonls",
        "taplo",
        "yamlls",
        "rust_analyzer",
        "ts_ls",
        "sqls",
        "typos_lsp",
        "gopls",
        "jedi_language_server",
        "golangci_lint_ls",
        "terraformls",
        "bashls",
        "lua_ls",
      })

      -- LspAttach で共通のキーマップを設定
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          local opts = { buffer = bufnr, silent = true }

          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<space>r", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>qf", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "[g", vim.diagnostic.goto_prev, opts)
          vim.keymap.set("n", "]g", vim.diagnostic.goto_next, opts)

          -- カーソル下のシンボルをハイライト
          if client and client.server_capabilities and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = bufnr,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd("CursorMoved", {
              buffer = bufnr,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      -- diagnosticsの表示設定 (Neovim 0.10+)
      vim.diagnostic.config({
        virtual_lines = true,
        virtual_text  = false,
        underline     = true,
        signs         = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN]  = "",
            [vim.diagnostic.severity.HINT]  = "",
            [vim.diagnostic.severity.INFO]  = "",
          },
        },
      })

      vim.opt.updatetime = 300

      -- Goファイル保存時にimport整理
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          vim.lsp.buf.code_action({
            context = { only = { "source.organizeImports" } },
            apply   = true,
          })
        end,
      })
    end,
  },

  -- 補完 (blink.cmp)
  {
    "saghen/blink.cmp",
    dir = "@blinkCmp@",
    dependencies = {
      { "rafamadriz/friendly-snippets", dir = "@friendlySnippets@" },
      { "archie-judd/blink-cmp-words",  dir = "@blinkCmpWords@" },
      { "onsails/lspkind.nvim",         dir = "@lspkindNvim@" },
    },
    opts = {
      keymap = {
        preset        = "default",
        ["<CR>"]      = { "accept", "fallback" },
        ["<C-j>"]     = { "snippet_forward", "fallback" },
        ["<C-k>"]     = { "snippet_backward", "fallback" },
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      },
      completion = {
        menu = {
          winhighlight =
          "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
          draw = {
            components = {
              kind_icon = {
                text = function(ctx)
                  local icon = require("lspkind").symbol_map[ctx.kind] or ""
                  return icon .. " "
                end,
                highlight = function(ctx)
                  return "BlinkCmpKind" .. ctx.kind
                end,
              },
              kind = {
                text = function(ctx)
                  local labels = {
                    Method        = "メソッド",
                    Function      = "関数",
                    Variable      = "変数",
                    Field         = "フィールド",
                    TypeParameter = "型",
                    Constant      = "定数",
                    Class         = "クラス",
                    Interface     = "インターフェース",
                    Struct        = "構造体",
                    Event         = "イベント",
                    Operator      = "演算子",
                    Module        = "モジュール",
                    Property      = "プロパティ",
                    Enum          = "列挙体",
                    Reference     = "リファレンス",
                    Keyword       = "キーワード",
                    File          = "ファイル",
                    Folder        = "ディレクトリ",
                    Color         = "カラー",
                    Unit          = "ユニット",
                    Snippet       = "スニペット",
                    Text          = "テキスト",
                    Constructor   = "コンストラクタ",
                    Value         = "値",
                    EnumMember    = "列挙体のメンバ",
                  }
                  return labels[ctx.kind] or ctx.kind
                end,
                highlight = "BlinkCmpKind",
              },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "words" },
        providers = {
          words = {
            name         = "blink-cmp-words",
            module       = "blink-cmp-words.dictionary",
            max_items    = 3,
            score_offset = -3,
            opts         = { dictionary_search_threshold = 3 },
          },
        },
      },
    },
  },

  -- フォーマッター (conform.nvim)
  {
    "stevearc/conform.nvim",
    dir = "@conformNvim@",
    opts = {
      formatters_by_ft = {
        sh     = { "shfmt" },
        zsh    = { "shfmt" },
        python = { "black" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      formatters = {
        shfmt = { prepend_args = { "-i", "2", "-bn", "-ci", "-sr" } },
      },
    },
  },

  -- リンター (nvim-lint)
  {
    "mfussenegger/nvim-lint",
    dir = "@nvimLint@",
    config = function()
      require("lint").linters_by_ft = {
        python = { "mypy" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },

  -- LSP進捗表示 (fidget.nvim)
  {
    "j-hui/fidget.nvim",
    dir = "@fidgetNvim@",
    opts = {},
  },
}
