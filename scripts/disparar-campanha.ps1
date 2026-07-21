param(
    [Parameter(Mandatory)]
    [string]$Campanha,
    [Parameter(Mandatory)]
    [string]$CsvFile,
    [Parameter(Mandatory)]
    [string]$Url,
    [Parameter(Mandatory)]
    [string]$ApiKey,
    [string[]]$Instancias = @("disparo1", "disparo2"),
    [int]$IntervaloMin = 10,
    [int]$IntervaloMax = 70,
    [string]$Midia = "",
    [string]$MensagensFile = "",
    [int]$Lote = 50
)

# Carregar mensagens
if ($MensagensFile -and (Test-Path $MensagensFile)) {
    $mensagens = Get-Content $MensagensFile
} else {
    $mensagens = @()
}

$headers = @{ "apiKey" = $ApiKey }

# Progresso
$progressFile = "logs/$Campanha-progresso.csv"
$logFile = "logs/$Campanha-$(Get-Date -Format 'yyyyMMddHHmm').csv"

# Carregar contatos, removendo já enviados
$jaEnviados = @()
if (Test-Path $progressFile) {
    $jaEnviados = Import-Csv $progressFile | ForEach-Object { $_.telefone }
    Write-Host "Progresso encontrado: $($jaEnviados.Count) contatos ja enviados" -ForegroundColor Yellow
}

$contatos = Import-Csv $CsvFile | Where-Object { $_.telefone -notin $jaEnviados }
$total = $contatos.Count
Write-Host "Contatos restantes: $total" -ForegroundColor Cyan

if ($total -eq 0) {
    Write-Host "Nenhum contato restante. Campanha ja concluida!" -ForegroundColor Green
    exit
}

# Mídia
$midiaBase64 = ""
$midiaTipo = ""
if ($Midia -and (Test-Path $Midia)) {
    # Comprimir se for maior que 500KB
    $midiaBytes = [System.IO.File]::ReadAllBytes($Midia)
    $tamanhoKB = $midiaBytes.Length / 1kb

    if ($tamanhoKB -gt 500) {
        Write-Host "Imagem muito grande ($([math]::Round($tamanhoKB)) KB). Comprimindo..." -ForegroundColor Yellow
        $ext = [System.IO.Path]::GetExtension($Midia)
        $comprimido = $Midia -replace $ext, "-comprimido.jpg"
        # Usar Python para comprimir
        $pyCode = @"
import os
from PIL import Image
orig = r'$Midia'.replace('\\', '\\\\')
dest = r'$comprimido'.replace('\\', '\\\\')
img = Image.open(orig)
if img.width > 800:
    img = img.resize((800, int(800 * img.height / img.width)), Image.LANCZOS)
if img.height > 800:
    img = img.resize((int(800 * img.width / img.height), 800), Image.LANCZOS)
img.save(dest, 'JPEG', quality=70)
print(f'{os.path.getsize(dest) / 1024:.0f}')
"@
        $novoTamanho = py -c $pyCode 2>&1 | Select-Object -Last 1
        $Midia = $comprimido
        Write-Host "Comprimido para $novoTamanho KB" -ForegroundColor Green
    }

    $imgBytes = [System.IO.File]::ReadAllBytes($Midia)
    $midiaBase64 = [Convert]::ToBase64String($imgBytes)
    $ext = [System.IO.Path]::GetExtension($Midia).ToLower()
    $midiaTipo = if ($ext -eq ".png") { "image/png" } else { "image/jpeg" }
    Write-Host "Midia carregada ($([math]::Round($imgBytes.Length / 1kb)) KB)" -ForegroundColor Cyan
}

# Iniciar disparo
$chipIdx = 0
$variacaoIdx = 0
$i = 0
$loteAtual = 0
$loteCount = 0
$sucesso = 0
$falha = 0

# Se não tem mensagens do arquivo, perguntar uma
if ($mensagens.Count -eq 0) {
    Write-Host "AVISO: Nenhuma variacao de mensagem fornecida" -ForegroundColor Yellow
    return
}

Write-Host ""
Write-Host "Iniciando disparo: $Campanha" -ForegroundColor Magenta
Write-Host "Contatos: $total | Lote: $Lote | Intervalo: ${IntervaloMin}s-${IntervaloMax}s" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Magenta

