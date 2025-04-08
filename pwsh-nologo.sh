#!/usr/bin/bash

fallback_win_path="C:\\Users\\via"
win_path=$(tr -d '\r\n' < /mnt/c/Users/via/.wsl_pwd)
if [[ "$win_path" =~ ^[A-Z]:\\\\ ]]; then
    final_path="$win_path"
else
    final_path="$fallback_win_path"
fi
final_path=$(echo "$final_path" | sed 's/\\\\/\\/g')
exec pwsh.exe -noexit -Command "Set-Location -Path \"$final_path\""
