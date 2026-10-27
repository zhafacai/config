{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  nixConfig = {
    extra-substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  outputs =
    {
      nixpkgs,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      packages."${system}".default = pkgs.buildEnv {
        name = "nix-pkgs";
        paths = with pkgs; [
          # cli
          opencode
          codex
          neovim
        ];
      };
    };
}
