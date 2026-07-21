---
name: campanha
description: >
  Cria campanha de disparo. ANTES de perguntar, LEIA contatos, vínculos, campanhas anteriores.
  Monte uma proposta completa e peça confirmação. Use quando: "criar campanha", "nova campanha",
  "agendar disparo", "/campanha".
---

# /campanha — Criação de campanha

## Workflow

### Passo 1 — Ler contexto primeiro

Carregar:
- `dados/contatos/` — listas disponíveis, totais
- `dados/contatos/vinculos.csv` — chips em uso
- `campanhas/` — campanhas anteriores (para inferir padrões)
- `_memoria/config.yaml` — chips do sistema

---

### Passo 2 — Propor campanha completa

Com base no contexto, monte UMA proposta. Use defaults inteligentes:

| Campo | Default |
|-------|---------|
| Nome | "Campanha [data]" (ou última campanha +1) |
| Mensagem | Deixe o USUÁRIO digitar (única pergunta inevitável) |
| Lista alvo | `base-unica.csv` se existir, senão o CSV mais recente |
| Roteamento | Automático (respeitar vínculos existentes) |
| Agendamento | Agora |

Apresentar:

```
? Proposta de campanha

Nome:    [nome sugerido]
Lista:   [arquivo] — [N] contatos
Chip:    Automático (Chip 1: [N] | Chip 2: [N] | sem chip: [N])
Quando:  Agora

Mensagem precisa ser digitada.

1. Aceitar proposta e digitar mensagem
2. Alterar nome
3. Escolher outro CSV
4. Mudar roteamento/agendamento
5. Cancelar
```

---

### Passo 3 — Mensagem

Se aceitou a proposta: "Qual o texto da mensagem?"

Suporta `{nome}` e `{empresa}`.

Se o texto parecer spam, sugerir ajustes.

---

### Passo 4 — Salvar

`campanhas/<slug>-<YYYY-MM-DD>.md`:

```markdown
# Campanha: [Nome]
*Criada em [data]*

## Config
- **Lista:** [arquivo.csv] ([N] contatos)
- **Roteamento:** [automático | chip específico]
- **Agendamento:** [agora | data]
- **Intervalo:** [N]s

## Template
```
[mensagem]
```

## Status
Criada — aguardando disparo
```
