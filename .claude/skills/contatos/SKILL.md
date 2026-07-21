---
name: contatos
description: >
  Gerencia a base de contatos. Lista, deduplica, busca, exporta, remove, vincula chips.
  ANTES de perguntar qualquer coisa, LEIA os arquivos existentes em dados/contatos/.
  Use quando: "contatos", "gerenciar contatos", "ver lista", "vincular chip", "deduplicar", "/contatos".
---

# /contatos — Gestão de contatos

## Workflow

### Passo 1 — Ler tudo antes de perguntar

Carregar `dados/contatos/*.csv` e `dados/contatos/vinculos.csv`. Só então decidir.

---

### Passo 2 — Decidir ação sozinho

Regras de decisão (nesta ordem):

1. **Se existem CSVs não-deduplicados** e `base-unica.csv` não existe ou está desatualizado → sugerir dedup
2. **Se existem contatos com chip vazio** → sugerir vincular
3. **Se o usuário pediu algo específico** → fazer
4. **Senão** → só mostrar resumo e perguntar "O que fazer?"

Resumo:

```
Contatos totais: [N]
Arquivos: [N]
Última importação: [arquivo]
Com chip: [N] (Chip 1: [N], Chip 2: [N])
Sem chip: [N]

➡ Sugestão: [ação automática]
```

---

### Passo 3 — Deduplicação

1. Carregar todos CSVs
2. Agrupar por telefone
3. Mesmo telefone em múltiplos: manter o mais antigo
4. Com chip vinculado vs sem: manter o vinculado
5. Gerar `dados/contatos/base-unica.csv`
6. "Duplicatas removidas: [N]. Base única: [N] contatos."

---

### Passo 4 — Vincular chip

Para vincular manualmente:

1. Buscar contato (telefone ou nome)
2. Mostrar resultado
3. "Vincular a qual chip?"
4. Atualizar CSV + `dados/contatos/vinculos.csv`:

```csv
telefone,chip,data_vinculo,origem
55XXXXXXXXXXX,1,2026-07-21,manual
```

---

### Passo 5 — Auto-vinculação

Ao disparar, contatos sem chip recebem o chip de menor carga. O vínculo nunca mais muda.

---

## Regras

- Contato vinculado NUNCA troca automaticamente
- Dedup nunca remove vínculo existente
- Validar formato do telefone ao importar
