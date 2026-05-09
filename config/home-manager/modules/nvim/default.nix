{ pkgs, ... }:
let
  tsParserDirs = pkgs.lib.pipe
    (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: builtins.attrValues p)).dependencies
    [ (map toString) (builtins.concatStringsSep ",") ];
in
{
  home.packages = with pkgs; [
    neovim
    tree-sitter
  ];

  xdg.configFile = {
    "nvim/init.lua".source = ./init.lua;
    "nvim/lua/core/core.lua".source = ./lua/core/core.lua;
    "nvim/lua/core/key_mapping.lua".source = ./lua/core/key_mapping.lua;
    "nvim/lua/core/lazy/ft.lua".source = ./lua/core/lazy/ft.lua;

    "nvim/lua/core/lazy.lua".source = pkgs.replaceVars ./lua/core/lazy.lua {
      lazyNvim = pkgs.vimPlugins.lazy-nvim;
    };

    "nvim/lua/core/lazy/appearance.lua".source = pkgs.replaceVars ./lua/core/lazy/appearance.lua {
      nordNvim = pkgs.vimPlugins.nord-nvim;
      lualineNvim = pkgs.vimPlugins.lualine-nvim;
      nvimWebDevicons = pkgs.vimPlugins.nvim-web-devicons;
      lspProgressNvim = pkgs.vimPlugins.lsp-progress-nvim;
    };

    "nvim/lua/core/lazy/ui.lua".source = pkgs.replaceVars ./lua/core/lazy/ui.lua {
      fernVim = pkgs.vimPlugins.vim-fern;
      fernRendererNerdfont = pkgs.nvimFernRendererNerdfont;
      fernGitStatus = pkgs.nvimFernGitStatus;
      nerdfont = pkgs.nvimNerdfont;
      nvimWebDevicons = pkgs.vimPlugins.nvim-web-devicons;
      glyphPalette = pkgs.nvimGlyphPalette;
      vimDevicons = pkgs.vimPlugins.vim-devicons;
      bufferlineNvim = pkgs.vimPlugins.bufferline-nvim;
      undotree = pkgs.vimPlugins.undotree;
      calendarVim = pkgs.vimPlugins.calendar-vim;
      vimTest = pkgs.vimPlugins.vim-test;
      openBrowserVim = pkgs.vimPlugins.open-browser-vim;
      whichKeyNvim = pkgs.vimPlugins.which-key-nvim;
      vimHighlightedyank = pkgs.vimPlugins.vim-highlightedyank;
      bcloseVim = pkgs.vimPlugins.bclose-vim;
      hopNvim = pkgs.vimPlugins.hop-nvim;
    };

    "nvim/lua/core/lazy/treesitter.lua".source = pkgs.replaceVars ./lua/core/lazy/treesitter.lua {
      aerialNvim = pkgs.vimPlugins.aerial-nvim;
      nvimWebDevicons = pkgs.vimPlugins.nvim-web-devicons;
      nvimTreesitter = pkgs.vimPlugins.nvim-treesitter;
      rainbowDelimitersNvim = pkgs.vimPlugins.rainbow-delimiters-nvim;
      indentBlanklineNvim = pkgs.vimPlugins.indent-blankline-nvim;
      inherit tsParserDirs;
    };

    "nvim/lua/core/lazy/lsp.lua".source = pkgs.replaceVars ./lua/core/lazy/lsp.lua {
      nvimLspconfig = pkgs.vimPlugins.nvim-lspconfig;
      blinkCmp = pkgs.vimPlugins.blink-cmp;
      blinkCmpWords = pkgs.vimPlugins.blink-cmp-words;
      friendlySnippets = pkgs.vimPlugins.friendly-snippets;
      conformNvim = pkgs.vimPlugins.conform-nvim;
      nvimLint = pkgs.vimPlugins.nvim-lint;
      fidgetNvim = pkgs.vimPlugins.fidget-nvim;
      lspkindNvim = pkgs.vimPlugins.lspkind-nvim;
    };

    "nvim/lua/core/lazy/edit.lua".source = pkgs.replaceVars ./lua/core/lazy/edit.lua {
      vimEndwise = pkgs.vimPlugins.vim-endwise;
      vimSurround = pkgs.vimPlugins.vim-surround;
      vimFugitive = pkgs.vimPlugins.vim-fugitive;
      tcommentVim = pkgs.vimPlugins.tcomment_vim;
      tabular = pkgs.vimPlugins.tabular;
      nvimAutopairs = pkgs.vimPlugins.nvim-autopairs;
      copilotLua = pkgs.vimPlugins.copilot-lua;
      copilotChatNvim = pkgs.vimPlugins.CopilotChat-nvim;
      plenaryNvim = pkgs.vimPlugins.plenary-nvim;
      snacksNvim = pkgs.vimPlugins.snacks-nvim;
      claudecodeNvim = pkgs.vimPlugins.claudecode-nvim;
      avanteNvim = pkgs.vimPlugins.avante-nvim;
      dressingNvim = pkgs.vimPlugins.dressing-nvim;
      nuiNvim = pkgs.vimPlugins.nui-nvim;
      imgClipNvim = pkgs.vimPlugins.img-clip-nvim;
      vimTableMode = pkgs.vimPlugins.vim-table-mode;
    };

    "nvim/lua/core/lazy/git.lua".source = pkgs.replaceVars ./lua/core/lazy/git.lua {
      tigExplorer = pkgs.nvimTigExplorer;
      gitsignsNvim = pkgs.vimPlugins.gitsigns-nvim;
    };

    "nvim/lua/core/lazy/fzf.lua".source = pkgs.replaceVars ./lua/core/lazy/fzf.lua {
      fzfWrapper = pkgs.vimPlugins.fzf-wrapper;
      telescopeNvim = pkgs.vimPlugins.telescope-nvim;
      plenaryNvim = pkgs.vimPlugins.plenary-nvim;
      telescopeCoAuthor = pkgs.nvimTelescopeCoAuthor;
    };

    "nvim/lua/core/lazy/utils.lua".source = pkgs.replaceVars ./lua/core/lazy/utils.lua {
      vimStartuptime = pkgs.vimPlugins.vim-startuptime;
    };

    "nvim/lua/core/lazy/ft/html.lua".source = pkgs.replaceVars ./lua/core/lazy/ft/html.lua {
      emmetVim = pkgs.vimPlugins.emmet-vim;
    };
    "nvim/lua/core/lazy/ft/markdown.lua".source = pkgs.replaceVars ./lua/core/lazy/ft/markdown.lua {
      markdownPreviewNvim = pkgs.vimPlugins.markdown-preview-nvim;
      vimMarkdown = pkgs.vimPlugins.vim-markdown;
    };
    "nvim/lua/core/lazy/ft/plantuml.lua".source = pkgs.replaceVars ./lua/core/lazy/ft/plantuml.lua {
      plantumlSyntax = pkgs.vimPlugins.plantuml-syntax;
    };
    "nvim/lua/core/lazy/ft/rest.lua".source = pkgs.replaceVars ./lua/core/lazy/ft/rest.lua {
      vimRestConsole = pkgs.nvimVimRestConsole;
    };
    "nvim/lua/core/lazy/ft/swagger.lua".source = pkgs.replaceVars ./lua/core/lazy/ft/swagger.lua {
      swaggerPreview = pkgs.nvimSwaggerPreview;
    };
    "nvim/lua/core/lazy/ft/terraform.lua".source = pkgs.replaceVars ./lua/core/lazy/ft/terraform.lua {
      vimTerraform = pkgs.vimPlugins.vim-terraform;
    };
    "nvim/lua/core/lazy/ft/ts.lua".source = pkgs.replaceVars ./lua/core/lazy/ft/ts.lua {
      nvimTsAutotag = pkgs.vimPlugins.nvim-ts-autotag;
    };
  };
}
