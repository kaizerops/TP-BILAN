<!-- 🌟 PAGE DE PRÉSENTATION -->
<div style="text-align: center; margin-top: 100px;">

  <!-- 🖼️ Logo principal au centre -->
<img width="1277" height="619" alt="image" src="https://github.com/user-attachments/assets/1b8bdf40-efad-4dcb-9222-777402a4f0a8" />


  <!-- 🏫 Titre principal -->
  <h1 style="font-size: 38px; margin-top: 40px;">TP B2 - BILAN</h1>
	<hr style="width: 50%; margin: 20px auto; border: 1px solid #000;">

  <!-- 🧰 Sous-titre -->
  <h2 style="font-size: 28px; margin-top: 10px;">DOCKER</h2>


  <!-- ✍️ Auteur et infos -->
  <p style="font-size: 20px; margin-top: 40px;">
    Réalisé par : <strong>Théo C.</strong><br>
    Formation : BTS SIO — 2ᵉ année<br>
    Date : 03/12/2025
  </p>
</div>

<!-- 🖼️ Logo en bas à droite -->









<!-- ✂️ Saut de page pour le PDF -->
<div style="page-break-after: always;"></div>

🐳 TP Bilan Intermédiaire SISR - Infrastructure Dockerisée

##  Table des matières

1. [Contexte et Objectifs](https://www.google.com/search?q=%23-contexte-et-objectifs)
    
2. [Architecture de la solution](https://www.google.com/search?q=%23-architecture-de-la-solution)
    
3. [Prérequis et Environnement](https://www.google.com/search?q=%23-pr%C3%A9requis-et-environnement)
    
4. [Installation Automatisée](https://www.google.com/search?q=%23-installation-automatis%C3%A9e)
    
5. [Déploiement des Services](https://www.google.com/search?q=%23-d%C3%A9ploiement-des-services)
    
6. [Difficultés rencontrées et Résolutions](https://www.google.com/search?q=%23-difficult%C3%A9s-rencontr%C3%A9es-et-r%C3%A9solutions)
    
7. [Vérification et Accès](https://www.google.com/search?q=%23-v%C3%A9rification-et-acc%C3%A8s)
    

---

##  Contexte et Objectifs

Ce projet s'inscrit dans le cadre du bilan intermédiaire du BTS SIO (Option SISR) . Il vise à démontrer la maîtrise des compétences suivantes :

- Mise en place d'un environnement virtualisé sous **Proxmox** .
    
- Installation et configuration du moteur de conteneurisation **Docker** via script .
    
- Déploiement d'une architecture multi-services (Web & Monitoring) avec **Docker Compose** .
    
- Gestion de versions et documentation via **Git** .
    

---

##  Architecture de la solution

L'infrastructure repose sur une machine virtuelle Linux unique hébergeant deux stacks applicatives isolées :

1. **Stack Web (Wordpress)** :
    
    - Frontend : Wordpress (Port hôte : `8080`) .
        
    - Backend : MySQL 5.7.
        
2. **Stack Supervision (Zabbix)** :
    
    - Frontend : Zabbix Web Nginx (Port hôte : `8081`) .
        
    - Serveur : Zabbix Server.
        
    - Backend : PostgreSQL 13.
        

---

##  Prérequis et Environnement

- **Hyperviseur** : Proxmox VE.
    
- **Système d'exploitation** : Debian 12 (Bookworm) - Installation "Netinst" (Minimaliste) .
    
- **Ressources allouées** :
    
    - CPU : 2 vCores.
        
    - RAM : 4 Go.
        
    - **Stockage** : 20 Go (Recommandation suite aux tests de charge, voir section "Difficultés").
        

---

##  Installation Automatisée

Pour garantir la reproductibilité de l'environnement, l'installation de Docker est gérée par un script Bash (`install_docker.sh`) .

### Fonctionnement du script

Ce script effectue les actions suivantes séquentiellement :

1. Mise à jour des dépôts système (`apt update`).
    
2. Installation des dépendances nécessaires (`ca-certificates`, `curl`, `gnupg`).
    
3. Importation sécurisée de la clé GPG officielle de Docker.
    
4. Configuration du dépôt stable.
    
5. Installation de `docker-ce`, `docker-ce-cli`, `containerd.io` et du plugin `docker-compose`.
    
6. Configuration des droits pour l'utilisateur courant (évite l'usage de `sudo`).
    

### Utilisation

Bash

```
# 1. Cloner le dépôt
git clone https://github.com/kaizerops/TP-BILAN.git 
cd NOM_DU_REPO

# 2. Rendre le script exécutable
chmod +x install_docker.sh

# 3. Lancer l'installation
./install_docker.sh

# ⚠️ IMPORTANT : Se déconnecter et reconnecter pour appliquer les groupes utilisateurs.
```

---

##  Déploiement des Services

L'orchestration des conteneurs est définie dans le fichier `docker-compose.yml`.

### Configuration (Extrait)

Le fichier déclare les services, les réseaux internes et les volumes persistants pour les bases de données.

YAML

```
version: '3.8'

services:
  # --- WORDPRESS ---
  wordpress:
    image: wordpress:latest
    ports:
      - "8080:80"  # Mapping port 8080 (VM) -> 80 (Conteneur) 
    depends_on:
      - db_wp
    # ... (variables d'environnement DB)

  # --- ZABBIX ---
  zabbix-web:
    image: zabbix/zabbix-web-nginx-pgsql:latest
    ports:
      - "8081:8080" # Mapping port 8081 (VM) -> 8080 (Conteneur) 
    # ... (variables d'environnement Zabbix)
```

### Lancement de la stack

Bash

```
docker compose up -d
```

_L'option `-d` permet de lancer les processus en arrière-plan (detached mode)._

---


## Vérification et Accès

### 1. État des conteneurs

Pour vérifier que tous les services sont opérationnels :

Bash

```
docker compose ps
```

_Le statut doit être `Up` pour les 5 conteneurs._

### 2. Accès Web

Les services sont accessibles depuis le navigateur via l'adresse IP de la VM :

| **Service**   | **URL**                   | **Identifiants par défaut**        |
| ------------- | ------------------------- | ---------------------------------- |
| **Wordpress** | `http://IP_DE_LA_VM:8080` | _À définir à l'installation_       |
| **Zabbix**    | `http://IP_DE_LA_VM:8081` | **User:** Admin / **Pass:** zabbix |

---

### Auteur

[Théo C.]

Étudiant BTS SIO - Option SISR
