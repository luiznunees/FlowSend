# FlowSend — Sistema de disparo inteligente

⚠️ REGRA CRÍTICA: Sempre responda. Nunca fique em silêncio. Se pensar, escreva. Se não souber, pergunte.

FlowSend gerencia disparos de mensagens em massa com roteamento entre chips. Extrai contatos de PDFs, gerencia listas, cria campanhas e dispara com consistência — um contato vinculado ao Chip 1 sempre vai pelo Chip 1.

Skills em `.claude/skills/`, comandos em `.opencode/commands/` (Ctrl+K).

---

## Setup inicial

Se for o primeiro uso, execute o comando `instalar` (Ctrl+K) ou peça: "Roda o /instalar". O sistema vai configurar:
1. Quantos chips você tem (2 ou mais)
2. Identificação de cada chip (Chip 1, Chip 2...)
3. Intervalo entre disparos (padrão: 30s)
4. Pasta padrão para PDFs de entrada

---

## Extração de PDFs

Contatos vêm de arquivos PDF. O workflow padrão:
1. Coloque os PDFs em `dados/importados/`
2. `/extrair-pdf` — extrai números e salva em `dados/contatos/`
3. `/contatos` — gerencia, deduplica e vincula chips

---

## Consistência de chip

Regra fundamental: **um contato vinculado a um chip nunca troca**. Se o contato X foi disparado pelo Chip 1 na primeira vez, todas as campanhas seguintes vão usar o Chip 1. O vínculo é salvo em `dados/contatos/vinculos.csv`.

---

## Estrutura de pastas

```
FlowSend/
  dados/
    importados/    PDFs para extrair
    contatos/      Listas de contatos extraídas
  campanhas/       Campanhas criadas e históricos
  logs/            Relatórios de disparo
  _memoria/        Contexto do sistema
  _regras/         CLAs de operação
```

---

## Skills

- `extrair-pdf` — Extrai telefones de PDFs e salva como CSV
- `contatos` — Gerencia listas, dedup, vincula chips
- `campanha` — Cria campanha com template e lista alvo
- `disparar` — Executa disparo respeitando roteamento
- `chip-status` — Mostra status dos chips e vínculos
- `instalar` — Configuração inicial do FlowSend

---

## Comandos

"/comando" carrega a skill em `.claude/skills/` via ferramenta `skill`. Ctrl+K também funciona.

---

## CLAs

Leia `_regras/*.yaml`. Regras "obrigatória" são inderrogáveis.
