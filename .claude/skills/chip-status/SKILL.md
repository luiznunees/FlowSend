---
name: chip-status
description: >
  Mostra status dos chips via Evolution API: conexão, contatos vinculados, disparos do dia,
  logs recentes. Verifica se cada instância está online.
  Use quando o usuário disser "status dos chips", "ver chips", "/chip-status".
---

# /chip-status — Status dos chips via Evolution API

## Dependências

- `_memoria/config.yaml` — URL + instâncias
- `dados/contatos/vinculos.csv` — vínculos contato↔chip
- `logs/` — histórico de disparos

---

## Workflow

### Passo 1 — Carregar config e verificar Evolution API

Ler `_memoria/config.yaml`.

Verificar conexão com Evolution API:
```bash
curl -s -o /dev/null -w "%{http_code}" "<URL>/" -H "apiKey: <API_KEY>"
```
Se não for 200: "Evolution API não está respondendo em [URL]. Verifique se o servidor está ligado."

---

### Passo 2 — Verificar cada instância

Para cada chip, chamar:
```bash
curl -s -X GET "<URL>/instance/connectionState/<instancia>" -H "apiKey: <API_KEY>"
```

Mapear resultado:
- `"connectionState": "open"` → ? Conectado
- `"connectionState": "close"` ou `"connecting"` → ? Desconectado
- 404 → Instância não encontrada (nunca foi criada)

---

### Passo 3 — Montar painel

```markdown
# Status dos Chips — [data]

## Evolution API
? [URL] — Online

## Chips
| Chip | Instância | Conexão | Contatos | Disparos hoje | Último disparo |
|------|-----------|---------|----------|---------------|----------------|
| Chip 1 | chip1 | ? Conectado | [N] | [N] | [hora] |
| Chip 2 | chip2 | ? Desconectado | [N] | [N] | [hora] |

- Contatos sem chip: [N]
- Total de campanhas executadas: [N]
```

---

### Passo 4 — Alertas

- Instância desconectada → "Chip [N] está desconectado. /conectar-chip"
- Taxa de erro > 10% nos logs recentes → alerta vermelho
- Chip muito sobrecarregado vs outro vazio → sugere redistribuir

---

### Passo 5 — Sugestões

- "Evolution API não responde — verificar se o Docker está rodando"
- "Chip [N] desconectado — rodar /conectar-chip"
- "Chip [N] com taxa de erro alta — verificar número dos contatos"
