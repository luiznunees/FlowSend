---
name: instalar
description: >
  Setup completo do FlowSend. Instala globalmente, configura Evolution API, chips,
  intervalo e estrutura. Use na primeira vez: "/instalar". Pergunta cada detalhe.
---

# /instalar — Setup completo do FlowSend

## Workflow

### 0. Instalação global (sempre)

"Primeiro vou instalar o FlowSend globalmente. Assim você nunca precisa clonar de novo. Pode ser?"

Se sim:
- Detectar SO (Windows: `powershell`, Linux/Mac: `bash`)
- Executar script de instalação global:
  ```bash
  # Windows
  .\install-global.ps1
  ```
  ```bash
  # Linux/Mac
  chmod +x install-global.sh && ./install-global.sh
  ```
- Confirmar: "FlowSend instalado em ~/.config/opencode/skills/. Nas próximas vezes, é só criar uma pasta e abrir o OpenCode."

Se não (improvável, mas perguntar): "Tudo bem, vamos configurar só nesta pasta então."

---

### 1. Evolution API

"Qual a URL da sua Evolution API?" (padrão mostrado: https://apps-evolution-api.mnfvp3.easypanel.host)

"Qual a API Key?" (padrão mostrado)

Se o usuário não tiver Evolution instalado:
> "Precisa do Evolution API rodando. Quer que eu suba com Docker agora?"
Se sim:
```bash
git clone https://github.com/EvolutionAPI/evolution-api.git /tmp/evolution-api
cd /tmp/evolution-api
docker compose up -d
```
Confirmar URL depois.

---

### 2. Chips

"Quantos chips você tem para disparo?" (padrão: 2)

Para cada chip:
- "Qual o nome do Chip [N]? (ex: Chip 1, Vivo, Claro, Tim)"
- "Qual o nome da instância no Evolution API? (ex: chip1, chip2)"

---

### 3. Intervalo

"Qual o intervalo entre disparos?" (padrão: 30 segundos)

---

### 4. Pasta de entrada

"Onde colocar os PDFs para extrair?" (padrão: dados/importados/)

---

### 5. Salvar config

Salvar em `_memoria/config.yaml`:

```yaml
evolution_api:
  url: "<URL>"
  api_key: "<API_KEY>"
chips:
  - id: 1
    nome: "Chip 1"
    instancia: "chip1"
  - id: 2
    nome: "Chip 2"
    instancia: "chip2"
intervalo_segundos: 30
pasta_entrada: "dados/importados/"
```

---

### 6. Criar estrutura

Criar pastas: `dados/importados/`, `dados/contatos/`, `campanhas/`, `logs/`, `_memoria/`

---

### 7. Convidar para conectar chips

"Agora vamos conectar os chips via QR Code. Quer fazer agora com /conectar-chip?"

---

### 8. Resumo

```
? FlowSend instalado globalmente + configurado!

Evolution API: [URL]
Chips: [N]
Intervalo: [N]s

Próximos passos:
1. /conectar-chip — conectar cada chip via QR Code
2. Colocar PDFs em dados/importados/
3. /extrair-pdf
4. /campanha
5. /disparar

? Dica: da próxima vez, crie uma pasta vazia, abra o OpenCode,
  e as skills já estarão disponíveis (instalação global).
```
