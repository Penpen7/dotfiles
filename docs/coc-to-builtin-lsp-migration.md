# coc.nvim → Neovim Built-in LSP 移行計画

## 概要

coc.nvimはNode.jsベースのLSPクライアントで、NeovimのbuiltinのLSPとは別レイヤーで動作する。
Neovim 0.5以降に内蔵されたLSPクライアントとnvim-lspconfigを使うことで、
外部依存を減らし、Luaネイティブな設定に統一できる。

### 移行対象ファイル

| ファイル | 変更内容 |
|---|---|
| `config/home-manager/home.nix` | プラグインの追加・削除 |
| `config/nvim/lua/core/lazy/lsp.lua` | 全面書き換え |
| `config/nvim/lua/core/lazy/fzf.lua` | telescope-coc → built-in LSPピッカー |
| `config/nvim/lua/core/lazy/appearance.lua` | lualineにlsp-progressを追加 |
| `config/nvim/coc-settings.json` | 削除 |

---

## 削除するプラグイン

### home.nix から削除するNixパッケージ

```nix
# lsp.lua の replaceVars から削除
cocNvim         = pkgs.vimPlugins.coc-nvim;
cocClangd       = pkgs.vimPlugins.coc-clangd;
cocCss          = pkgs.vimPlugins.coc-css;
cocDiagnostic   = pkgs.vimPlugins.coc-diagnostic;
cocJson         = pkgs.vimPlugins.coc-json;
cocLua          = pkgs.vimPlugins.coc-lua;
cocPairs        = pkgs.vimPlugins.coc-pairs;
cocRustAnalyzer = pkgs.vimPlugins.coc-rust-analyzer;
cocSnippets     = pkgs.vimPlugins.coc-snippets;
cocToml         = pkgs.vimPlugins.coc-toml;
cocYaml         = pkgs.vimPlugins.coc-yaml;

# fzf.lua の replaceVars から削除
telescopeCocNvim = pkgs.vimPlugins.telescope-coc-nvim;
```

### グローバル拡張 (lsp.luaのvim.g.coc_global_extensions) は設定ごと削除

- `coc-cssmodules`, `coc-jedi`, `coc-go`, `coc-sql`, `coc-tsserver`, `coc-typos`, `coc-word`

> **coc-word について**: google-10000-english（英単語上位1万語）をソースとする単語補完。
> blink.cmpの拡張 **`blink-cmp-words`**（`pkgs.vimPlugins.blink-cmp-words`）で代替可能。
> WordNetベースで定義・類義語付き補完が可能。外部依存なし（WordNet 3.0を同梱）。

---

## 追加するプラグイン

### home.nix に追加するNixパッケージ

| 役割 | nixpkgsパッケージ名 | Nix変数名 (仮) |
|---|---|---|
| LSPサーバー設定 | `pkgs.vimPlugins.nvim-lspconfig` | `nvimLspconfig` |
| 補完エンジン | `pkgs.vimPlugins.blink-cmp` | `blinkCmp` |
| 単語補完 (coc-word代替) | `pkgs.vimPlugins.blink-cmp-words` | `blinkCmpWords` |
| スニペット集 | `pkgs.vimPlugins.friendly-snippets` | `friendlySnippets` |
| フォーマッター | `pkgs.vimPlugins.conform-nvim` | `conformNvim` |
| リンター | `pkgs.vimPlugins.nvim-lint` | `nvimLint` |
| LSP進捗UI | `pkgs.vimPlugins.fidget-nvim` | `fidgetNvim` |
| 補完アイコン | `pkgs.vimPlugins.lspkind-nvim` | `lspkindNvim` |

#### 各プラグインの説明