foreach ($contato in $contatos) {
    $i++
    $loteCount++
    $numero = $contato.telefone
    $nome = if ($contato.nome) { $contato.nome } else { "" }
    $instancia = $Instancias[$chipIdx % $Instancias.Count]
    $chipIdx++
    $variacao = $mensagens[$variacaoIdx % $mensagens.Count]
    $variacaoIdx++

    # Substituir {nome} e { nome}
    $mensagem = $variacao -replace '\{nome\}', $nome -replace '\{\s*nome\}', $nome
    $dataHora = (Get-Date -Format "yyyy-MM-ddTHH:mm:ss")

    try {
        if ($midiaBase64) {
            $body = @{
                number = $numero
                mediatype = "image"
                media = $midiaBase64
                caption = $mensagem
                delay = 1
            } | ConvertTo-Json -Compress

            $resp = Invoke-RestMethod -Uri "$Url/message/sendMedia/$instancia" `
                -Method Post -Headers $headers -Body $body `
                -ContentType "application/json" -ErrorAction Stop
        } else {
            $body = @{
                number = $numero
                text = $mensagem
                delay = 1
            } | ConvertTo-Json -Compress

            $resp = Invoke-RestMethod -Uri "$Url/message/sendText/$instancia" `
                -Method Post -Headers $headers -Body $body `
                -ContentType "application/json" -ErrorAction Stop
        }

        $sucesso++
        Write-Host "[$i/$total] $nome -> OK" -ForegroundColor Green
        $statusLog = "sucesso"
        $erroLog = ""
    }
    catch {
        $falha++
        $erroMsg = $_.Exception.Message -replace "`n", " " -replace "`r", ""
        Write-Host "[$i/$total] $nome -> ERRO: $erroMsg" -ForegroundColor Red
        $statusLog = "erro"
        $erroLog = $erroMsg
    }

    # Salvar progresso
    $linha = "$numero,$nome,$instancia,$($variacaoIdx % $mensagens.Count),$statusLog,$dataHora,$erroLog"
    Add-Content -Path $progressFile -Value $linha -Encoding utf8

    # Salvar log completo
    $logLinha = "$numero,$instancia,$($chipIdx % $Instancias.Count),$($variacaoIdx % $mensagens.Count),$statusLog,$dataHora,$erroLog"
    Add-Content -Path $logFile -Value $logLinha -Encoding utf8

    # Delay
    if ($i -lt $total) {
        $delay = Get-Random -Minimum $IntervaloMin -Maximum ($IntervaloMax + 1)
        Write-Host "  Aguardando ${delay}s..." -ForegroundColor DarkGray
        Start-Sleep -Seconds $delay
    }

    # Fim do lote
    if ($loteCount -ge $Lote -and $i -lt $total) {
        $loteAtual++
        Write-Host ""
        Write-Host "=== LOTE $loteAtual CONCLUIDO ===" -ForegroundColor Yellow
        Write-Host "Enviados: $i/$total | Sucesso: $sucesso | Falha: $falha" -ForegroundColor White

        # Perguntar se quer continuar
        Write-Host "Continuar com o proximo lote? (S/N)" -ForegroundColor Cyan
        $resposta = Read-Host
        if ($resposta -ne "S" -and $resposta -ne "s" -and $resposta -ne "sim" -and $resposta -ne "") {
            Write-Host "Disparo pausado. Progresso salvo em $progressFile" -ForegroundColor Yellow
            Write-Host "Para retomar: rode o script de novo" -ForegroundColor Yellow
            exit
        }
        $loteCount = 0
    }
}

# Final
Write-Host ""
Write-Host "========================================" -ForegroundColor Magenta
Write-Host "DISPARO FINALIZADO!" -ForegroundColor Cyan
Write-Host "Total: $($sucesso + $falha)" -ForegroundColor White
Write-Host "Sucesso: $sucesso" -ForegroundColor Green
Write-Host "Falha: $falha" -ForegroundColor Red
Write-Host "Log: $logFile" -ForegroundColor White
Write-Host "Progresso: $progressFile" -ForegroundColor White
Write-Host "========================================" -ForegroundColor Magenta
