{ pkgs ? import <nixpkgs> {} }:
    pkgs.mkShell {
        nativeBuildInputs = with  pkgs.buildPackages; [
            verilator
            gtkwave
            yosys
        ];
    }