#!/bin/bash

# Arrêter le script en cas d'erreur
set -e
# Mode debug (optionnel, utile pour voir ce qui se passe)
set -x

echo "--- Mise à jour du système ---"
# Mise à jour des dépôts 
sudo apt update && sudo apt upgrade -y

echo "--- Installation des dépendances ---"
# ca-certificates et gnupg sont cruciaux pour la gestion des clés sous Debian
sudo apt install -y ca-certificates curl gnupg

echo "--- Configuration de la clé GPG Docker ---"
# Création du dossier pour les clés si inexistant
sudo install -m 0755 -d /etc/apt/keyrings
# Téléchargement de la clé et conversion en format compatible
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
# Ajustement des droits sur la clé
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "--- Ajout du dépôt Docker stable ---"
# Détection automatique de l'architecture et du nom de code (bookworm)
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "--- Installation de Docker et du plugin Compose ---"
sudo apt update
# Installation du moteur, du CLI, de containerd et des plugins (Buildx et Compose)
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "--- Démarrage du service ---"
sudo systemctl start docker
sudo systemctl enable docker

echo "--- Ajout de l'utilisateur au groupe Docker ---"
# Permet de lancer docker sans 'sudo'
sudo usermod -aG docker $USER

echo "--- Vérification des versions ---"
docker --version
docker compose version

echo "--- Installation terminée ! ---"
echo "Veuillez vous déconnecter et vous reconnecter pour que les droits de groupe soient pris en compte."
set +x