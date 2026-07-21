---
name: disparar
description: >
  Executa o disparo de uma campanha via Evolution API. Respeita roteamento por chip
  com consistência de vínculo. ANTES de perguntar, leia campanhas, contatos e vínculos.
  Use quando: "disparar", "executar campanha", "enviar mensagens", "/disparar".
---

# /disparar — Execução de disparo via Evolution API

## Dependências

- `_memoria/config.yaml` — URL + apiKey + instâncias
- Campanha criada em `campanhas/`
- Contatos em `dados/contatos/`
- Vínculos em `dados/contatos/vinculos.csv`

---

## Workflow

### Passo 1 — Carregar config

Ler `_memoria/config.yaml`:
- `evolution_api.url`
- `evolution_api.api_key`
- `chips` (id, nome, instancia)
- `intervalo_segundos`

---

### Passo 2 — Verificar instâncias

Para cada chip que será usado:

```bash
curl -s -X GET "<URL>/instance/connectionState/<instancia>" -H "apiKey: <API_KEY>"
```

Se alguma desconectada: avisar e perguntar se quer pular contatos desse chip ou conectar.

---

### Passo 3 — Selecionar campanha (automático)

Ler campanhas em `campanhas/` com status "aguardando disparo".

- **1 campanha pendente**: Selecionar automaticamente. Só perguntar se quiser outra.
- **Múltiplas**: Listar e perguntar qual.
- **Nenhuma**: "Nenhuma campanha pendente. Criar uma com /campanha?"

---

### Passo 4 — Revisão

```
Campanha: [nome]
Contatos: [N]
  Chip 1: [N] conectado
  Chip 2: [N] conectado
  Sem chip: [N] (distribuir)
Intervalo: [N]s
Tempo estimado: [calcular]

Confirmar? (sim/nao)
```

---

### Passo 5 — Disparar

Para cada contato:

**Definir chip:**
- Vínculo em `vinculos.csv` → usar chip registrado
- Sem vínculo → atribuir chip com menos contatos → registrar vínculo

**Preparar:**
- Substituir `{nome}`, `{empresa}`
- Número no formato `55XXXXXXXXXXX`

**Enviar:**
```bash
curl -s -X POST "<URL>/message/sendText/<instancia>" -H "apiKey: <API_KEY>" \
  -H "Content-Type: application/json" \
  -d '{"number": "55XXXXXXXXXXX", "text": "[mensagem]", "delay": 1}'
```

**Aguardar** `intervalo_segundos` entre cada envio.

**Registrar** em `logs/<campanha>-<YYYYMMDDHHmm>.csv`:
```csv
telefone,instancia,chip_id,status,data_hora,erro
55XXXXXXXXXXX,chip1,1,sucesso,2026-07-21T10:00:00,
55XXXXXXXXXXX,chip2,2,erro,2026-07-21T10:00:30,instance_disconnected
```

**Progresso:** `[N/N] — [N] ok, [N] falha`

---

### Passo 6 — Erros

| Erro | Ação |
|------|------|
| `instance_disconnected` | Pausar chip, avisar, perguntar |
| `number_not_registered` | Falha, pular |
| `timeout` | 1 retentativa após 30s |
| Outro | Registrar, pular |

Nunca redirecionar contato vinculado sem permissão explícita.

---

### Passo 7 — Finalização

```
? Campanha [nome] finalizada

Total: [N] enviados
Sucesso: [N] / Falha: [N]
Tempo: [N] min

Por chip:
  Chip 1: [N] disparos
  Chip 2: [N] disparos

Log: logs/<campanha>-<data>.csv
```
