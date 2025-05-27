#!/bin/bash
# Script de monitoring DevOps
# Auteur: Moussa Gaye

# Couleurs pour output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonction d'affichage
print_status() {
    if [ $2 -eq 0 ]; then
        echo -e "${GREEN}✅ $1${NC}"
    else
        echo -e "${RED}❌ $1${NC}"
    fi
}

echo -e "${BLUE}🔍 DevOps Health Check - $(date)${NC}"
echo "=================================="

# Check système
echo -e "\n${YELLOW}📊 SYSTÈME${NC}"
uptime
free -h | grep Mem
df -h / | tail -1

# Check services critiques
echo -e "\n${YELLOW}🔧 SERVICES${NC}"
systemctl is-active nginx >/dev/null 2>&1
print_status "Nginx" $?

systemctl is-active ufw >/dev/null 2>&1
print_status "Firewall UFW" $?

systemctl is-active docker >/dev/null 2>&1
print_status "Docker" $?

# Check réseau
echo -e "\n${YELLOW}🌐 RÉSEAU${NC}"
ping -c 1 google.com >/dev/null 2>&1
print_status "Connectivité Internet" $?

curl -s http://localhost >/dev/null 2>&1
print_status "Nginx localhost" $?

# Check ports ouverts
echo -e "\n${YELLOW}🔌 PORTS OUVERTS${NC}"
sudo netstat -tuln | grep :80 >/dev/null && echo -e "${GREEN}✅ Port 80 (HTTP)${NC}" || echo -e "${RED}❌ Port 80 fermé${NC}"
sudo netstat -tuln | grep :22 >/dev/null && echo -e "${GREEN}✅ Port 22 (SSH)${NC}" || echo -e "${RED}❌ Port 22 fermé${NC}"

# Check espace disque
echo -e "\n${YELLOW}💾 ESPACE DISQUE${NC}"
DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
if [ $DISK_USAGE -gt 80 ]; then
    echo -e "${RED}⚠️  Espace disque critique: ${DISK_USAGE}%${NC}"
elif [ $DISK_USAGE -gt 60 ]; then
    echo -e "${YELLOW}⚠️  Espace disque attention: ${DISK_USAGE}%${NC}"
else
    echo -e "${GREEN}✅ Espace disque OK: ${DISK_USAGE}%${NC}"
fi

echo -e "\n${BLUE}=================================="
echo -e "🚀 Health Check terminé!${NC}"
