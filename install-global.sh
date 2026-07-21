#!/bin/bash
# FlowSend - Instalação global
# Copia skills para ~/.config/opencode/skills/ e agents para ~/.config/opencode/agents/
# Assim você pode usar FlowSend em qualquer pasta sem clonar de novo

set -e

SKILLS_SRC=".claude/skills"
AGENTS_SRC=".opencode/agents"
SKILLS_DST="$HOME/.config/opencode/skills"
AGENTS_DST="$HOME/.config/opencode/agents"

echo "? Instalando FlowSend globalmente..."

# Skills
mkdir -p "$SKILLS_DST"
for skill_dir in "$SKILLS_SRC"/*/; do
  skill_name=$(basename "$skill_dir")
  if [ -f "$skill_dir/SKILL.md" ]; then
    mkdir -p "$SKILLS_DST/$skill_name"
    cp "$skill_dir/SKILL.md" "$SKILLS_DST/$skill_name/SKILL.md"
    echo "  ? Skill: $skill_name"
  fi
done

# Agents
if [ -d "$AGENTS_SRC" ]; then
  mkdir -p "$AGENTS_DST"
  cp "$AGENTS_SRC"/*.md "$AGENTS_DST/" 2>/dev/null || true
  echo "  ? Agentes copiados"
fi

# Regras
mkdir -p "$HOME/.config/opencode"
cp -r _regras "$HOME/.config/opencode/flowsend-regras/" 2>/dev/null || true

echo ""
echo "? FlowSend instalado globalmente!"
echo ""
echo "Para usar num projeto novo:"
echo "  1. mkdir -p meu-cliente && cd meu-cliente"
echo "  2. opencode"
echo "  3. Roda /instalar (configura Evolution API)"
echo "  4. Bota os PDFs em dados/importados/"
echo "  5. /extrair-pdf"
echo ""
echo "Skills em: $SKILLS_DST"
echo "Agentes em: $AGENTS_DST"
