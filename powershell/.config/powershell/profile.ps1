# Reuse the existing Starship theme in interactive console sessions.
if ($Host.Name -eq 'ConsoleHost' -and -not [Console]::IsInputRedirected) {
    if (-not (Get-Variable __pwshStarshipInitialized -ValueOnly -ErrorAction Ignore) -and
        (Get-Command starship -CommandType Application -ErrorAction Ignore)) {
        Invoke-Expression (& starship init powershell | Out-String)
        $global:__pwshStarshipInitialized = $true
    }
}

# Create a 3-pane dev layout in Rex:
# Top-left: OpenCode (replaces current pane)
# Top-right: gitu
# Bottom: shell prompt
function nic {
    if (-not $env:REX_SESSION) {
        Write-Error "Not in a Rex session"
        return 1
    }

    $currentDir = $PWD.ProviderPath

    # Rename window to current directory name
    $dirName = Split-Path $currentDir -Leaf
    rex window rename -s $env:REX_SESSION $dirName > $null

    # Split right for gitu (top-right, 40% width)
    $splitResult = rex split -s $env:REX_SESSION -b $env:REX_BLOCK --split=right --ratio 40 -c $currentDir --json
    $topRight = ($splitResult | ConvertFrom-Json).block_ids[0]
    if (-not $topRight) { Write-Error "Failed to create top-right pane"; return 1 }

    # Split below for shell (bottom, 35% height)
    $splitResult = rex split -s $env:REX_SESSION -b $env:REX_BLOCK --split=below --ratio 35 -c $currentDir --json
    $bottom = ($splitResult | ConvertFrom-Json).block_ids[0]
    if (-not $bottom) { Write-Error "Failed to create bottom pane"; return 1 }

    # Launch OpenCode in current pane (top-left)
    rex send -s $env:REX_SESSION -b $env:REX_BLOCK "opencode"
    rex send-key -s $env:REX_SESSION -b $env:REX_BLOCK enter

    # Launch gitu in top-right
    rex send -s $env:REX_SESSION -b $topRight "gitu"
    rex send-key -s $env:REX_SESSION -b $topRight enter

    # Bottom pane stays as shell (empty prompt)
    # Focus back to OpenCode (top-left)
    rex focus -s $env:REX_SESSION $env:REX_BLOCK
}
