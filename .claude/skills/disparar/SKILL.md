---
name: disparar
description: >
  Executa o disparo de uma campanha via Evolution API. Lê contatos, aplica roteamento
  por chip (consistência de vínculo), envia mensagens com intervalo, registra resultados.
  Use quando o usuário disser "disparar", "executar campanha", "enviar mensagens", "/disparar".
---

# /disparar — Execução de disparo via Evolution API

## Dependências

- `_memoria/config.yaml` — URL da Evolution API + instâncias
- Campanha criada em `campanhas/`
- Lista de contatos em `dados/contatos/`
- Vínculos em `dados/contatos/vinculos.csv`

---

## Workflow

### Passo 1 — Carregar config

Ler `_memoria/config.yaml` para obter:
- `evolution_api.url`
- `chips` (id, nome, instancia)
- `intervalo_segundos`

---

### Passo 2 — Verificar instâncias

Para cada chip que vai ser usado, verificar se está conectado:

```bash
curl -s -X GET "<URL>/instance/connectionState/<instancia>"
```

Se alguma estiver desconectada:
> "O Chip [N] está desconectado. Quer conectar com /conectar-chip ou pular os contatos desse chip?"

---

### Passo 3 — Selecionar campanha

Listar campanhas com status "Criada — aguardando disparo" em `campanhas/`.

"Qual campanha disparar?"

---

### Passo 4 — Revisão final

```
Campanha: [nome]
Contatos: [N]
  Chip 1 (<instancia>): [N] contatos — ? conectado
  Chip 2 (<instancia>): [N] contatos — ? conectado
  Sem chip: [N] (distribuir)
Intervalo: [N]s
Tempo estimado: [calcular]

Confirmar disparo? (sim/nao)
```

---

### Passo 5 — Disparar

Para cada contato na lista:

**Verificar chip:**
- Se tem vínculo em `vinculos.csv` → usar chip registrado
- Se não → atribuir chip com menos contatos → registrar

**Preparar mensagem:**
- Substituir variáveis (`{nome}`, `{empresa}`)
- Garantir que o número esteja no formato `55XXXXXXXXXXX`

**Enviar via Evolution API:**
```bash
curl -s -X POST "<URL>/message/sendText/<instancia>" \
  -H "Content-Type: application/json" \
  -d '{"number": "55XXXXXXXXXXX", "text": "[mensagem]", "delay": 1}'
```

Capturar resposta:
- `{"status": "success"}` ou `{"status": 200}` → sucesso
- Qualquer erro → falha

**Aguardar** `intervalo_segundos`.

**Registrar** em `logs/<campanha>-<YYYYMMDDHHmm>.csv`:
```csv
telefone,instancia,chip_id,status,data_hora,erro
55XXXXXXXXXXX,chip1,1,sucesso,2026-07-21T10:00:00,
55XXXXXXXXXXX,chip2,2,erro,2026-07-21T10:00:30,instance_disconnected
```

**Exibir progresso:** `[N/N] — [N] ok, [N] falha`

---

### Passo 6 — Tratamento de erro

| Erro | Ação |
|------|------|
| `instance_disconnected` | Pausar chip, avisar, perguntar se quer pular contatos desse chip |
| `number_not_registered` | Registrar como falha, pular, continuar |
| `timeout` | Tentar 1x após 30s, se falhar: pular |
| Qualquer outro | Registrar erro, pular, continuar |

**Nunca** redirecionar contato vinculado para outro chip sem permissão explícita.

---

### Passo 7 — Finalização

```
? Campanha [nome] finalizada

Total: [N] enviados
Sucesso: [N]
Falha: [N]
Tempo total: [N] min

Por chip:
  Chip 1 (<instancia>): [N] disparos
  Chip 2 (<instancia>): [N] disparos

Log salvo em: logs/<campanha>-<data>.csv
```

Perguntar: "Quer gerar um relatório resumido?"
