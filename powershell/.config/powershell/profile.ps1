# Reuse the existing Starship theme in interactive console sessions.
if ($Host.Name -eq 'ConsoleHost' -and -not [Console]::IsInputRedirected) {
    if (-not (Get-Variable __pwshStarshipInitialized -ValueOnly -ErrorAction Ignore) -and
        (Get-Command starship -CommandType Application -ErrorAction Ignore)) {
        Invoke-Expression (& starship init powershell | Out-String)
        $global:__pwshStarshipInitialized = $true
    }
}
