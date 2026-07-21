---
name: instalar
description: >
  Configura o FlowSend pela primeira vez. Pergunta quantos chips, URL da Evolution API,
  intervalo entre disparos e pasta de entrada.
---

# /instalar — Setup inicial do FlowSend

## Workflow

### 1. Evolution API
"Qual a URL da Evolution API? (ex: http://localhost:8080 ou http://192.168.0.100:8080)"

Se o usuário não tiver instalado:
> "Precisa do Evolution API rodando. Quer que eu baixe e suba com Docker agora?"
Se sim, executar:
```bash
git clone https://github.com/EvolutionAPI/evolution-api.git /tmp/evolution-api
cd /tmp/evolution-api
docker compose up -d
```
Confirmar URL depois de instalado.

### 2. Chips
"Quantos chips você tem para disparo?" (padrão: 2)

Para cada chip:
- "Qual o nome do Chip [N]? (ex: Chip 1, Vivo, Claro, Tim)"
- "Qual o nome da instância no Evolution API? (ex: chip1, chip2)"

### 3. Intervalo
"Qual o intervalo entre disparos?" (padrão: 30 segundos)

### 4. Pasta de entrada
"Onde colocar os PDFs para extrair?" (padrão: dados/importados/)

### 5. Salvar config

Salvar em `_memoria/config.yaml`:

```yaml
evolution_api:
  url: "http://localhost:8080"
  api_key: ""  # opcional
chips:
  - id: 1
    nome: "Chip 1"
    instancia: "chip1"
  - id: 2
    nome: "Chip 2"
    instancia: "chip2"
intervalo_segundos: 30
pasta_entrada: "dados/importados/"
```

### 6. Estrutura inicial
Criar pastas se não existirem.

### 7. Resumo
```
? FlowSend configurado!

Evolution API: [URL]
Chips: [N]
Intervalo: [N]s

Próximos passos:
1. /conectar-chip — conectar cada chip via QR Code
2. Coloque os PDFs em dados/importados/
3. /extrair-pdf para extrair contatos
4. /campanha para criar sua primeira campanha
```
