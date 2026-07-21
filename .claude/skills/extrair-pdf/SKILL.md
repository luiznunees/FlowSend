---
name: extrair-pdf
description: >
  Extrai números de telefone de arquivos PDF. Lê todos os PDFs em dados/importados/,
  aplica regex para telefones brasileiros (com e sem DDD, com e sem formatação),
  remove duplicatas dentro do mesmo arquivo, e salva como CSV em dados/contatos/.
  Use quando o usuário disser "extrair pdf", "extrair números", "tirar contatos dos pdfs", "/extrair-pdf".
---

# /extrair-pdf — Extração de contatos de PDF

## Dependências

- Arquivos PDF em `dados/importados/` OU caminho informado pelo usuário

---

## Workflow

### Passo 1 — Localizar PDFs

Listar arquivos em `dados/importados/` com extensão `.pdf`.

Se não houver nenhum, perguntar: "Onde estão os PDFs? Pode colar o caminho ou arrastar os arquivos pra cá que eu leio."

Se houver mais de 5 PDFs, perguntar: "Quer extrair todos de uma vez ou um por um?"

---

### Passo 2 — Extrair

Para cada PDF:

1. Usar ferramenta de leitura para extrair texto
2. Aplicar regex para números brasileiros:
   - `(\+?55)?\s*\(?\d{2}\)?\s*\d{4,5}-?\d{4}`
   - Capturar com e sem DDD
   - Capturar com e sem formatação (parênteses, hífen, espaço)
3. Remover números inválidos (menos de 10 dígitos)
4. Padronizar formato: `55XXXXXXXXXXX` (com DDD, sem formatação)
5. Remover duplicatas dentro do mesmo arquivo
6. Mostrar preview: "Encontrei [N] números em [arquivo]. Primeiros 5: [lista]"

---

### Passo 3 — Salvar

Salvar em `dados/contatos/extraidos-<YYYY-MM-DD>-<sequencial>.csv`:

```csv
nome,telefone,arquivo_origem,data_extracao,chip
,55XXXXXXXXXXX,lista-clientes.pdf,2026-07-21,
```

A coluna `nome` fica vazia (preenchida depois). A coluna `chip` fica vazia (vinculada no `/disparar`).

---

### Passo 4 — Acumular

Perguntar: "Quer mover os PDFs processados pra `dados/importados/processados/` pra não reprocessar depois?"

Criar a pasta se necessário.

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
