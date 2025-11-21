#!/bin/bash
# Traffic Light Controller - Termux Remote

# ===== KONFIGURASI =====
USERNAME="sijek1995"
REPO="trafic-light-controll3r"
TOKEN="GANTI_DENGAN_GITHUB_TOKEN_KAMU"
BRANCH="main"
# =======================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
STATUS_FILE="$REPO_DIR/light-status.json"

cd "$REPO_DIR"

update_lights() {
    local red=$1
    local yellow=$2
    local green=$3
    
    echo -e "${BLUE}Mengupdate status lampu...${NC}"
    
    # Create status JSON
    cat > "$STATUS_FILE" << EOF
{
    "red": $red,
    "yellow": $yellow,
    "green": $green,
    "last_updated": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
}
EOF
    
    # Git operations
    git add "$STATUS_FILE"
    git commit -m "Update light status: R-$red Y-$yellow G-$green"
    git push "https://$TOKEN@github.com/$USERNAME/$REPO.git" $BRANCH
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Status berhasil diupdate!${NC}"
        echo -e "Merah: $red, Kuning: $yellow, Hijau: $green"
    else
        echo -e "${RED}✗ Gagal push ke GitHub${NC}"
    fi
}

show_menu() {
    echo ""
    echo -e "${BLUE}=== TRAFFIC LIGHT CONTROLLER ===${NC}"
    echo -e "${GREEN}1.${NC} Hijau nyala"
    echo -e "${YELLOW}2.${NC} Kuning nyala" 
    echo -e "${RED}3.${NC} Merah nyala"
    echo -e "${BLUE}4.${NC} Semua mati"
    echo -e "${YELLOW}5.${NC} Kuning berkedip (emergency)"
    echo -e "${GREEN}6.${NC} Normal sequence (Hijau → Kuning → Merah)"
    echo -e "${RED}0.${NC} Keluar"
    echo ""
}

emergency_blink() {
    echo -e "${YELLOW}🚨 Mode emergency - Kuning berkedip${NC}"
    for i in {1..3}; do
        update_lights false true false
        sleep 1
        update_lights false false false
        sleep 1
    done
}

normal_sequence() {
    echo -e "${GREEN}🔄 Menjalankan sequence normal...${NC}"
    update_lights false false true
    sleep 3
    update_lights false true false
    sleep 2
    update_lights true false false
    sleep 3
    update_lights false false false
}

while true; do
    show_menu
    read -p "Pilih mode (0-6): " choice
    
    case $choice in
        1) update_lights false false true ;;
        2) update_lights false true false ;;
        3) update_lights true false false ;;
        4) update_lights false false false ;;
        5) emergency_blink ;;
        6) normal_sequence ;;
        0) echo "Selamat tinggal! 👋"; exit 0 ;;
        *) echo -e "${RED}Pilihan tidak valid!${NC}" ;;
    esac
    
    read -p "Tekan Enter untuk melanjutkan..."
    clear
done