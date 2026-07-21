---
name: campanha
description: >
  Cria e gerencia campanhas de disparo. Define nome, template de mensagem,
  lista de contatos alvo, chip (ou automático), agendamento. Salva em campanhas/.
  Use quando o usuário disser "criar campanha", "nova campanha", "agendar disparo", "/campanha".
---

# /campanha — Criação de campanha

## Dependências

- Lista de contatos em `dados/contatos/`
- Arquivo de vínculos em `dados/contatos/vinculos.csv`

---

## Workflow

### Passo 1 — Nome da campanha

"Qual o nome dessa campanha? (ex: Black Friday 2026, Follow-up leads site)"

### Passo 2 — Mensagem

"Qual a mensagem que vai ser enviada? Pode digitar o texto aqui."

Suporta variáveis:
- `{nome}` — nome do contato (se disponível no CSV)
- `{empresa}` — empresa do contato

Exemplo:
```
Olá {nome}, tudo bem? 
Aqui é [seu nome] da [sua empresa].
Vi que você tem interesse em [assunto]...
```

Validar: a mensagem deve ser clara e não parecer spam. Se parecer, sugerir ajustes.

---

### Passo 3 — Lista alvo

"Qual lista de contatos usar?"

Listar CSVs disponíveis em `dados/contatos/`:
1. Base única (`base-unica.csv`)
2. Arquivo específico
3. Filtrar por chip (Chip 1, Chip 2, ou todos)

---

### Passo 4 — Roteamento

"Como definir o chip?"

1. **Automático** — respeita vínculos existentes; contatos sem chip são distribuídos para equilibrar carga
2. **Chip específico** — força todos os disparos por um chip (exceto contatos vinculados ao outro — esses não podem ser forçados)

---

### Passo 5 — Agendamento

"Quer disparar agora ou agendar?"

1. Agora
2. Agendar para data/hora específica
3. Agendar em lotes (ex: 100 contatos por dia)

---

### Passo 6 — Salvar

Salvar em `campanhas/<slug-da-campanha>-<YYYY-MM-DD>.md`:

```markdown
# Campanha: [Nome]
*Criada em [data]*

## Configuração
- **Lista alvo:** [arquivo.csv] ([N] contatos)
- **Roteamento:** [automático | chip específico]
- **Agendamento:** [agora | data]
- **Intervalo:** [N] segundos

## Template
```
[mensagem]
```

## Status
? Criada — aguardando disparo
```

---

### Passo 7 — Próximo passo

"Campanha criada! Quer disparar agora com `/disparar` ou ajustar mais alguma coisa?"
