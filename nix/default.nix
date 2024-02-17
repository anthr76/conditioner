{ lib, pkgs ? (
    let
      inherit (builtins) fetchTree fromJSON readFile;
      inherit ((fromJSON (readFile ./flake.lock)).nodes) nixpkgs gomod2nix;
    in
    import (fetchTree nixpkgs.locked) {
      overlays = [
        (import "${fetchTree gomod2nix.locked}/overlay.nix")
      ];
    }
  )
, buildGoApplication ? pkgs.buildGoApplication
}:

buildGoApplication {
  pname = "conditioner";
  version = lib.fileContents ../version.txt;
  pwd = ../.;
  src = ../.;
  modules = ./gomod2nix.toml;
  postInstall = ''
    mv $out/bin/cmd $out/bin/kubectl-condition
  '';
}
