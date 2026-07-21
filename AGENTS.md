# FlowSend — Sistema de disparo inteligente

⚠️ REGRA #1: Sempre responda. Nunca fique em silêncio.

⚠️ REGRA #2: NUNCA crie informação fictícia. Se não tiver o dado, diga "não encontrei" e pergunte. Não invente números, nomes, datas, contatos, nada.

⚠️ REGRA #3: Antes de perguntar algo, OLHE os arquivos. Se a resposta já existe em `_memoria/`, `dados/`, `campanhas/`, logs ou config, USE O QUE JÁ TEM. Só pergunte o que realmente não dá pra saber.

FlowSend gerencia disparos com roteamento entre chips. Extrai contatos de PDFs, gerencia listas, cria campanhas e dispara com consistência — um contato vinculado ao Chip 1 sempre pelo Chip 1.

Skills globais em `~/.config/opencode/skills/`, dados do projeto na pasta atual.

---

## Estrutura: um FlowSend para N projetos

FlowSend é instalado UMA VEZ só. Cada projeto/cliente é uma pasta separada com seus próprios dados:

```
~/agencia/
  cliente-a/          # Projeto 1
    _memoria/
    dados/importados/
    dados/contatos/
    campanhas/
    logs/
    .opencode.json    # aponta pro modelo

  cliente-b/          # Projeto 2
    _memoria/
    dados/importados/
    dados/contatos/
    campanhas/
    logs/
```

Skills ficam em `~/.config/opencode/skills/` (global). Cada projeto tem só dados.

Para começar um projeto novo: `/projetos criar nome-do-cliente`
Para trocar: `/projetos` → seleciona

---

## Skills

- `instalar` — Configuração inicial (uma vez, global)
- `extrair-pdf` — Extrai telefones de PDFs
- `contatos` — Gerencia listas, dedup, vincula chips
- `campanha` — Cria campanha com template e lista alvo
- `disparar` — Executa disparo via Evolution API
- `chip-status` — Status dos chips via Evolution API
- `conectar-chip` — Conecta chip à Evolution API via QR Code
- `projetos` — Gerencia múltiplos projetos/clientes

---

## CLAs

Leia `_regras/*.yaml`. Regras "obrigatória" são inderrogáveis.
