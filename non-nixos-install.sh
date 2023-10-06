#!/usr/bin/env bash

nix build .#homeConfigurations.alex.activationPackage

# active home manager config
./result/activate