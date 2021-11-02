{ pkgs, ... }: {
  home.packages = with pkgs; [
    git
    mosh
    rustup

    obconf
    xcompmgr
  ];

  programs.firefox = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userName = "Benjamin Herr";
    userEmail = "git@1d6.org";
  };
}
