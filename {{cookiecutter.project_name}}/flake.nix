{
  description = "{{ cookiecutter.project_name }}";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
    easy-purescript-nix = {
      url = "github:justinwoo/easy-purescript-nix";
      flake = false;
    };
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };
  outputs = { self, nixpkgs, easy-purescript-nix, ... }@inputs:
    let
      name = "{{ cookiecutter.project_name }}";

      supportedSystems = [
        "aarch64-darwin"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
    in
    {
      devShell = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };

          easy-ps = import easy-purescript-nix { inherit pkgs; };
        in
        pkgs.mkShell {
          inherit name;
          buildInputs = (with pkgs; [
            nodejs-14_x
            nixpkgs-fmt
          ]) ++ (with easy-ps; [
            purs-0_15_4
            purs-tidy
            psa
            spago
            purescript-language-server
          ]) ++ (pkgs.lib.optionals (system == "aarch64-darwin")
            (with pkgs.darwin.apple_sdk.framework; [
              Cocoa
              CoreServices
            ]));
        });
    };
}
