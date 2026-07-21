---
name: instalar
description: >
  Configura o FlowSend pela primeira vez. Pergunta quantos chips o usuário tem,
  identifica cada um, define intervalo padrão entre disparos e pasta de entrada.
---

# /instalar — Setup inicial do FlowSend

## Workflow

### 1. Chips
"Quantos chips você tem para disparo?" (padrão: 2)

Para cada chip:
- "Qual o nome do Chip [N]? (ex: Chip 1, Vivo, Claro, Tim)"
- (opcional) "Tem alguma observação sobre esse chip? (ex: limite de disparos por dia, operadora)"

### 2. Intervalo
"Qual o intervalo entre disparos?" (padrão: 30 segundos)

### 3. Pasta de entrada
"Onde você vai colocar os PDFs para extrair?" (padrão: dados/importados/)

### 4. Salvar config

Salvar em `_memoria/config.yaml`:

```yaml
chips:
  - id: 1
    nome: "Chip 1"
    observacao: ""
  - id: 2
    nome: "Chip 2"
    observacao: ""
intervalo_segundos: 30
pasta_entrada: "dados/importados/"
```

### 5. Estrutura inicial
Criar pastas se não existirem.

### 6. Resumo
```
? FlowSend configurado!

Chips: [N]
Intervalo: [N]s
Pasta de entrada: dados/importados/

Próximos passos:
1. Coloque os PDFs em dados/importados/
2. /extrair-pdf para extrair contatos
3. /campanha para criar sua primeira campanha
```
