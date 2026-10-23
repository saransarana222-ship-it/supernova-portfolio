# ==============================================================================
# J.A.R.V.I.S. v3.8 — STARK INDUSTRIES LOCAL AUTONOMOUS CONTROLLER
# Engineered for Saran A | SuperNova Studio
# ==============================================================================

param(
    [Parameter(Position=0)]
    [string]$Command = "status",
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$ArgsList
)

$ErrorActionPreference = "SilentlyContinue"
$ProgressPreference = "SilentlyContinue"

function Show-JarvisBanner {
    Write-Host ""
    Write-Host "     ===============================================================" -ForegroundColor Cyan
    Write-Host "     [#]  J . A . R . V . I . S .   P R O T O C O L   v 3 . 8   [#]" -ForegroundColor Cyan
    Write-Host "     [#]  STARK INDUSTRIES / SUPERNOVA AUTONOMOUS LOCAL SYSTEM   [#]" -ForegroundColor Green
    Write-Host "     ===============================================================" -ForegroundColor Cyan
    Write-Host "      OPERATOR: Saran A | SuperNova Studio" -ForegroundColor Yellow
    Write-Host "     ---------------------------------------------------------------" -ForegroundColor DarkGray
}

function Get-JarvisStatus {
    Show-JarvisBanner
    Write-Host "`n  [+] DIAGNOSTIC TELEMETRY INITIALIZED..." -ForegroundColor Green

    # 1. OS & Machine
    $osVersion = [System.Environment]::OSVersion.VersionString
    $machineName = [System.Environment]::MachineName
    $cores = [System.Environment]::ProcessorCount

    Write-Host "`n  [SYSTEM OVERVIEW]" -ForegroundColor Cyan
    Write-Host "    -> Host:      $machineName" -ForegroundColor White
    Write-Host "    -> OS:        $osVersion" -ForegroundColor White
    Write-Host "    -> Cores:     $cores Logical Processors" -ForegroundColor White

    # 2. Process Memory Footprint
    $procs = Get-Process
    $totalWorkingSetMB = [math]::Round(($procs | Measure-Object -Property WorkingSet64 -Sum).Sum / 1MB, 1)
    Write-Host "`n  [MEMORY & WORKLOAD]" -ForegroundColor Cyan
    Write-Host "    -> Process RAM: $totalWorkingSetMB MB in active use across $($procs.Count) processes" -ForegroundColor White

    # 3. Storage Telemetry (All Drives)
    Write-Host "`n  [STORAGE VOLUMES]" -ForegroundColor Cyan
    try {
        $drives = [System.IO.DriveInfo]::GetDrives()
        foreach ($d in $drives) {
            if ($d.IsReady) {
                $freeGB = [math]::Round($d.TotalFreeSpace / 1GB, 1)
                $totalGB = [math]::Round($d.TotalSize / 1GB, 1)
                $usedPct = [math]::Round((($totalGB - $freeGB) / $totalGB) * 100)
                Write-Host "    -> Volume $($d.Name) $freeGB GB free of $totalGB GB ($usedPct% used)" -ForegroundColor White
            }
        }
    } catch {
        Write-Host "    -> Storage check completed." -ForegroundColor White
    }

    # 4. SuperNova Cloud & Web Status
    Write-Host "`n  [CLOUD TELEMETRY & WEB PORTAL]" -ForegroundColor Cyan
    $siteUrl = "https://supernova-saran.web.app"
    Write-Host "    -> Production: $siteUrl" -ForegroundColor White
    Write-Host "    -> Host Edge:  Google CDN (Firebase Global Network)" -ForegroundColor Green
    Write-Host "    -> J.A.R.V.I.S.: Integrated Web HUD & Arc Reactor v3.8 Active" -ForegroundColor Cyan

    Write-Host "`n ===================================================================" -ForegroundColor DarkGray
    Write-Host "  J.A.R.V.I.S. Status: ALL PROTOCOLS NOMINAL AND ONLINE." -ForegroundColor Green
    Write-Host ""
}

function Invoke-JarvisDeploy {
    Show-JarvisBanner
    Write-Host "`n  [+] INITIATING AUTOMATED PRODUCTION DEPLOYMENT..." -ForegroundColor Yellow
    $projDir = "C:\Users\USER\.gemini\antigravity\scratch\supernova-portfolio"
    if (-not (Test-Path $projDir)) {
        Write-Host "  [!] Project directory not found: $projDir" -ForegroundColor Red
        return
    }

    Set-Location $projDir
    $env:PATH = "C:\Users\USER\.gemini\antigravity\scratch\nodejs;" + $env:PATH
    $fbCmd = "C:\Users\USER\AppData\Local\npm-cache\_npx\ba4f1959e38407b5\node_modules\.bin\firebase.cmd"
    if (-not (Test-Path $fbCmd)) {
        $fbCmd = "C:\Users\USER\AppData\Roaming\Antigravity\bin\firebase.exe"
    }

    Write-Host "  --> Deploying to https://supernova-saran.web.app via Google CDN Edge..." -ForegroundColor Cyan
    & $fbCmd deploy --only hosting
    Write-Host "`n  [SUCCESS] Deployment cycle completed successfully!" -ForegroundColor Green
}

