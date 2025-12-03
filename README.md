<div style="text-align: center; margin-top: 100px;">

  <!-- 🖼️ Logo principal au centre -->
<img width="1277" height="619" alt="image" src="https://github.com/user-attachments/assets/1b8bdf40-efad-4dcb-9222-777402a4f0a8" />


  <!-- 🏫 Titre principal -->
  <h1 style="font-size: 38px; margin-top: 40px;">TP B2 - BILAN</h1>
	<hr style="width: 50%; margin: 20px auto;">

  <!-- 🧰 Sous-titre -->
  <h2 style="font-size: 28px; margin-top: 10px;">DOCKER</h2>


  <!-- ✍️ Auteur et infos -->
  <p style="font-size: 20px; margin-top: 40px;">
    Réalisé par : <strong>Théo C.</strong><br>
    Formation : BTS SIO — 2ᵉ année<br>
    Date : 03/12/2025
  </p>
</div>



<div style="page-break-after: always;"></div>

---

##  Sommaire

1. [Contexte et Objectifs]
    
2. [Architecture de la solution]
    
3. [Prérequis et Environnement]
    
4. [Installation Automatisée]
    
5. [Déploiement des Services]
    
6. [Difficultés rencontrées et Résolutions]
    
7. [Vérification et Accès]
    
8. [Explications YAML et SCRIPT]
---

##  Contexte et Objectifs

- Mise en place d'un environnement virtualisé sous **Proxmox** .
    
- Installation et configuration du moteur de conteneurisation **Docker** via script .
    
- Déploiement d'une architecture multi-services (Web & Monitoring) avec **Docker Compose** .
    
- Gestion de versions et documentation via **Git** .
    

---

##  Architecture de la solution

L'infrastructure repose sur une machine virtuelle Linux unique hébergeant deux stacks applicatives isolées :

1. **Web (Wordpress)** :
    
    - Frontend : Wordpress (Port hôte : `8080`) .
        
    - Backend : MySQL 5.7.
        
2. **Supervision (Zabbix)** :
    
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
        
    - **Stockage** : 20 Go.
        

---

##  Installation Automatisée

Pour garantir la reproductibilité de l'environnement, l'installation de Docker est gérée par un script Bash (`script.sh`) .

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

**Accès à Wordpress :**
<img width="1919" height="749" alt="image" src="https://github.com/user-attachments/assets/04b043fb-3129-4aa3-b36d-2eed0388d650" />

**Accès à Zabbix :**
<img width="1918" height="781" alt="image" src="https://github.com/user-attachments/assets/3c66643e-5eb3-4a59-8ad6-290e060d5b7f" />

## Explication
### 1. Explication Script.sh

| **Ligne de commande (Extraits)**  | **Explication**                                                                   |
| --------------------------------- | ---------------------------------------------------------------------------------------- |
| `set -e`                          | Arrête immédiatement le script si une commande échoue.                                   |
| `set -x`                          | Affiche chaque commande dans le terminal avant de l'exécuter.                            |
| `sudo apt update && upgrade -y`   | Met à jour la liste des logiciels et installe les dernières versions.                    |
| `sudo apt install ... curl gnupg` | Installe les outils pour télécharger (`curl`) et gérer la sécurité (`gnupg`).            |
| `curl ...                         | sudo gpg --dearmor ...`                                                                  |
| `echo "deb ... signed-by..."`     | Ajoute l'adresse officielle de Docker à la liste des "magasins" d'applications de Linux. |
| `sudo apt install docker-ce ...`  | Installe le moteur Docker (`ce`), la commande client (`cli`) et le plugin Compose.       |
| `systemctl start docker`          | Démarre Docker.                                                |
| `systemctl enable docker`         | Programme Docker pour qu'il s'allume tout seul au redémarrage du PC.                     |
| `usermod -aG docker $USER`        | Ajoute ton utilisateur au groupe "docker".                                           |
| `docker --version`                | Affiche la version installée.                                                            |

### 2. Explication docker_compose.yml

| **Instruction / Clé**        | **Explication **                                                                                                                                              |
| ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `version: '3.8'`             | Indique la version de la syntaxe Docker Compose utilisée.                                                                                                     |
| `services:`                  | Début de la liste des "machines" (conteneurs) que tu vas créer.                                                                                               |
| `image: mysql:5.7`           | L'image à télécharger depuis le Docker Hub (le magasin d'applis).                                                                                             |
| `volumes:` (dans un service) | `- db_wp_data:/var/lib/mysql`<br><br>  <br><br>Relie un dossier virtuel (à gauche) au dossier de stockage de la base de données dans le conteneur (à droite). |
| `restart: always`            | Si le conteneur plante ou si le serveur redémarre, Docker le relance automatiquement.                                                                         |
| `environment:`               | Liste des variables de configuration (Mots de passe, nom des bases, utilisateurs).                                                                            |
| `depends_on:`                | `- db_wp`<br><br>  <br><br>Dit à Docker : "Attends que la base de données (`db_wp`) soit lancée avant de lancer WordPress".                                   |
| `ports:`                     | `- "8080:80"`<br><br>  <br><br>**Gauche** : Port de ta machine réelle (Hôte).<br><br>  <br><br>**Droite** : Port interne du conteneur.                        |
| `volumes:` (à la fin)        | Déclare les volumes nommés utilisés plus haut (`db_wp_data`, etc.) pour qu'ils soient gérés par Docker.                                                       |

