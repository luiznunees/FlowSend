# FlowSend

> Sistema de disparo inteligente com roteamento entre chips.

Extrai contatos de PDFs, gerencia listas, cria campanhas e dispara mensagens
com consistência — cada contato sempre pelo mesmo chip.

---

## Fluxo completo

```
1. Colocar PDFs em dados/importados/
2. /extrair-pdf → extrai números
3. /contatos → gerencia e deduplica
4. /campanha → cria campanha com template
5. /disparar → executa com roteamento inteligente
6. /chip-status → acompanha resultados
```

## Regra fundamental

Um contato vinculado ao Chip 1 sempre será disparado pelo Chip 1.
Nunca troca automaticamente.

---

## Estrutura

```
FlowSend/
  dados/
    importados/     PDFs para extrair
    contatos/       Listas extraídas (CSV)
  campanhas/        Campanhas criadas
  logs/             Histórico de disparos
  _memoria/         Configuração do sistema
  _regras/          CLAs de operação
```

Feito com base no [KrommaOS](https://github.com/luiznunees/KrommaOS).
