{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixgl.url = "github:nix-community/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";
  };
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  outputs =
    {
      nixpkgs,
      nixgl,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ nixgl.overlay ];
        config.allowUnfree = true;
      };
    in
    {
      packages."${system}".default = pkgs.buildEnv {
        name = "dev-pkgs";
        paths = with pkgs; [
          # web
          nodejs
          pnpm
          bun
          tailwindcss-language-server
          typescript-go

          # python
          ty
          ruff
          rassumfrassum
          black

          # lua
          stylua
          lua-language-server
          luajit

          vscode-json-languageserver
          shfmt

          # nix
          nixd
          nixfmt

          # cli
          opencode
          codex
          yazi
          ghostty
          jq
          neovim

          #flake
          pkgs.nixgl.nixGLIntel
        ];
      };
    };
}