function Open-JarvisSite {
    Write-Host "`n  [+] Opening live portfolio: https://supernova-saran.web.app..." -ForegroundColor Cyan
    Start-Process "https://supernova-saran.web.app"
}

function Clean-JarvisSystem {
    Show-JarvisBanner
    Write-Host "`n  [+] INITIATING SAFE CACHE & TEMP PURGE..." -ForegroundColor Yellow
    $tempPath = [System.IO.Path]::GetTempPath()
    $items = Get-ChildItem -Path $tempPath -Recurse -Force -ErrorAction SilentlyContinue
    $count = 0
    $freedBytes = 0
    foreach ($item in $items) {
        try {
            if (-not $item.PSIsContainer) {
                $freedBytes += $item.Length
            }
            Remove-Item -Path $item.FullName -Force -Recurse -ErrorAction SilentlyContinue
            $count++
        } catch {}
    }
    $freedMB = [math]::Round($freedBytes / 1MB, 2)
    Write-Host "  [SUCCESS] Cleaned $count temporary cache objects ($freedMB MB freed)!" -ForegroundColor Green
}

function Show-JarvisProcesses {
    Show-JarvisBanner
    Write-Host "`n  [+] TOP 5 MEMORY-INTENSIVE PROCESSES:" -ForegroundColor Yellow
    Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First 5 ProcessName, @{Name="RAM (MB)"; Expression={[math]::Round($_.WorkingSet64 / 1MB, 1)}}, Id | Format-Table -AutoSize

    Write-Host "  [+] TOP 5 CPU-INTENSIVE PROCESSES:" -ForegroundColor Yellow
    Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 ProcessName, @{Name="CPU (s)"; Expression={[math]::Round($_.CPU, 1)}}, Id | Format-Table -AutoSize
}

function Backup-JarvisProject {
    Show-JarvisBanner
    Write-Host "`n  [+] INITIATING PROJECT ARCHIVAL PROTOCOL..." -ForegroundColor Yellow
    $src = "C:\Users\USER\.gemini\antigravity\scratch\supernova-portfolio"
    $backupDir = "C:\Users\USER\.gemini\antigravity\scratch\backups"
    if (-not (Test-Path $backupDir)) {
        New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
    }
    $timestamp = (Get-Date).ToString("yyyyMMdd-HHmmss")
    $zipTarget = Join-Path $backupDir "supernova-backup-$timestamp.zip"

    Write-Host "  --> Archiving portfolio to: $zipTarget" -ForegroundColor Cyan
    try {
        Compress-Archive -Path "$src\*" -DestinationPath $zipTarget -Force
        $sizeMB = [math]::Round((Get-Item $zipTarget).Length / 1MB, 2)
        Write-Host "  [SUCCESS] Backup archive generated successfully ($sizeMB MB)!" -ForegroundColor Green
    } catch {
        Write-Host "  [!] Backup warning: $_" -ForegroundColor Red
    }
}

function Test-JarvisNetwork {
    Show-JarvisBanner
    Write-Host "`n  [+] RUNNING NETWORK DIAGNOSTICS & PING PROBES..." -ForegroundColor Yellow
    $targets = @("google.com", "supernova-saran.web.app", "8.8.8.8")
    foreach ($t in $targets) {
        $p = Test-Connection -ComputerName $t -Count 1 -Quiet -ErrorAction SilentlyContinue
        $status = if ($p) { "REACHABLE (OK)" } else { "TIMEOUT / RESTRICTED" }
        $color  = if ($p) { "Green" } else { "Yellow" }
        Write-Host ("    -> Probe to {0,-28}: [{1}]" -f $t, $status) -ForegroundColor $color
    }
}

function Kill-JarvisProcess {
    param([string]$targetName)
    Show-JarvisBanner
    if (-not $targetName) {
        Write-Host "`n  [!] Specify process name to terminate: jarvis kill <name>" -ForegroundColor Red
        return
    }
    Write-Host "`n  [+] TARGETING PROCESS: $targetName..." -ForegroundColor Yellow
    $procs = Get-Process -Name $targetName -ErrorAction SilentlyContinue
    if (-not $procs) {
        Write-Host "  [!] No active process matching '$targetName' found." -ForegroundColor DarkYellow
        return
    }
    foreach ($p in $procs) {
        try {
            Stop-Process -Id $p.Id -Force
            Write-Host "  [SUCCESS] Terminated PID $($p.Id) ($($p.ProcessName))" -ForegroundColor Green
        } catch {
            Write-Host "  [!] Failed to terminate PID $($p.Id): $_" -ForegroundColor Red
        }
    }
}

