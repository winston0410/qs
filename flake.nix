{
  description = "Scripts for initialize projects";

  inputs = {
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs = { nixpkgs.follows = "nixpkgs"; };
    };
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = (import nixpkgs { inherit system; });
        direnv-init = pkgs.writeScriptBin "direnv-init" ''
          #!/usr/bin/env bash
          echo "use flake" > ./.envrc
          direnv allow
          if test -f "./.gitignore" && ! grep -q ".direnv" "./.gitignore"; then
              echo "**/.direnv" >> ./.gitignore
          fi
          echo "Direnv has been set up!"
        '';
      in {
        defaultApp = direnv-init;
        apps = {
          direnv = {
            type = "app";
            program = "${direnv-init}/bin/direnv-init";
          };
        };
      });
}
