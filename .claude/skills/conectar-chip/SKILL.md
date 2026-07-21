---
name: conectar-chip
description: >
  Conecta cada chip à Evolution API via QR Code. Cria a instância, gera o QR Code
  para escanear com o WhatsApp, e confirma a conexão. Use quando o usuário disser
  "conectar chip", "conectar WhatsApp", "QR Code", "scannear", "/conectar-chip",
  ou depois do /instalar como próximo passo.
---

# /conectar-chip — Conexão dos chips via Evolution API

## Dependências

- `_memoria/config.yaml` — config com URL da Evolution API e instâncias
- Evolution API rodando e acessível

---

## Workflow

### Passo 1 — Carregar config

Ler `_memoria/config.yaml`. Listar instâncias configuradas.

```
Instâncias configuradas:
- chip1 → Chip 1
- chip2 → Chip 2
```

Perguntar: "Qual chip quer conectar?"

---

### Passo 2 — Verificar instância

Chamar Evolution API para ver se a instância já existe:

```bash
curl -s -X GET "<URL>/instance/fetchInstances" -H "apiKey: <API_KEY>"
```

Se já existir e estiver conectada (`connectionState: "open"`):
> "O Chip [N] já está conectado. Quer reconectar?"

Se existir mas estiver desconectada:
> "A instância existe mas está desconectada. Quer gerar novo QR Code?"

Se não existir, criar:

```bash
curl -s -X POST "<URL>/instance/create" -H "apiKey: <API_KEY>" \
  -H "Content-Type: application/json" \
  -d '{"instanceName": "<instancia>"}'
```

---

### Passo 3 — Gerar QR Code

```bash
curl -s -X GET "<URL>/instance/qrcode/<instancia>?base64=true" -H "apiKey: <API_KEY>"
```

Mostrar o QR Code (imagem base64) OU exibir instrução:
> "Abra o WhatsApp no celular do Chip [N].
> Vá em Aparelhos conectados → Conectar um dispositivo.
> Escaneie o QR Code abaixo:"

(pausar até o usuário confirmar que escaneou)

---

### Passo 4 — Confirmar conexão

Verificar status:

```bash
curl -s -X GET "<URL>/instance/connectionState/<instancia>" -H "apiKey: <API_KEY>"
```

Se `connectionState: "open"`:
```
? Chip [N] conectado com sucesso!
```
Se não:
> "Parece que não conectou. Pode tentar escanear de novo? (sim/nao)"

---

### Passo 5 — Próximo chip

"Quer conectar o Chip [N+1] também?"

Se sim, repetir. Se não:

```
? Todos os chips configurados!

Próximo passo:
- Coloque PDFs em dados/importados/ e rode /extrair-pdf
- Ou crie uma campanha com /campanha
```
