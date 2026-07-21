---
name: contatos
description: >
  Gerencia a base de contatos. Lista arquivos importados, deduplica entre listas,
  busca contatos por nome/telefone, exporta, remove, e vincula contatos a chips manualmente.
  Use quando o usuário disser "contatos", "gerenciar contatos", "ver lista", "/contatos".
---

# /contatos — Gestão de contatos

## Dependências

- Arquivos CSV em `dados/contatos/`

---

## Workflow

### Passo 1 — Visão geral

Listar todos os arquivos em `dados/contatos/*.csv` com:

```
Contatos totais: [N]
Arquivos: [N]
Última importação: [arquivo] — [N] contatos em [data]
Contatos com chip vinculado: [N] (Chip 1: [N], Chip 2: [N])
Contatos sem chip: [N]
```

---

### Passo 2 — Ações

Perguntar: "O que você quer fazer?"

**Opções:**
1. **Listar contatos** — mostrar N por página, buscar por nome/telefone
2. **Deduplicar** — varrer todos CSVs, remover telefones repetidos entre listas, gerar `dados/contatos/base-unica.csv`
3. **Vincular chip** — vincular manualmente contatos específicos a um chip
4. **Importar CSV** — importar arquivo CSV externo
5. **Exportar** — exportar base completa ou filtrada
6. **Remover** — remover contatos específicos

---

### Passo 3 — Deduplicação (quando solicitado)

1. Carregar todos CSVs de `dados/contatos/`
2. Agrupar por telefone
3. Se mesmo telefone aparecer em múltiplos arquivos, manter o registro mais antigo
4. Se mesmo telefone tiver chip vinculado em um e vazio em outro, manter o vinculado
5. Gerar `dados/contatos/base-unica.csv` com desduplicação
6. Mostrar: "Duplicatas encontradas: [N]. Base única gerada com [N] contatos."

---

### Passo 4 — Vincular chip

Para vincular manualmente:

1. Buscar contato por telefone ou nome
2. Mostrar contato encontrado
3. Perguntar: "Vincular a qual chip? (1 ou 2)"
4. Atualizar CSV com chip definido
5. Registrar em `dados/contatos/vinculos.csv`:

```csv
telefone,chip,data_vinculo,origem
55XXXXXXXXXXX,1,2026-07-21,manual
```

---

### Passo 5 — Auto-vinculação

Ao disparar, contatos sem chip recebem o chip que tiver menor carga no momento. O vínculo fica registrado e nunca mais muda.

---

## Regras

- Um contato vinculado a um chip NUNCA troca automaticamente
- Deduplicação nunca remove o vínculo de chip existente
- Ao importar CSV, validar formato do telefone antes de salvar
