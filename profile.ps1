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
