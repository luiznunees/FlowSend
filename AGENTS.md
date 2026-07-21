# FlowSend — Sistema de disparo inteligente

⚠️ REGRA CRÍTICA: Sempre responda. Nunca fique em silêncio. Se pensar, escreva. Se não souber, pergunte.

⚠️ REGRA #2: PERGUNTE TUDO. Extraia cada informação do usuário passo a passo. Não assuma nada. Pergunte nome, mensagem, lista, chip, horário — cada detalhe.

⚠️ REGRA #3: NUNCA crie informação fictícia. Se não tiver o dado, pergunte. Não invente números, nomes, datas, contatos, nada.

FlowSend gerencia disparos de mensagens com roteamento entre chips. Extrai contatos de PDFs, gerencia listas, cria campanhas e dispara com consistência — um contato vinculado ao Chip 1 sempre vai pelo Chip 1.

Skills em `.claude/skills/`, comandos em `.opencode/commands/` (Ctrl+K). Após o `/instalar`, as skills são copiadas para `~/.config/opencode/skills/` e ficam disponíveis em qualquer projeto.

---

## Setup inicial

Se for o primeiro uso, execute o comando `instalar` (Ctrl+K) ou peça: "Roda o /instalar". O sistema vai:

1. Instalar FlowSend globalmente (copiar skills para ~/.config/opencode/skills/)
2. Perguntar a URL da Evolution API e API Key
3. Perguntar quantos chips, nomes e instâncias
4. Perguntar intervalo entre disparos
5. Criar estrutura de pastas (dados/, campanhas/, logs/, _memoria/)
6. Convidar para conectar os chips via QR Code

O `/instalar` roda uma vez só nesse projeto. Depois, é só usar.

---

## Skills

Antes de executar qualquer tarefa, verificar se existe skill relevante em `.claude/skills/` usando a ferramenta `skill`. Skills disponíveis:

- `instalar` — Setup completo (instalação global + configuração)
- `extrair-pdf` — Extrai telefones de PDFs e salva como CSV
- `contatos` — Gerencia listas, dedup, vincula chips
- `campanha` — Cria campanha com template e lista alvo
- `disparar` — Executa disparo via Evolution API
- `chip-status` — Mostra status dos chips
- `conectar-chip` — Conecta chip via QR Code
- `projetos` — Gerencia múltiplos projetos/clientes

---

## Comandos

Quando o usuário disser "/instalar", "/extrair-pdf", "/contatos" ou qualquer "/comando", carregue a skill correspondente com a ferramenta `skill` e execute o workflow. Comandos também via Ctrl+K.

O usuário pode falar de forma solta. "Quero disparar mensagens" → carregar a skill relevante ou guiar passo a passo. "Faz o flow" → verificar onde está (instalado? configurado?) e agir.

---

## CLAs — Regras de operação

Antes de responder, ler os arquivos em `_regras/*.yaml`. Regras com severidade "obrigatória" devem ser seguidas rigorosamente.

---

## Consistência de chip

Regra fundamental: um contato vinculado a um chip nunca troca. Se o contato X foi disparado pelo Chip 1 na primeira vez, todas as campanhas seguintes vão usar o Chip 1. O vínculo é salvo em `dados/contatos/vinculos.csv`.

---

## Estrutura

```
FlowSend/
  .claude/skills/        Skills do sistema
  .opencode/commands/    Comandos customizados
  .opencode/agents/      Agentes especialistas
  _memoria/              Configuração do projeto
  _regras/               CLAs de operação
  dados/
    importados/          PDFs para extrair
    contatos/            Listas de contatos (CSV)
  scripts/               Scripts PowerShell utilitários
  campanhas/             Campanhas criadas
  logs/                  Histórico de disparos + progresso
```
