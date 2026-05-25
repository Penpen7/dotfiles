{ pkgs }:
let
  vp = pkgs.vimPlugins;
  src = ./nvim;

  tsParserDirs = pkgs.lib.pipe
    (vp.nvim-treesitter.withPlugins (p: builtins.attrValues p)).dependencies
    [ (map toString) (builtins.concatStringsSep ",") ];

  configDir = pkgs.runCommand "nvim-standalone-config" { } ''
    mkdir -p $out/nvim/lua/core/lazy/ft

    install -m644 ${src}/init.lua                 $out/nvim/init.lua
    install -m644 ${src}/lua/core/core.lua         $out/nvim/lua/core/core.lua
    install -m644 ${src}/lua/core/key_mapping.lua  $out/nvim/lua/core/key_mapping.lua
    install -m644 ${src}/lua/core/lazy/ft.lua      $out/nvim/lua/core/lazy/ft.lua

    install -m644 ${pkgs.replaceVars "${src}/lua/core/lazy.lua" {
      lazyNvim = vp.lazy-nvim;
    }} $out/nvim/lua/core/lazy.lua

    install -m644 ${pkgs.replaceVars "${src}/lua/core/lazy/appearance.lua" {
      nordNvim = vp.nord-nvim;
      lualineNvim = vp.lualine-nvim;
      nvimWebDevicons = vp.nvim-web-devicons;
      lspProgressNvim = vp.lsp-progress-nvim;
    }} $out/nvim/lua/core/lazy/appearance.lua

    install -m644 ${pkgs.replaceVars "${src}/lua/core/lazy/ui.lua" {
      fernVim = vp.vim-fern;
      fernRendererNerdfont = vp.fern-renderer-nerdfont;
      fernGitStatus = vp.fern-git-status;
      nerdfont = vp.nerdfont-vim;
      nvimWebDevicons = vp.nvim-web-devicons;
      glyphPalette = vp.glyph-palette;
      vimDevicons = vp.vim-devicons;
      bufferlineNvim = vp.bufferline-nvim;
      undotree = vp.undotree;
      calendarVim = vp.calendar-vim;
      vimTest = vp.vim-test;
      openBrowserVim = vp.open-browser-vim;
      whichKeyNvim = vp.which-key-nvim;
      vimHighlightedyank = vp.vim-highlightedyank;
      bcloseVim = vp.bclose-vim;
      hopNvim = vp.hop-nvim;
    }} $out/nvim/lua/core/lazy/ui.lua

    install -m644 ${pkgs.replaceVars "${src}/lua/core/lazy/treesitter.lua" {
      aerialNvim = vp.aerial-nvim;
      nvimWebDevicons = vp.nvim-web-devicons;
      nvimTreesitter = vp.nvim-treesitter;
      rainbowDelimitersNvim = vp.rainbow-delimiters-nvim;
      indentBlanklineNvim = vp.indent-blankline-nvim;
      inherit tsParserDirs;
    }} $out/nvim/lua/core/lazy/treesitter.lua

    install -m644 ${pkgs.replaceVars "${src}/lua/core/lazy/lsp.lua" {
      nvimLspconfig = vp.nvim-lspconfig;
      blinkCmp = vp.blink-cmp;
      blinkCmpWords = vp.blink-cmp-words;
      friendlySnippets = vp.friendly-snippets;
      conformNvim = vp.conform-nvim;
      nvimLint = vp.nvim-lint;
      fidgetNvim = vp.fidget-nvim;
      lspkindNvim = vp.lspkind-nvim;
    }} $out/nvim/lua/core/lazy/lsp.lua

    install -m644 ${pkgs.replaceVars "${src}/lua/core/lazy/edit.lua" {
      vimEndwise = vp.vim-endwise;
      vimSurround = vp.vim-surround;
      vimFugitive = vp.vim-fugitive;
      tcommentVim = vp.tcomment_vim;
      tabular = vp.tabular;
      nvimAutopairs = vp.nvim-autopairs;
      copilotLua = vp.copilot-lua;
      copilotChatNvim = vp.CopilotChat-nvim;
      plenaryNvim = vp.plenary-nvim;
      snacksNvim = vp.snacks-nvim;
      claudecodeNvim = vp.claudecode-nvim;
      avanteNvim = vp.avante-nvim;
      dressingNvim = vp.dressing-nvim;
      nuiNvim = vp.nui-nvim;
      imgClipNvim = vp.img-clip-nvim;
      vimTableMode = vp.vim-table-mode;
    }} $out/nvim/lua/core/lazy/edit.lua

    install -m644 ${pkgs.replaceVars "${src}/lua/core/lazy/git.lua" {
      tigExplorer = vp.tig-explorer;
      gitsignsNvim = vp.gitsigns-nvim;
    }} $out/nvim/lua/core/lazy/git.lua

    install -m644 ${pkgs.replaceVars "${src}/lua/core/lazy/fzf.lua" {
      fzfWrapper = vp.fzf-wrapper;
      telescopeNvim = vp.telescope-nvim;
      plenaryNvim = vp.plenary-nvim;
      telescopeCoAuthor = vp.telescope-co-author;
    }} $out/nvim/lua/core/lazy/fzf.lua

    install -m644 ${pkgs.replaceVars "${src}/lua/core/lazy/utils.lua" {
      vimStartuptime = vp.vim-startuptime;
    }} $out/nvim/lua/core/lazy/utils.lua

    install -m644 ${pkgs.replaceVars "${src}/lua/core/lazy/ft/html.lua" {
      emmetVim = vp.emmet-vim;
    }} $out/nvim/lua/core/lazy/ft/html.lua

    install -m644 ${pkgs.replaceVars "${src}/lua/core/lazy/ft/markdown.lua" {
      markdownPreviewNvim = vp.markdown-preview-nvim;
      vimMarkdown = vp.vim-markdown;
    }} $out/nvim/lua/core/lazy/ft/markdown.lua

    install -m644 ${pkgs.replaceVars "${src}/lua/core/lazy/ft/plantuml.lua" {
      plantumlSyntax = vp.plantuml-syntax;
    }} $out/nvim/lua/core/lazy/ft/plantuml.lua

    install -m644 ${pkgs.replaceVars "${src}/lua/core/lazy/ft/rest.lua" {
      vimRestConsole = vp.vim-rest-console;
    }} $out/nvim/lua/core/lazy/ft/rest.lua

    install -m644 ${pkgs.replaceVars "${src}/lua/core/lazy/ft/swagger.lua" {
      swaggerPreview = vp.swagger-preview;
    }} $out/nvim/lua/core/lazy/ft/swagger.lua

    install -m644 ${pkgs.replaceVars "${src}/lua/core/lazy/ft/terraform.lua" {
      vimTerraform = vp.vim-terraform;
    }} $out/nvim/lua/core/lazy/ft/terraform.lua

    install -m644 ${pkgs.replaceVars "${src}/lua/core/lazy/ft/ts.lua" {
      nvimTsAutotag = vp.nvim-ts-autotag;
    }} $out/nvim/lua/core/lazy/ft/ts.lua
  '';
in
pkgs.writeShellApplication {
  name = "nvim";
  runtimeInputs = [ pkgs.neovim pkgs.tree-sitter ];
  text = ''
    exec nvim \
      --cmd "set rtp^=${configDir}/nvim" \
      -u "${configDir}/nvim/init.lua" \
      "$@"
  '';
}
