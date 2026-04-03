{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixgl.url = "github:nix-community/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";
    comfyui-nix.url = "github:utensils/comfyui-nix";
  };
  nixConfig = {
    extra-substituters = [
      "https://comfyui.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "comfyui.cachix.org-1:33mf9VzoIjzVbp0zwj+fT51HG0y31ZTK3nzYZAX0rec="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  outputs =
    {
      nixpkgs,
      nixgl,
      comfyui-nix,
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

          # fennel
          fnlfmt

          # lua
          stylua
          lua-language-server
          luajit

          vscode-json-languageserver
          shfmt
          black

          # nix
          nixd
          nixfmt

          #ai
          llama-cpp-rocm
          open-webui
          comfyui-nix.packages.${system}.rocm

          # cli
          opencode
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
