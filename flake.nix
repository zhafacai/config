{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixgl.url = "github:nix-community/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs={ nixpkgs, nixgl, ...}:
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
            vtsls

            # nix
            nixd

            # cli
            opencode
            yazi
            neovim
            ghostty
            jq

            #flake
            pkgs.nixgl.nixGLIntel
          ];
        };
      };
}
