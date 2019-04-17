[CmdletBinding()]
param (
    [bool] $Debugging
)

# Because these are set once in a script scope (modules and functions are all considered in one script scope)
# they will be effective in every function, and won't override or be overridden by changes in parent scopes.
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if ($Debugging) {
    foreach ($fileName in (Get-ChildItem $PSScriptRoot "*-*.ps1" -Recurse -Exclude "*.Steps.ps1", "*.Tests.ps1", "*.ps1xml")) {
        try {
            Write-Verbose "Loading function from path '$fileName'."
            . $fileName.FullName
        } catch {
            Write-Error $_
        }
    }
} else {
    $scriptBlock = Get-ChildItem $PSScriptRoot "*-*.ps1" -Recurse -Exclude "*.Steps.ps1", "*.Tests.ps1", "*.ps1xml" | ForEach-Object {
        [System.IO.File]::ReadAllText($_.FullName)
    }
    $ExecutionContext.InvokeCommand.InvokeScript($false, [scriptblock]::Create($scriptBlock), $null, $null)
}
