param(
    [Parameter(Mandatory)]
    [string]$CsvFile,
    [Parameter(Mandatory)]
    [string]$Url,
    [Parameter(Mandatory)]
    [string]$ApiKey,
    [string]$Instancia = "disparo1",
    [string]$OutputDir = "."
)

$headers = @{ "apiKey" = $ApiKey }
$contatos = Import-Csv $CsvFile
$total = $contatos.Count
$validos = @()
$invalidos = @()
$i = 0

Write-Host "Validando $total contatos..." -ForegroundColor Cyan

foreach ($contato in $contatos) {
    $i++
    $nome = if ($contato.nome) { $contato.nome } else { "sem nome" }

    try {
        $body = @{ numbers = @($contato.telefone) } | ConvertTo-Json -Compress
        $resp = Invoke-RestMethod -Uri "$Url/chat/whatsappNumbers/$Instancia" `
            -Method Post -Headers $headers -Body $body `
            -ContentType "application/json" -ErrorAction Stop

        if ($resp.exists -eq $true) {
            $validos += $contato
            Write-Host "[$i/$total] $nome -> OK" -ForegroundColor Green
        } else {
            $invalidos += $contato
            Write-Host "[$i/$total] $nome -> INVALIDO" -ForegroundColor Red
        }
    } catch {
        $invalidos += $contato
        Write-Host "[$i/$total] $nome -> ERRO: $_" -ForegroundColor Red
    }
}

$baseName = [System.IO.Path]::GetFileNameWithoutExtension($CsvFile)
$validPath = Join-Path $OutputDir "validados-$baseName.csv"
$invalidPath = Join-Path $OutputDir "invalidos-$baseName.csv"

$validos | Export-Csv $validPath -Encoding utf8 -NoTypeInformation
$invalidos | Export-Csv $invalidPath -Encoding utf8 -NoTypeInformation

Write-Host ""
Write-Host "=== VALIDACAO CONCLUIDA ===" -ForegroundColor Cyan
Write-Host "Total: $total" -ForegroundColor White
Write-Host "Validos (WhatsApp): $($validos.Count)" -ForegroundColor Green
Write-Host "Invalidos: $($invalidos.Count)" -ForegroundColor Red
Write-Host "Arquivo validos: $validPath" -ForegroundColor White
Write-Host "============================" -ForegroundColor Cyan
