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
          # Handle this in a conditional
          echo "/.direnv" >> ./.gitignore
        '';
      in {
        apps = {
          direnv = {
            type = "app";
            program = "${direnv-init}/bin/direnv-init";
          };
        };
      });
}
