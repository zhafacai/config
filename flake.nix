{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixgl.url = "github:nix-community/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";
    # TODO refactor my config after 0.12
    nvim-nightly.url = "github:nix-community/neovim-nightly-overlay";
  };
  nixConfig = {
    # extra-substituters = [ "https://app.cachix.org/cache/nix-community" ];
    extra-trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
  };
  outputs={ nixpkgs, nixgl, nvim-nightly, ...}:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ nixgl.overlay ];
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

            # cli
            opencode
            yazi
            ghostty
            jq
            nvim-nightly.packages.${system}.default

            #flake
            pkgs.nixgl.nixGLIntel
          ];
        };
      };
}