[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
coc.nvimはLSPクライアントと拡張（coc-go, coc-tsserver等）が一体化していたが、Neovim built-in LSPはクライアント機能だけを持ち、各言語サーバーの起動設定は別途用意する必要がある。nvim-lspconfigはその設定集で、`lspconfig.gopls.setup({})` のように書くだけで言語サーバーの起動コマンドやルートディレクトリ検出を設定してくれる。Neovim公式管理のリポジトリ。

[blink.cmp](https://github.com/saghen/blink.cmp)
coc.nvimは補完UIも内包していたが、built-in LSPには補完UIがない。blink.cmpはその補完UIとロジックを担当するプラグインで、LSP・スニペット・バッファ・パスといった複数の補完ソースをまとめて管理する。内部をRustで実装しており、nvim-cmp（同種の先行プラグイン）より応答が速い。luasnipのような別途スニペットエンジンを必要とせず、friendly-snippetsをそのまま読み込める。

[blink-cmp-words](https://github.com/archie-judd/blink-cmp-words)
coc-wordはgoogle-10000-english（頻出英単語1万語のリスト）を補完候補にするシンプルな拡張だった。blink-cmp-wordsはblink.cmp向けの同種プロバイダーで、Princeton大学のWordNet 3.0を同梱しているためインストール以外の準備が不要。候補には定義や類義語の情報も付くため、単語を探しながら書くドキュメント作業で役立つ。

[friendly-snippets](https://github.com/rafamadriz/friendly-snippets)
coc-snippetsはUltiSnips形式とVSCode形式のスニペットを読み込めたが、このプラグインはVSCode互換のJSON形式で各言語のスニペットをまとめたコレクション。blink.cmpが標準でこの形式を読み込めるため、スニペットエンジンを別途設定せずに補完候補として使える。

[conform.nvim](https://github.com/stevearc/conform.nvim)
coc-settings.jsonの `diagnostic-languageserver.formatFiletypes` でshfmt・blackを呼び出していた部分を引き継ぐプラグイン。`formatters_by_ft` にファイルタイプとコマンドを書くだけで保存時自動フォーマットが動く。LSPのフォーマット（`vim.lsp.buf.format()`）と違い、LSPが起動していない場合でも外部コマンドを直接呼べる。

[nvim-lint](https://github.com/mfussenegger/nvim-lint)
coc-settings.jsonの `diagnostic-languageserver.filetypes` でmypyを呼び出していた部分を引き継ぐプラグイン。`linters_by_ft` でファイルタイプとリンターを対応付けて、BufWritePost等のイベントで非同期実行する。LSPのdiagnosticsとは別レイヤーで動くため、gopls（LSP）とgolangci-lint（リンター）を同時に使うような構成も可能。

[fidget.nvim](https://github.com/j-hui/fidget.nvim)
coc.nvimはステータスラインに `coc#status()` を埋め込むことで「インデックス構築中」などのLSP進捗を表示していた。built-in LSPはその仕組みを持たないため、LSPが起動したのかどうか視覚的にわかりにくい。fidget.nvimはLSP進捗通知（`$/progress`）を受け取ってエディタ右下にトーストとして表示する。設定なしで動き、邪魔にならないサイズで消える。lsp-progress.nvim（既存）はlualineへの組み込みが必要なのに対し、こちらは独立して動作する。

[lspkind.nvim](https://github.com/onsails/lspkind.nvim)
blink.cmpの `draw.components.kind_icon` にフックして補完メニューのアイコンを提供するプラグイン。`symbol_map` にkind名とアイコン文字の対応を持ち、`require("lspkind").symbol_map[ctx.kind]` で取り出して使う。アイコンをblink.cmp側の `appearance.kind_icons` に直書きする方法と機能は同じだが、アイコンセットがプラグイン側でメンテナンスされるため、Nerd Fontsの更新に追従しやすい。

---

## LSPサーバー対応表

| coc拡張 | nvim-lspconfig サーバー名 | 備考 |
|---|---|---|
| coc-clangd | `clangd` | |
| coc-css | `cssls` | |
| coc-cssmodules | `cssmodules_ls` | |
| coc-json | `jsonls` | |
| coc-lua | `lua_ls` | `Lua.diagnostics.globals = {"vim"}` 設定必要 |
| coc-rust-analyzer | `rust_analyzer` | |
| coc-toml | `taplo` | |
| coc-yaml | `yamlls` | |
| coc-jedi | `jedi_language_server` | pyright や pylsp も選択肢 |
| coc-go | `gopls` | |
| coc-sql | `sqls` | |
| coc-tsserver | `ts_ls` | |
| coc-typos | `typos_lsp` | |
| golangci-lint-languageserver | `golangci_lint_ls` | nvim-lintへの移行も検討 |
| terraform-ls | `terraformls` | |
| bash-language-server | `bashls` | |

> **coc-word**: 辞書補完。blink.cmpのbuffer/pathソースで代替、
> またはcmp-spellerなどで対応。移行後は一旦省略でよい。

---

## フォーマッター・リンター対応表

### conform.nvim (フォーマッター)

| coc-settings.json の設定 | conform.nvim 設定 |
|---|---|
| `shfmt` for sh/zsh | `formatters_by_ft.sh = {"shfmt"}` |
| `black` for python | `formatters_by_ft.python = {"black"}` |
| format on save (全ファイル) | `format_on_save = { timeout_ms = 500 }` |

### nvim-lint (リンター)

| coc-settings.json の設定 | nvim-lint 設定 |
|---|---|
| `mypy` for python | `linters_by_ft.python = {"mypy"}` |

---

## 実装手順

### Step 1: home.nix のプラグイン更新

**1-a. lsp.lua の replaceVars ブロックを置き換える**

```nix
# 削除: coc関連の変数
# 追加:
"nvim/lua/core/lazy/lsp.lua".source = pkgs.replaceVars ../nvim/lua/core/lazy/lsp.lua {
  nvimLspconfig    = pkgs.vimPlugins.nvim-lspconfig;
  blinkCmp         = pkgs.vimPlugins.blink-cmp;
  blinkCmpWords    = pkgs.vimPlugins.blink-cmp-words;
  friendlySnippets = pkgs.vimPlugins.friendly-snippets;
  conformNvim      = pkgs.vimPlugins.conform-nvim;
  nvimLint         = pkgs.vimPlugins.nvim-lint;
  fidgetNvim       = pkgs.vimPlugins.fidget-nvim;
  lspkindNvim      = pkgs.vimPlugins.lspkind-nvim;
};
```

**1-b. fzf.lua の replaceVars から `telescopeCocNvim` を削除**

```nix
"nvim/lua/core/lazy/fzf.lua".source = pkgs.replaceVars ../nvim/lua/core/lazy/fzf.lua {
  fzfWrapper        = pkgs.fzf;       # (既存)
  telescopeNvim     = pkgs.vimPlugins.telescope-nvim;  # (既存)
  plenaryNvim       = pkgs.vimPlugins.plenary-nvim;    # (既存)
  # telescopeCocNvim を削除
  telescopeCoAuthor = nvimTelescopeCoAuthor;           # (既存)
};
```

**1-c. coc-settings.json の source 行を削除**

```nix
# 削除:
"nvim/coc-settings.json".source = ../nvim/coc-settings.json;
```

---

### Step 2: lsp.lua を全面書き換え

coc.nvimの設定を削除し、以下の構成に置き換える。

```lua
-- lua/core/lazy/lsp.lua

return {
  -- LSPサーバー設定
  {
    "neovim/nvim-lspconfig",
    dir = "@nvimLspconfig@",
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- 共通の on_attach
      local on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, silent = true }

        vim.keymap.set("n", "K",    vim.lsp.buf.hover,           opts)
        vim.keymap.set("n", "<space>r", vim.lsp.buf.rename,      opts)
        vim.keymap.set("n", "<leader>qf", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "[g", vim.diagnostic.goto_prev,      opts)
        vim.keymap.set("n", "]g", vim.diagnostic.goto_next,      opts)

        -- カーソル下のシンボルをハイライト
        if client.supports_method("textDocument/documentHighlight") then
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd("CursorMoved", {
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end

      -- 各LSPサーバー設定
      local servers = {
        clangd        = {},
        cssls         = {},
        cssmodules_ls = {},
        jsonls        = {},
        taplo         = {},
        yamlls        = {},
        rust_analyzer = {},
        ts_ls         = {},
        sqls          = {},
        typos_lsp     = {},
        gopls         = {},
        jedi_language_server = {},
        golangci_lint_ls = {
          init_options = {
            command = {
              "golangci-lint", "run",
              "--output.json.path", "stdout",
              "--show-stats=false",
              "--issues-exit-code=1",
            },
          },
        },
        terraformls   = {},
        bashls        = { filetypes = { "sh", "zsh" } },
        lua_ls        = {
          settings = {
            Lua = { diagnostics = { globals = { "vim" } } },
          },
        },
      }

      for server, config in pairs(servers) do
        config.capabilities = capabilities
        config.on_attach    = on_attach
        lspconfig[server].setup(config)
      end

      -- diagnosticsの表示設定 (Neovim 0.10+)
      -- virtual_lines: coc の "diagnostic.virtualTextAlign": "below" に相当
      -- signs.text: vim.fn.sign_define の代替 (0.10 以降の推奨方法)
      vim.diagnostic.config({
        virtual_lines = true,  -- 行の下に仮想行として表示
        virtual_text  = false, -- インライン表示は無効化
        underline     = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",  -- U+F467 nf-oct-x_circle
            [vim.diagnostic.severity.WARN]  = "",  -- U+F071 nf-fa-exclamation_triangle
            [vim.diagnostic.severity.HINT]  = "",  -- U+F0EB nf-fa-lightbulb_o
            [vim.diagnostic.severity.INFO]  = "",  -- U+F05A nf-fa-info_circle
          },
        },
      })

      -- updatetime
      vim.opt.updatetime = 300

      -- Goファイル保存時にimport整理
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          vim.lsp.buf.code_action({
            context   = { only = { "source.organizeImports" } },
            apply     = true,
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
        preset = "default",
        ["<CR>"]      = { "accept", "fallback" },
        ["<C-j>"]     = { "snippet_forward", "fallback" },
        ["<C-k>"]     = { "snippet_backward", "fallback" },
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      },
      -- draw.components でアイコン (lspkind) と日本語ラベルを設定
      -- appearance.kind_icons は使わない
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
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "words" },
        providers = {
          words = {
            name   = "words",
            module = "blink-cmp-words",
            opts   = { number_of_candidates = 3 },
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
```

---

### Step 3: fzf.lua の更新

`telescope-coc` を削除し、built-in LSPピッカーを使う。

```lua
-- 変更前
{ 'fannheyward/telescope-coc.nvim', dir = "@telescopeCocNvim@" },

-- telescope.setup() の extensions.coc を削除
-- telescope.load_extension('coc') を削除

-- GoTo マッピングを変更
-- 変更前: ":Telescope coc definitions<CR>" など
-- 変更後:
vim.keymap.set("n", "gd", builtin.lsp_definitions,      { silent = true })
vim.keymap.set("n", "gy", builtin.lsp_type_definitions,  { silent = true })
vim.keymap.set("n", "gi", builtin.lsp_implementations,   { silent = true })
vim.keymap.set("n", "gr", builtin.lsp_references,        { silent = true })
```

また、`<space>` 系のマッピングをTelescope経由に統一することも可能:

```lua
-- 追加
vim.keymap.set("n", "<space>a", builtin.diagnostics,      { silent = true })  -- 全diagnostics
vim.keymap.set("n", "<space>o", builtin.lsp_document_symbols,  { silent = true })  -- outline
vim.keymap.set("n", "<space>s", builtin.lsp_workspace_symbols, { silent = true })  -- workspace symbols
```

---

### Step 4: appearance.lua の更新 (任意)

lsp-progress.nvimをlualineのsectionsに組み込む:

```lua
require("lualine").setup({
  options = { ... },  -- 既存
  sections = {
    lualine_c = {
      "filename",
      require("lsp-progress").progress,  -- 追加
    },
  },
})

-- lsp-progress.nvimのイベント購読
vim.api.nvim_create_autocmd("User", {
  pattern  = "LspProgressStatusUpdated",
  callback = require("lualine").refresh,
})
```

---

### Step 5: coc-settings.json の削除

```bash
rm config/nvim/coc-settings.json
```

home.nix からの参照も削除済みであること (Step 1-c) を確認する。

---

### Step 6: Nixの適用

```bash
home-manager switch --flake .#<your-config>
```

---

## 移行後の確認チェックリスト

- [ ] `:LspInfo` でLSPサーバーが各言語で起動していること
- [ ] `gd` で定義ジャンプが動作すること (Telescope経由)
- [ ] `gr` で参照一覧が表示されること
- [ ] `K` でホバードキュメントが表示されること
- [ ] `<space>r` でリネームが動作すること
- [ ] `[g` / `]g` でdiagnosticsナビゲーションが動作すること
- [ ] `<CR>` で補完確定が動作すること
- [ ] Goファイル保存時にimportが自動整理されること
- [ ] Python/shファイル保存時にフォーマットが実行されること
- [ ] `<space>a` でdiagnostics一覧が表示されること
- [ ] `<space>o` でdocument symbolsが表示されること
- [ ] lualineにLSP進捗が表示されること

---

## 注意事項

- coc-pairsの自動ペア機能は既存の `nvim-autopairs` で引き続き対応されるため変更不要。
- `coc-word` (英単語補完) の代替は `blink-cmp-words`。WordNetベースでより高機能（定義・類義語付き）。
- `golangci-lint-languageserver` は `golangci_lint_ls` として nvim-lspconfig でサポートされているが、
  診断の重複を避けるため nvim-lint への移行も検討する価値がある。
- `lsp-progress.nvim` は既にNixパッケージとして存在しており、built-in LSPで動作する。
  今回の移行でようやく有効活用できる。
