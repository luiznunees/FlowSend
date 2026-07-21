---
name: disparar
description: >
  Executa o disparo de uma campanha. Lê a lista de contatos, aplica roteamento por chip
  (respeitando vínculos), envia mensagens com intervalo configurado, e registra resultados
  em logs/. Exibe progresso em tempo real. Use quando o usuário disser "disparar", "executar
  campanha", "enviar mensagens", "/disparar".
---

# /disparar — Execução de disparo

## Dependências

- Campanha criada em `campanhas/`
- Lista de contatos em `dados/contatos/`
- Vínculos em `dados/contatos/vinculos.csv`
- Intervalo configurado (padrão: 30s entre mensagens)

---

## Workflow

### Passo 1 — Selecionar campanha

Listar campanhas com status "Criada — aguardando disparo" em `campanhas/`.

"Qual campanha disparar?"

---

### Passo 2 — Revisão final

Mostrar resumo:

```
Campanha: [nome]
Contatos: [N]
Chip 1: [N] contatos
Chip 2: [N] contatos
Sem chip: [N] (serão distribuídos)
Intervalo: [N]s
Tempo estimado: [calcular: N contatos x intervalo / 60 = minutos]

Confirmar disparo? (sim/nao)
```

---

### Passo 3 — Disparar

Para cada contato na lista:

1. **Verificar chip**:
   - Se tem vínculo em `vinculos.csv` → usar o chip registrado
   - Se não tem → atribuir ao chip com menos contatos no momento → registrar em `vinculos.csv`

2. **Preparar mensagem**:
   - Substituir variáveis (`{nome}`, `{empresa}`)
   - Personalizar se houver dados do contato

3. **Enviar**:
   - Usar ferramenta adequada para o chip (bash com script de envio, ou API)
   - Aguardar intervalo configurado

4. **Registrar** em `logs/<campanha>-<YYYYMMDDHHmm>.csv`:

```csv
telefone,chip,status,data_hora,erro
55XXXXXXXXXXX,1,sucesso,2026-07-21T10:00:00,
55XXXXXXXXXXX,2,sucesso,2026-07-21T10:00:30,
55XXXXXXXXXXX,1,erro,2026-07-21T10:01:00,chip_desconectado
```

5. **Exibir progresso**: `[N/N] enviados — [N] sucesso, [N] falha`

---

### Passo 4 — Tratamento de erro

Se um chip falhar:
- Pausar os disparos desse chip
- Tentar novamente 1 vez após 60s
- Se falhar de novo: "O Chip [N] apresentou erro. Deseja pausar a campanha, pular os contatos desse chip ou tentar com outro chip?"

**Nunca** redirecionar contato vinculado para outro chip sem permissão explícita.

---

### Passo 5 — Finalização

Quando todos os contatos forem processados:

```
? Campanha [nome] finalizada

Total: [N]
Sucesso: [N]
Falha: [N]
Tempo total: [N] min
Chip 1: [N] disparos
Chip 2: [N] disparos

Log salvo em: logs/<campanha>-<data>.csv
```

Perguntar: "Quer gerar um relatório resumido?"
