{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    llm-agents.url = "github:numtide/llm-agents.nix";
  };
  nixConfig = {
    extra-substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://nix-community.cachix.org"
      "https://cache.numtide.com"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };
  outputs =
    {
      nixpkgs,
      llm-agents,
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
        paths =
          (with pkgs; [
            # cli
            opencode
            codex
          ])
          ++ (with llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
            gemini-cli
            qwen-code
            qoder-cli-cn
            zcode
          ]);
      };
    };
}
