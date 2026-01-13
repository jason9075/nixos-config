#!/usr/bin/env bash

while true; do
  date '+"{"time": "%H:%M", "today": "%a, %d %B"}"'
  sleep $((60 - 10$(date +%S) % 100))
done
