---
name: disparar
description: >
  Executa o disparo de campanha via Evolution API. Valida contatos, salva progresso,
  retoma de onde parou, envia em lotes. Use quando: "disparar", "executar campanha",
  "enviar mensagens", "continuar disparo", "/disparar".
---

# /disparar — Execução de disparo via Evolution API

## Workflow

### Passo 1 — Carregar config

Ler `_memoria/config.yaml`:
- `evolution_api.url`
- `evolution_api.api_key`
- `chips` (id, nome, instancia)
- `intervalo_segundos`

### Passo 2 — Verificar instâncias

Para cada chip:

```bash
curl -s -X GET "<URL>/instance/connectionState/<instancia>" -H "apiKey: <API_KEY>"
```

Se algum desconectado: "Quer conectar com /conectar-chip ou pular esse chip?"

### Passo 3 — Selecionar campanha

Listar campanhas pendentes em `campanhas/`.

- 1 pendente: selecionar automático
- Múltiplas: perguntar
- Nenhuma: "Criar com /campanha?"

### Passo 4 — Verificar progresso anterior

Checar `logs/<campanha>-progresso.csv`.

- **Se existir**: "Já foram enviados [N] contatos desta campanha. Quer continuar de onde parou ou começar do zero?"
- **Se não existir**: seguir normalmente

### Passo 5 — Pré-validação automática

"Quer validar os contatos antes de disparar? (recomendado)"

Se sim, para cada contato na lista:

```bash
curl -s -X POST "<URL>/chat/whatsappNumbers/<instancia>" \
  -H "apiKey: <API_KEY>" \
  -H "Content-Type: application/json" \
  -d '{"numbers": ["55XXXXXXXXXXX"]}'
```

Se `exists: false` ou erro → marcar como inválido, não enviar.

Resultado:
```
Total: [N] contatos
  Válidos (WhatsApp): [N]
  Inválidos: [N]
```

Salvar lista válida em `dados/contatos/validados-<campanha>.csv`.
Salvar inválidos em `dados/contatos/invalidos-<campanha>.csv`.

**Importante**: perguntar se quer remover contatos específicos antes de prosseguir.

### Passo 6 — Revisão + Lotes

```
Campanha: [nome]
Contatos: [N] válidos
Por lote: [perguntar — padrão 50]
Total de lotes: [N]
Intervalo: [N]s entre cada mensagem
Tempo estimado por lote: [calcular]
```

"Confirmar primeiro lote?"

### Passo 7 — Disparar com progresso

Usar `scripts/disparar-campanha.ps1` (adaptar para os parâmetros):

```powershell
$campanha = "slug"
$arquivo = "dados/contatos/validados-<campanha>.csv"
$url = "<URL>"
$apiKey = "<API_KEY>"
$instancias = @("chip1", "chip2")
$intervaloMin = 10
$intervaloMax = 70
$midia = "campanhas/midia/<campanha>/imagem.jpg"  # se houver
$lote = 50  # perguntar ao usuário
```

O script DEVE:

**a) Trocar variáveis corretamente:**
```powershell
$mensagem = $variacao -replace '\{nome\}', $nome -replace '\{\s*nome\}', $nome
```
Isso cobre tanto `{nome}` quanto `{ nome}` (com espaço).

**b) Comprimir mídia automaticamente:**
Se imagem maior que 500KB, comprimir com Python antes de enviar.

**c) Salvar progresso a cada envio:**
```csv
# logs/<campanha>-progresso.csv
telefone,nome,instancia,variacao,status,data_hora
```

**d) Ao finalizar o lote, parar e perguntar:**
```
Lote [N] concluído. [sucesso/falha]. Quer continuar com o próximo lote?
```

**e) Se houver erro no envio, mostrar erro claro:**
```
[1/251] RODOLFO VOLL -> erro: 500 - imagem muito grande (2.8MB)
```

### Passo 8 — Finalização

```
? Campanha [nome] finalizada

Total: [N]
Sucesso: [N]
Falha: [N]
Tempo total: [N] min
Lotes: [N]

Log: logs/<campanha>-<data>.csv
```

---

## Regras

- Sempre verificar progresso antes de começar
- Pré-validação ANTES do disparo (não durante)
- {nome} com ou sem espaço — regex cobre ambos
- Imagens >500KB comprimir automaticamente
- Perguntar a cada lote se quer continuar
- Salvar progresso a cada envio para permitir resume
