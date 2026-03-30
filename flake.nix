{
  description = "Wrapper for T3 Codes AppImage with appimage-run (from stable) and expose codex from nixpkgs-unstable (to the package)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      ...
    }:
    let
      version = "0.0.15";
      systems = [
        "x86_64-linux"
        # Currently not supported "aarch64-linux"
      ];

      forAllSystems =
        f:
        nixpkgs.lib.genAttrs systems (
          system:
          f {
            system = system;
            pkgs = import nixpkgs { inherit system; };
            unstable = import nixpkgs-unstable { inherit system; };
          }
        );
    in
    {
      packages = forAllSystems (
        {
          pkgs,
          unstable,
          ...
        }:
        let
          appImage = pkgs.fetchurl {
            url = "https://github.com/pingdotgg/t3code/releases/download/v${version}/T3-Code-${version}-x86_64.AppImage";
            hash = "sha256-Z8y7SWH55+ZC7cRpgo0cdG273rbDiFS3pXQt3up7sDg=";
          };
          wrapper = pkgs.writeShellApplication {
            meta = { inherit version; };
            name = "t3codes";
            runtimeInputs = [
              pkgs.appimage-run
              unstable.codex
            ];
            text = ''
              exec appimage-run "${appImage}" "$@"
            '';
          };
          codex-login = pkgs.writeShellApplication {
            name = "codex-login";
            runtimeInputs = [
              unstable.codex
            ];
            text = ''
              codex login
            '';
          };
        in
        {
          codex-login = codex-login;
          t3codes = wrapper;
          default = wrapper;
        }
      );

      apps = forAllSystems (
        {
          system,
          ...
        }:
        let
          app = {
            type = "app";
            program = self.packages.${system}.t3codes + "/bin/t3codes";
          };
        in
        {
          t3codes = app;
          login = {
            type = "app";
            program = self.packages.${system}.codex-login + "/bin/codex-login";
          };
          default = app;
        }
      );
    };
}
