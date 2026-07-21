---
name: extrair-pdf
description: >
  Extrai números de telefone de arquivos PDF. Lê todos os PDFs em dados/importados/,
  aplica regex para telefones brasileiros, remove duplicatas, salva como CSV.
  Use quando: "extrair pdf", "extrair números", "tirar contatos dos pdfs", "/extrair-pdf".
---

# /extrair-pdf — Extração de contatos de PDF

## Workflow

### Passo 1 — Localizar PDFs

Listar arquivos em `dados/importados/` com extensão `.pdf`.

- Se não houver nenhum: "Onde estão os PDFs? Pode colar o caminho."
- Se houver +5: "Extrair todos de uma vez ou um por um?"

---

### Passo 2 — Extrair

Para cada PDF:

1. Usar ferramenta de leitura para extrair texto
2. Regex para números brasileiros: `(\+?55)?\s*\(?\d{2}\)?\s*\d{4,5}-?\d{4}`
3. Remover inválidos (menos de 10 dígitos)
4. Padronizar: `55XXXXXXXXXXX`
5. Remover duplicatas dentro do mesmo arquivo
6. Preview: "Encontrei [N] em [arquivo]"

---

### Passo 3 — Salvar

`dados/contatos/extraidos-<YYYY-MM-DD>-<sequencial>.csv`:

```csv
nome,telefone,arquivo_origem,data_extracao,chip
,55XXXXXXXXXXX,lista-clientes.pdf,2026-07-21,
```

---

### Passo 4 — Mover processados

SE a pasta `dados/importados/` existir, mover PDFs processados para `dados/importados/processados/`. NÃO perguntar.

---

### Passo 5 — Resumo

```
? Extração concluída

Total de PDFs: [N]
Total de números extraídos: [N]
Duplicatas removidas: [N]
Arquivo salvo: dados/contatos/extraidos-<data>.csv

Próximo passo: /contatos para gerenciar a lista e vincular chips.
```
