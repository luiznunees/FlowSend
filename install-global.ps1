# FlowSend - Instalação global (Windows)
# Copia skills para ~\.config\opencode\skills\
# Assim você usa FlowSend em qualquer pasta sem clonar de novo

$skillDst = "$env:USERPROFILE\.config\opencode\skills"
$skillSrc = "\.claude\skills"

Write-Host "Instalando FlowSend globalmente..." -ForegroundColor Cyan

# Skills
if (Test-Path $skillSrc) {
    New-Item -ItemType Directory -Path $skillDst -Force | Out-Null
    Get-ChildItem "$skillSrc\*" -Directory | ForEach-Object {
        $name = $_.Name
        $skillFile = "$_\SKILL.md"
        if (Test-Path $skillFile) {
            New-Item -ItemType Directory -Path "$skillDst\$name" -Force | Out-Null
            Copy-Item $skillFile "$skillDst\$name\SKILL.md" -Force
            Write-Host "  Skill: $name" -ForegroundColor Green
        }
    }
}

# Agents
$agentDst = "$env:USERPROFILE\.config\opencode\agents"
$agentSrc = "\.opencode\agents"
if (Test-Path $agentSrc) {
    New-Item -ItemType Directory -Path $agentDst -Force | Out-Null
    Get-ChildItem "$agentSrc\*.md" | ForEach-Object {
        Copy-Item $_.FullName "$agentDst\$($_.Name)" -Force
        Write-Host "  Agente: $($_.BaseName)" -ForegroundColor Green
    }
}

# Regras
$regrasSrc = "_regras"
$regrasDst = "$env:USERPROFILE\.config\opencode\flowsend-regras"
if (Test-Path $regrasSrc) {
    Copy-Item -Recurse $regrasSrc $regrasDst -Force
}

Write-Host ""
Write-Host "FlowSend instalado globalmente!" -ForegroundColor Cyan
Write-Host ""
Write-Host "Para usar num projeto novo:" -ForegroundColor Yellow
Write-Host "  1. mkdir meu-cliente && cd meu-cliente" -ForegroundColor White
Write-Host "  2. opencode" -ForegroundColor White
Write-Host "  3. /instalar (configurar Evolution API)" -ForegroundColor White
Write-Host "  4. Colocar PDFs em dados/importados/" -ForegroundColor White
Write-Host "  5. /extrair-pdf" -ForegroundColor White
Write-Host ""
Write-Host "Skills em: $skillDst" -ForegroundColor Gray
if (Test-Path $agentDst) {
    Write-Host "Agentes em: $agentDst" -ForegroundColor Gray
}
