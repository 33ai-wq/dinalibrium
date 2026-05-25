#!/bin/bash
# ================================================================
# Dinalibrium $DLI — Termux/Ubuntu Setup Script
# Run this on your Android (Termux) or Ubuntu
# Usage: bash setup_termux.sh
# ================================================================

set -e
GREEN='\033[0;32m'
TEAL='\033[0;36m'
AMBER='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo -e "${TEAL}╔══════════════════════════════════════════╗${NC}"
echo -e "${TEAL}║   Dinalibrium \$DLI — Setup Script        ║${NC}"
echo -e "${TEAL}║   Dynamic Equilibrium Asset Analyzer     ║${NC}"
echo -e "${TEAL}╚══════════════════════════════════════════╝${NC}"
echo ""

# Detect environment
if [ -d "/data/data/com.termux" ]; then
  ENV="termux"
  echo -e "${GREEN}Environment: Termux (Android)${NC}"
elif [ "$(uname)" = "Linux" ]; then
  ENV="linux"
  echo -e "${GREEN}Environment: Linux/Ubuntu${NC}"
else
  ENV="other"
  echo -e "${AMBER}Environment: Other (proceeding anyway)${NC}"
fi

# Step 1: Update packages
echo ""
echo -e "${TEAL}[1/5] Updating packages...${NC}"
if [ "$ENV" = "termux" ]; then
  pkg update -y && pkg upgrade -y
  pkg install -y git curl nodejs python
else
  sudo apt update -y 2>/dev/null || apt update -y 2>/dev/null || true
  sudo apt install -y git curl nodejs npm python3 2>/dev/null || true
fi

# Step 2: Clone or check repo
echo ""
echo -e "${TEAL}[2/5] Setting up project...${NC}"
if [ -d "dinalibrium" ]; then
  echo -e "${AMBER}Folder 'dinalibrium' already exists. Pulling latest...${NC}"
  cd dinalibrium && git pull 2>/dev/null || true && cd ..
else
  echo "Clone from your GitHub when ready:"
  echo "  git clone https://github.com/YOUR_USERNAME/dinalibrium.git"
  echo ""
  echo "For now, creating local structure..."
  mkdir -p dinalibrium/src dinalibrium/tests dinalibrium/docs dinalibrium/scripts
fi

# Step 3: Simple HTTP server check
echo ""
echo -e "${TEAL}[3/5] Checking HTTP server availability...${NC}"
if command -v python3 &>/dev/null; then
  echo -e "${GREEN}python3 found — will use for local server${NC}"
  SERVER_CMD="python3 -m http.server 8080"
elif command -v node &>/dev/null; then
  echo -e "${GREEN}node found — will use npx serve${NC}"
  SERVER_CMD="npx serve -p 8080"
else
  echo -e "${AMBER}No server found, installing python...${NC}"
  if [ "$ENV" = "termux" ]; then pkg install -y python; else sudo apt install -y python3; fi
  SERVER_CMD="python3 -m http.server 8080"
fi

# Step 4: Validate test file exists
echo ""
echo -e "${TEAL}[4/5] Checking test files...${NC}"
if [ -f "dinalibrium/tests/test_des_engine.html" ]; then
  echo -e "${GREEN}Test file found: dinalibrium/tests/test_des_engine.html${NC}"
else
  echo -e "${AMBER}Test file not found — make sure to push your files to GitHub first${NC}"
fi

# Step 5: Done — instructions
echo ""
echo -e "${TEAL}[5/5] Setup complete!${NC}"
echo ""
echo -e "${GREEN}══════════════════════════════════════════${NC}"
echo -e "${GREEN}TO RUN LOCALLY:${NC}"
echo ""
echo -e "  1. Enter project:"
echo -e "     ${TEAL}cd dinalibrium/src${NC}"
echo ""
echo -e "  2. Start server:"
echo -e "     ${TEAL}${SERVER_CMD}${NC}"
echo ""
echo -e "  3. Open in browser:"
echo -e "     ${TEAL}http://localhost:8080${NC}"
echo ""
echo -e "  4. Run tests:"
echo -e "     ${TEAL}http://localhost:8080/../tests/test_des_engine.html${NC}"
echo ""
echo -e "${GREEN}TO PUSH TO GITHUB:${NC}"
echo ""
echo -e "  ${TEAL}git init${NC}"
echo -e "  ${TEAL}git add .${NC}"
echo -e "  ${TEAL}git commit -m 'Launch: Dinalibrium \$DLI v1.0'${NC}"
echo -e "  ${TEAL}git branch -M main${NC}"
echo -e "  ${TEAL}git remote add origin https://github.com/YOUR_USERNAME/dinalibrium.git${NC}"
echo -e "  ${TEAL}git push -u origin main${NC}"
echo ""
echo -e "  Then on GitHub: Settings → Pages → Source: main branch /src folder"
echo -e "  Your app goes live at: ${TEAL}https://YOUR_USERNAME.github.io/dinalibrium${NC}"
echo ""
echo -e "${GREEN}══════════════════════════════════════════${NC}"
