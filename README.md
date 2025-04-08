# tmux-powershell
WSL2's tmux integration to Powershell Core.

| Name | Description |
|-|-|
| PSVersion | 7.6.0-preview.3 |
| PSEdition | Core |
| OS | Microsoft Windows 10.0.26100 |
| WSL | Arch Linux on Windows 10 x86_64 |
| Kernel | 5.15.167.4-microsoft-standard-WSL2 |
| Shell | zsh 5.9 |

## Installation

1. add this code into `.tmux.conf`. which u can replace `pwsh-nologo.sh` into other names. 

```
set -g default-command '/usr/local/bin/pwsh-nologo.sh'
```

2. add `psh-nologo.sh` into `/usr/local/bin/`.

```bash
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
```

3. modify ur powershell's profile script, and add this lines of code.

```ps
function Update-WSLPath {
    $pwdPath = (Get-Location).Path
    $escapedPath = $pwdPath.Replace('\', '\\')
    $outFile = "$env:USERPROFILE\.wsl_pwd"
    try {
        $escapedPath | Out-File -Encoding ASCII -Force -FilePath $outFile
    } catch {
        Write-Warning "Failed to write to $outFile"
    }
}
Remove-Alias cd
function cd {
    param(
        [string]$path = "$HOME"
    )

    if (Test-Path $path) {
        Set-Location $path
        Update-WSLPath
    } else {
        Write-Host "Path?: $path"
    }
}
```
