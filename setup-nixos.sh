#!/usr/bin/env bash

echo "Changing directory"
cd nixos

echo "Setup hardware-configuration.nix"
sudo nixos-generate-config
sudo rm -rf /etc/nixos/configuration.nix

echo "Installing System Flake"
sudo nixos-rebuild switch --flake .

echo "Restarting System"
reboot
