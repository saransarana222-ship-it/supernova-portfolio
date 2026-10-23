$ErrorActionPreference = "Continue"
$Host.UI.RawUI.WindowTitle = "SuperNova Studio — Google Cloud Deployment"

$env:PATH = "C:\Users\USER\.gemini\antigravity\scratch\nodejs;" + $env:PATH
Set-Location "C:\Users\USER\.gemini\antigravity\scratch\supernova-portfolio"

Clear-Host
Write-Host ""
Write-Host " ================================================================= " -ForegroundColor Cyan
Write-Host "    SUPERNOVA STUDIO | OFFICIAL GOOGLE CLOUD & FIREBASE LAUNCH     " -ForegroundColor Green -BackgroundColor Black
Write-Host " ================================================================= " -ForegroundColor Cyan
Write-Host ""
Write-Host "  Step 1: Google Account Sign-In" -ForegroundColor Yellow
Write-Host "  --> A Google login tab will open in your browser." -ForegroundColor Gray
Write-Host "  --> Simply choose your Google account and click 'Allow'." -ForegroundColor Gray
Write-Host ""

& npx -y firebase-tools@latest login

Write-Host ""
Write-Host "  Step 2: Creating Your Google Cloud / Firebase Project..." -ForegroundColor Yellow

$rnd = Get-Random -Minimum 1000 -Maximum 9999
$projId = "supernova-$rnd"

Write-Host "  --> Initializing project ID: $projId" -ForegroundColor Gray
& npx -y firebase-tools@latest projects:create $projId --display-name "SuperNova Studio"

& npx -y firebase-tools@latest use $projId

Write-Host ""
Write-Host "  Step 3: Deploying Website to Global Google CDN Edge Network..." -ForegroundColor Yellow

& npx -y firebase-tools@latest deploy --only hosting

Write-Host ""
Write-Host " ================================================================= " -ForegroundColor Green
Write-Host "    CONGRATULATIONS! YOUR WEBSITE IS OFFICIALLY LIVE ON GOOGLE!   " -ForegroundColor Green
Write-Host " ================================================================= " -ForegroundColor Green
Write-Host ""
Write-Host "  Official Live Google URLs:" -ForegroundColor Cyan
Write-Host "  - https://$projId.web.app" -ForegroundColor White
Write-Host "  - https://$projId.firebaseapp.com" -ForegroundColor White
Write-Host ""

Start-Process "https://$projId.web.app"

Write-Host "  (Opened your live site in your browser!)" -ForegroundColor Green
Write-Host ""
Write-Host "  Press any key to close this window..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
