---
name: campanha
description: >
  Cria e gerencia campanhas de disparo. Pergunte nome, template, lista, chip,
  agendamento. Se tiver imagem, comprima automaticamente. Salva em campanhas/.
  Use quando: "criar campanha", "nova campanha", "agendar disparo", "/campanha".
---

# /campanha — Criação de campanha

## Workflow

### Passo 1 — Nome

"Qual o nome dessa campanha?"

### Passo 2 — Mensagem

"Qual a mensagem? Pode digitar."

Use APENAS `{nome}` (sem espaço após a chave). O script de disparo substitui `{nome}` pelo nome do lead. Se usar `{ nome}` com espaço, a substituição NÃO funciona.

Exemplo correto:
```
Olá {nome}, tudo bem? Aqui é da Imobiliária Casa Mar...
```

Exemplo ERRADO (não funciona):
```
Olá { nome}, tudo bem?   # ← espaço depois de { quebra a substituição
```

Validar: clara, sem parecer spam.

### Passo 3 — Lista

"Qual lista de contatos?"

CSVs em `dados/contatos/`:
1. Base única
2. Arquivo específico
3. Filtrar por chip

### Passo 4 — Roteamento

"Como definir o chip?"
1. Automático
2. Chip específico

### Passo 5 — Agendamento

"Quando disparar?"
1. Agora
2. Data/hora
3. Em lotes

### Passo 6 — Mídia (opcional)

"Quer incluir uma foto ou imagem?"

Se sim:
1. Pedir o arquivo
2. **Comprimir automaticamente** — se for PNG/JPG maior que 500KB, usar Python para redimensionar (máx 800px) e salvar como JPEG qualidade 70
3. Salvar em `campanhas/midia/<slug>/`
4. Atualizar campanha com `midia: caminho`

### Passo 7 — Salvar

`campanhas/<slug>-<YYYY-MM-DD>.md`:

```markdown
# Campanha: [Nome]
*Criada em [data]*

## Configuração
- **Lista:** [arquivo.csv] ([N] contatos)
- **Roteamento:** [automático]
- **Agendamento:** [agora]
- **Intervalo:** [N]s
- **Tipo:** [texto | texto + imagem]
- **Mídia:** [caminho] (se houver)

## Template
```
Olá {nome}, [mensagem]
```

## Status
Criada — aguardando disparo
```

IMPORTANTE: mensagem deve usar `{nome}` sem espaço. Não usar `{ nome}`.

### Passo 8 — Próximo

"Campanha criada! Quer validar os contatos e disparar com /disparar?"
