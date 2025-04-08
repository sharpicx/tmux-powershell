#!/usr/bin/bash

fallback_win_path="C:\\Users\\yourwindowsusername"
win_path=$(cat /mnt/c/Users/yourwindowsusername/.wsl_pwd 2>/dev/null)
if [[ "$win_path" =~ ^[A-Z]:\\ ]]; then
    final_path="$win_path"
else
    final_path="$fallback_win_path"
fi
final_path=$(echo "$final_path" | sed 's/\\\\/\\/g')
exec pwsh.exe -noexit -Command "cd $final_path"
