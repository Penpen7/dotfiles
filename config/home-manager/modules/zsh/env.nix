{ osConfig, ... }:
{
  home.sessionVariables = {
    HOMEBREW_PREFIX = osConfig.homebrew.prefix;
    LC_ALL = "ja_JP.UTF-8";
    GOPATH = "$HOME/go";
    GOBIN = "$HOME/go/bin";
    LDFLAGS = "\${LDFLAGS} -L/usr/local/lib";
    CPPFLAGS = "\${CPPFLAGS} -I/usr/local/include";
    PKG_CONFIG_PATH = "\${PKG_CONFIG_PATH} /usr/local/pkgconfig";
    FZF_DEFAULT_OPS = "--extended";
    EDITOR = "nvim";
    GIT_EDITOR = "nvim";
    HOMEBREW_NO_ANALYTICS = "1";
    HOMEBREW_NO_GOOGLE_ANALYTICS = "1";
    POWERLINE_COMMAND = "powerline";
  };
}
