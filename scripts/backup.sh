#!/bin/bash
# Script de backup automatique DevOps
# Auteur: Moussa Gaye

# Variables
BACKUP_DIR="/home/mosis/backups"
DATE=$(date +%Y%m%d_%H%M%S)
HOSTNAME=$(hostname)

# Créer dossier backup si n'existe pas
mkdir -p $BACKUP_DIR

# Fonction de log
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a $BACKUP_DIR/backup.log
}

log "🚀 Début backup système - $HOSTNAME"

# Backup configurations importantes
log "📁 Backup configurations..."
sudo tar -czf $BACKUP_DIR/config_$DATE.tar.gz \
    /etc/nginx/sites-available \
    /etc/ufw \
    /home/mosis/.ssh \
    /home/mosis/.gitconfig \
    2>/dev/null

# Backup projets DevOps
log "💻 Backup projets DevOps..."
tar -czf $BACKUP_DIR/devops_projects_$DATE.tar.gz \
    /home/mosis/devops-projects/ \
    2>/dev/null

# Nettoyage anciens backups (garde 7 derniers)
log "🧹 Nettoyage anciens backups..."
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete

log "✅ Backup terminé - Fichiers dans $BACKUP_DIR"
ls -lh $BACKUP_DIR/*.tar.gz 2>/dev/null | tail -5
