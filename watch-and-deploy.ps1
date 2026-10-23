$targetDir = "C:\Users\USER\.gemini\antigravity\scratch\supernova-portfolio"
$nodeDir = "C:\Users\USER\.gemini\antigravity\scratch\nodejs"
$env:PATH = "$nodeDir;" + $env:PATH

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  SuperNova Studio | Continuous Auto-Deployment Daemon" -ForegroundColor Green
Write-Host "  Target Official Site: https://supernova-saran.web.app" -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan

$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $targetDir
$watcher.Filter = "*.*"
$watcher.IncludeSubdirectories = $false
$watcher.EnableRaisingEvents = $true

$lastDeployTime = [DateTime]::MinValue
$deployLock = $false

function Trigger-Deploy {
    param([string]$changeSource)
    $now = [DateTime]::Now
    if (($now - $script:lastDeployTime).TotalSeconds -lt 5) {
        return
    }
    if ($script:deployLock) { return }
    $script:deployLock = $true
    $script:lastDeployTime = $now

    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Change detected in $changeSource -> Auto-Deploying to Google..." -ForegroundColor Yellow
    try {
        Set-Location $targetDir
        & "$nodeDir\npx.cmd" -y firebase-tools@latest deploy --only hosting
        Write-Host "[$(Get-Date -Format 'HH:mm:ss')] [SUCCESS] Deployed live to https://supernova-saran.web.app" -ForegroundColor Green
    } catch {
        Write-Host "[$(Get-Date -Format 'HH:mm:ss')] [ERROR] Deploy failed: $_" -ForegroundColor Red
    } finally {
        $script:lastDeployTime = [DateTime]::Now
        $script:deployLock = $false
    }
}

$action = {
    if ($script:deployLock) { return }
    $name = $Event.SourceEventArgs.Name
    if ($name -in @('index.html', 'robots.txt', 'sitemap.xml', 'firebase.json')) {
        Trigger-Deploy -changeSource $name
    }
}

Register-ObjectEvent $watcher 'Changed' -Action $action | Out-Null
Register-ObjectEvent $watcher 'Created' -Action $action | Out-Null

Write-Host "Auto-deploy watcher active. Any file edit will automatically deploy to https://supernova-saran.web.app!" -ForegroundColor Green

while ($true) {
    Start-Sleep -Seconds 1
}
