# tmux-powershell
WSL2's tmux integration to Powershell Core. yet another `${pane_current_path}` for WSL2's tmux Windows integration.

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

2. add `pwsh-nologo.sh` into `/usr/local/bin/`.

```bash
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
Update-WSLPath
```

4. start it

```console
PS> wsl -e zsh -c tmux new-session -t 1
```

5. (optional) add this to `C:\Users\username\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json`. based on the `profiles` object key > `lists` object array.

```json
    "commandline": "\"C:\\Program Files\\PowerShell\\7-preview\\pwsh.exe\" -nologo -ExecutionPolicy Bypass -command \"wsl.exe -d Arch -e zsh -ic 'tmux has-session -t SHARPICX 2>/dev/null && exec tmux attach-session -t SHARPICX || exec tmux new-session -s SHARPICX'\"",
                "guid": "{a3a2e83a-884a-5379-baa8-16f193a13b21}",
                "hidden": false,
                "name": "PowerShell 7 Preview",
                "source": "Windows.Terminal.PowershellCore"
            }
```
