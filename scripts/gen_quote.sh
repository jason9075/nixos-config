#!/usr/bin/env bash

QUOTES=(
    "ㄅㄥ ㄊㄚ ㄉㄜ˙ ㄅㄧㄥ ㄅㄤˋ ㄍㄣ ㄐㄧㄢˋ ㄓㄨˋ "
    "ㄕ ㄎㄨㄥˋ ㄉㄜ˙ ㄔㄜ ㄌㄧㄡˊ ㄔㄨㄥ ㄐㄧㄣˋ ㄕˋ ㄇㄧㄣˊ ㄉㄚˋ ㄉㄠˋ"
    "ㄖㄜˋ ㄉㄠˇ ㄒㄧㄠˋ ㄧㄥ ㄕㄠ ㄌㄧㄠˇ ㄓㄥˇ ㄗㄨㄛˋ ㄔㄥˊ ㄕˋ"
    "ㄊㄧˇ ㄍㄢˇ ㄙㄢ ㄉㄨˋ ㄕㄠ ㄕㄤ"
    "ㄨㄛˇ ㄏㄣˇ ㄅㄠˋ ㄑㄧㄢˋ"
    "ㄊㄞˊ ㄅㄟˇ ㄕ ㄎㄨㄥ"
)
LEN=${#QUOTES[@]}

current_time=$(date +%s)
index=$(( (current_time) / 3 % LEN ))
echo "${QUOTES[$index]}"