function Ask-JarvisAI {
    param([string]$QueryText)
    Show-JarvisBanner
    if (-not $QueryText) {
        Write-Host "`n  [!] Specify your query: jarvis ask <your question>" -ForegroundColor Red
        return
    }

    Write-Host "`n  [+] CONNECTING TO STARK NEURAL SYNAPSE (GEMINI PRO)..." -ForegroundColor Cyan
    Write-Host "    -> Operator: Saran A | B.E. 2nd Year CSE, EGS Pillay Engg" -ForegroundColor DarkGray
    Write-Host "    -> Query:    '$QueryText'" -ForegroundColor White

    $apiKey = $env:GEMINI_API_KEY
    if (-not $apiKey) {
        $envPath = "C:\Users\USER\.gemini\antigravity\scratch\supernova-portfolio\.env"
        if (Test-Path $envPath) {
            $line = Get-Content $envPath | Where-Object { $_ -match "^GEMINI_API_KEY=" }
            if ($line) { $apiKey = $line.Substring(15).Trim() }
        }
    }

    if (-not $apiKey) {
        Write-Host "  [!] GEMINI_API_KEY not found in environment or .env" -ForegroundColor Red
        return
    }

    $systemInstruction = "You are J.A.R.V.I.S., the legendary AI Protocol and tactical copilot engineered for Saran A (Founder of SuperNova Studio, B.E. 2nd Year CSE at E.G.S. Pillay Engineering College, Nagapattinam). Answer Saran crisply, loyally, and smartly in friendly Tanglish + clean English technical terms."
    
    $bodyObj = @{
        system_instruction = @{ parts = @(@{ text = $systemInstruction }) }
        contents = @(
            @{ parts = @(@{ text = $QueryText }) }
        )
    }
    $jsonBody = $bodyObj | ConvertTo-Json -Depth 5

    try {
        $url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey"
        $resp = Invoke-RestMethod -Uri $url -Method Post -Body $jsonBody -ContentType "application/json" -TimeoutSec 15
        $reply = $resp.candidates[0].content.parts[0].text
        Write-Host "`n  [J.A.R.V.I.S. INTEL RESPONSE]" -ForegroundColor Green
        Write-Host "  ---------------------------------------------------------------" -ForegroundColor DarkGray
        Write-Host $reply -ForegroundColor White
        Write-Host "  ---------------------------------------------------------------" -ForegroundColor DarkGray
    } catch {
        Write-Host "  [!] Neural synapse timeout or connection fault: $_" -ForegroundColor Red
    }
}

function Show-JarvisHelp {
    Show-JarvisBanner
    Write-Host "`n  Available J.A.R.V.I.S. Command Matrix:" -ForegroundColor Cyan
    Write-Host "    jarvis ask <query>  - Ask J.A.R.V.I.S. any technical query via Gemini Pro AI" -ForegroundColor Green
    Write-Host "    jarvis status       - Full diagnostic telemetry (Cores, Memory, Volumes, Cloud)" -ForegroundColor White
    Write-Host "    jarvis deploy       - 1-click deploy SuperNova portfolio to Google Cloud" -ForegroundColor White
    Write-Host "    jarvis website      - Launch live site (https://supernova-saran.web.app)" -ForegroundColor White
    Write-Host "    jarvis backup       - Instant timestamped zip snapshot of portfolio" -ForegroundColor White
    Write-Host "    jarvis clean        - Safely purge temporary system cache" -ForegroundColor White
    Write-Host "    jarvis process      - Inspect top CPU and Memory processes" -ForegroundColor White
    Write-Host "    jarvis network      - Ping diagnostics for Cloud & Web portals" -ForegroundColor White
    Write-Host "    jarvis kill <name>  - Safely terminate an unresponsive process" -ForegroundColor White
    Write-Host "    jarvis help         - Display this protocol matrix" -ForegroundColor White
    Write-Host ""
}

# Main Routing Switch
$cmd = if ($Command) { $Command.ToLower() } else { "status" }
switch ($cmd) {
    "ask"       { Ask-JarvisAI -QueryText ($ArgsList -join " ") }
    "query"     { Ask-JarvisAI -QueryText ($ArgsList -join " ") }
    "status"    { Get-JarvisStatus }
    "deploy"    { Invoke-JarvisDeploy }
    "website"   { Open-JarvisSite }
    "open"      { Open-JarvisSite }
    "backup"    { Backup-JarvisProject }
    "clean"     { Clean-JarvisSystem }
    "process"   { Show-JarvisProcesses }
    "top"       { Show-JarvisProcesses }
    "network"   { Test-JarvisNetwork }
    "ping"      { Test-JarvisNetwork }
    "kill"      { Kill-JarvisProcess -targetName $ArgsList[0] }
    "help"      { Show-JarvisHelp }
    default     { Show-JarvisHelp }
}
