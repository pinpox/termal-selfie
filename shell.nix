{ packages, pkgs ? import <nixpkgs> { } }:
with pkgs;
mkShell {
  buildInputs = with pkgs.python3Packages; [

    python-periphery
    packages.python-escpos
    opencv4
  ];

  shellHook = ''
    # ...
  '';
}
