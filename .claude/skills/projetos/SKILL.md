---
name: projetos
description: >
  Gerencia múltiplos projetos/clientes dentro do FlowSend. Lista projetos, cria novo,
  mostra qual está ativo, sugere navegação. Cada projeto tem seus próprios dados, contatos,
  campanhas e logs. Use quando o usuário disser "projetos", "clientes", "trocar de projeto",
  "novo cliente", "/projetos".
---

# /projetos — Gestão de múltiplos projetos

## Como funciona

FlowSend é instalado uma vez. Cada cliente/projeto é uma pasta separada.
Esta skill gerencia essas pastas: cria, lista, ajuda a navegar entre elas.

---

## Workflow

### Ação 1 — Listar projetos

Escaneia o diretório atual e parentes próximos por pastas que contenham `_memoria/` + `dados/contatos/`.

Mostrar:

```
Projetos encontrados:

1. ? [cliente-a]     — Último disparo: 20/07 — [N] contatos
2. ? [cliente-b]     — Ainda sem disparos
3. ? [cliente-c]     — Último disparo: 15/07 — [N] contatos

? Projeto atual: [nome] (pasta: ./)

Comandos:
- /projetos criar <nome>  → novo projeto
- /projetos abrir <nome>  → mostrar caminho da pasta
- abrir projeto [numero]  → navegar
```

Se não encontrar nenhum outro projeto, perguntar:
"Quer criar um novo projeto para um cliente?"

---

### Ação 2 — Criar projeto

"Qual o nome do projeto/cliente?"

Criar estrutura em `../<slug-do-projeto>/`:

```
../<slug>/
  _memoria/
    config.yaml    → copia config do projeto atual
  dados/
    importados/
    contatos/
  campanhas/
  logs/
```

Perguntar: "Projeto criado em ../<slug>/. Quer abrir ele agora? (sim/nao)"

Se sim, mostrar o caminho: "Feche o OpenCode, navegue até ../<slug>/ e rode `opencode` lá."

---

### Ação 3 — Mostrar resumo do projeto

Quando chamado dentro de um projeto, mostrar:

```
? Projeto atual: [nome-cliente]

Contatos: [N] (Chip 1: [N] | Chip 2: [N] | sem chip: [N])
Campanhas realizadas: [N]
Último disparo: [data]
PDFs aguardando: [N] em dados/importados/

Skills disponíveis no FlowSend (instalação global)
```

---

## Regras

- Cada projeto é independente — contatos, vínculos e campanhas não se misturam
- Para trabalhar em outro projeto: feche o OpenCode, navegue até a pasta, abra de novo
- O comando `criar` só cria a estrutura — não migra dados entre projetos
- Se o usuário disser "quero ver o projeto X", mostrar o caminho da pasta
