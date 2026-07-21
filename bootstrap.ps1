# FlowSend Bootstrap (Windows)
# Um comando. Instala FlowSend globalmente. Pronto pra usar.
# Uso: irm https://raw.githubusercontent.com/luiznunees/FlowSend/main/bootstrap.ps1 | iex

$repo = "https://github.com/luiznunees/FlowSend.git"
$tmpDir = "$env:TEMP\flowsend-bootstrap"

Write-Host "=== FlowSend Bootstrap ===" -ForegroundColor Cyan
Write-Host "Baixando FlowSend..." -ForegroundColor Yellow

# Remove old temp if exists
Remove-Item -Path $tmpDir -Recurse -Force -ErrorAction SilentlyContinue

# Clone
git clone --depth 1 $repo $tmpDir 2>$null
if (-not (Test-Path $tmpDir)) {
    Write-Host "Erro ao baixar. Verifique se git esta instalado." -ForegroundColor Red
    exit 1
}

# Run global install
Set-Location $tmpDir
& ".\install-global.ps1"

# Cleanup
Set-Location $env:USERPROFILE
Remove-Item -Path $tmpDir -Recurse -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "FlowSend pronto!" -ForegroundColor Green
Write-Host ""
Write-Host "Agora abra o OpenCode em QUALQUER pasta e diga:" -ForegroundColor Cyan
Write-Host "  /instalar" -ForegroundColor White
Write-Host "  - ou -" -ForegroundColor Gray
Write-Host "  'quero configurar o FlowSend'" -ForegroundColor White
