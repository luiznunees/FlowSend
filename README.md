# FlowSend

> Sistema de disparo inteligente com roteamento entre chips.

Extrai contatos de PDFs, gerencia listas, cria campanhas e dispara
mensagens com consistência — cada contato sempre pelo mesmo chip.

---

## Ligando o sistema

### Pelo OpenCode

Abre o OpenCode em qualquer pasta e cola:

```
Clona o https://github.com/luiznunees/FlowSend.git na pasta atual,
entra nela e roda o /instalar.
```

Ele clona, entra na pasta nova e dispara a entrevista de setup.
Você só responde.

### Pelo Claude Code

Abre o Claude Code em qualquer pasta e cola:

```
Clona o https://github.com/luiznunees/FlowSend.git na pasta atual,
entra nela e roda o /instalar.
```

---

Quando o `/instalar` terminar, renomeia a pasta FlowSend/ pro nome do
teu projeto (fecha o editor, renomeia no Explorer/Finder, abre de novo).
A pasta não fica como "FlowSend" — ela é o teu projeto agora.

O `/instalar` roda uma vez só e já instala globalmente. Depois disso,
qualquer projeto novo é só criar uma pasta, abrir o OpenCode e rodar
`/instalar` de novo.

---

## Fluxo completo

```
1. /instalar → configura Evolution API + chips
2. /conectar-chip → escaneia QR Code de cada chip
3. Colocar PDFs em dados/importados/
4. /extrair-pdf → extrai números
5. /contatos → gerencia e deduplica
6. /campanha → cria campanha com template
7. /disparar → executa com roteamento inteligente
```

## Regra fundamental

Um contato vinculado ao Chip 1 sempre será disparado pelo Chip 1.
Nunca troca automaticamente.

---

Feito com base no [KrommaOS](https://github.com/luiznunees/KrommaOS).
