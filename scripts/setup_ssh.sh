#!/usr/bin/env bash

read -p "Do you want to setup ssh key to this device? (y/N) " yn

if [[ ! $yn =~ ^[Yy]$ ]]; then
  exit 0
fi

ansible-playbook ~/dotfiles/dot_bootstrap/ssh_key.yml --ask-vault-pass

