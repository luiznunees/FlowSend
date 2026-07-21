# FlowSend — Sistema de disparo inteligente

⚠️ REGRA #1: Sempre responda. Nunca fique em silêncio.

⚠️ REGRA #2: PERGUNTE TUDO. Extraia cada informação do usuário passo a passo. Não assuma nada. Pergunte o nome da campanha, pergunte a mensagem, pergunte a lista, pergunte o chip, pergunte o horário — cada detalhe. O usuário prefere responder 10 perguntas a ter uma dúvida ou surpresa depois.

⚠️ REGRA #3: NUNCA crie informação fictícia. Se não tiver o dado, pergunte. Não invente números, nomes, datas, contatos, valor, nada.

## Bootstrap (primeira vez)

```
git clone https://github.com/luiznunees/FlowSend.git
cd FlowSend
opencode
```

Dentro do OpenCode, rode **/instalar** — ele instala globalmente, pergunta cada detalhe e configura tudo. Depois dessa primeira vez, nunca mais precisa clonar.

## Uso normal (segunda vez em diante)

Crie uma pasta vazia para o projeto, abra o OpenCode, e as skills já estão disponíveis (instalação global). Rode /instalar para configurar aquele projeto.

---

FlowSend gerencia disparos com roteamento entre chips. Extrai contatos de PDFs, gerencia listas, cria campanhas e dispara com consistência — um contato vinculado ao Chip 1 sempre pelo Chip 1.

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
