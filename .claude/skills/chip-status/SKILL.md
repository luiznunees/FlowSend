---
name: chip-status
description: >
  Mostra o status atual dos chips: quantos contatos vinculados a cada um,
  quantos disparos foram feitos por chip, contatos sem vínculo, logs recentes.
  Use quando o usuário disser "status dos chips", "ver chips", "como estão os chips", "/chip-status".
---

# /chip-status — Status dos chips

## Dependências

- `dados/contatos/vinculos.csv` — vínculos contato↔chip
- `logs/` — histórico de disparos

---

## Workflow

### Passo 1 — Carregar dados

Ler `dados/contatos/vinculos.csv` (se existir) e logs recentes em `logs/`.

---

### Passo 2 — Montar painel

```markdown
# Status dos Chips — [data]

## Resumo
| Chip | Contatos vinculados | Total disparos hoje | Último disparo |
|------|--------------------|--------------------|----------------|
| Chip 1 | [N] | [N] | [hora] |
| Chip 2 | [N] | [N] | [hora] |
| **Total** | **[N]** | **[N]** | |

- Contatos sem chip: [N]
- Total de campanhas já executadas: [N]

## Distribuição
[gráfico textual ou proporção]

## Últimos logs
[últimas 5 linhas do log mais recente]
```

---

### Passo 3 — Alertas

Identificar:
- Chips com muita diferença de carga (ex: Chip 1 com 500, Chip 2 com 50) → sugerir distribuir próximos contatos sem chip pro mais vazio
- Chips sem disparo há mais de 7 dias
- Logs com taxa de erro alta (>10%)

---

### Passo 4 — Sugestões

Baseado no painel:
- "Chip 2 está com poucos contatos. Quer direcionar os próximos pra ele?"
- "Taxa de erro alta no Chip 1. Quer verificar se ele está conectado?"
