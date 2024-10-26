#!/usr/bin/env bash

eww daemon
eww open widgets
eww open center

sleep 3
bash ~/nixos-config/scripts/browser_toggle_url.sh
