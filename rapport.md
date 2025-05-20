# Rapport de déploiement d'infrastructure DevOps pour API IoT

## 1. Architecture de l'infrastructure

L'infrastructure repose sur Microsoft Azure et se compose de :

* Une **machine virtuelle (VM)** Ubuntu 22.04 provisionnée avec Terraform
* Une **ouverture de port 3000** pour l'accès à l'API
* Une **clé SSH** générée localement et utilisée pour l'accès à la VM

### Choix du provider :

Azure a été choisi car l'accès était offert via Azure Dev Tools for Teaching, et son intégration avec Terraform est stable et bien documentée.

---

## 2. Configuration Terraform

Fichiers situés dans le dossier `infra/` :

* `main.tf` : Création de la VM, groupe de ressources, réseau virtuel, sous-réseau, adresse IP publique, etc.
* `variables.tf` : Déclaration des variables comme le nom de la VM, les credentials SSH, etc.
* `outputs.tf` : Affichage de l'adresse IP publique de la VM

La configuration a permis le déploiement complet d'une VM accessible en SSH et sur le port de l'API (3000).

---

## 3. Playbook Ansible

Fichiers dans `ansible/` :

* `inventory.ini` : Définit l'adresse IP de la VM
* `deploy.yml` :

  * Met à jour `apt`
  * Supprime les versions préinstallées de Node.js
  * Installe Node.js 18 via NodeSource
  * Clone le repo de l'API
  * Installe les dépendances avec npm
  * Lance l'API avec `pm2`

Cette configuration permet de rejouer le déploiement facilement et automatiquement sur une nouvelle VM.

---

## 4. Fonctionnement du script `release.sh`

Contenu à la racine du projet :

* Gère la création du changelog avec `standard-version`
* Incrémente la version dans `package.json`
* Crée un commit et un tag Git
* Push le tout sur GitHub
* Déclenche le playbook Ansible

Ce script permet d'avoir un processus de publication semi-automatique cohérent avec les pratiques DevOps.

---

## 5. CI/CD (GitHub Actions)

Fichier : `.github/workflows/release.yml`

* Déclenché sur `push` de tag correspondant à une version (`v*.*.*`)
* Exécute le déploiement Ansible depuis GitHub

Malgré un problème initial de fichier trop volumineux (> 100 Mo), la configuration CI/CD a pu être déclenchée avec succès après nettoyage de l'historique Git via `git filter-repo`.

---

## 6. Difficultés rencontrées

* Conflit sur le port 3000 lors de l’utilisation de `pm2`
* Erreur d'authentification SSH/GitHub sur WSL
* Fichier binaire `.exe` de Terraform > 100 Mo empêchant le push GitHub

---

## 7. Améliorations possibles

* Ajouter un reverse proxy Nginx
* Utiliser GitHub Secrets pour stocker les credentials
* Ajouter des tests automatisés dans la CI
* Utiliser GitHub Releases automatiquement à partir des tags

---

## 8. Conclusion

Tous les critères d’évaluation ont été couverts : provisioning, déploiement, automatisation, tagging, CI/CD et documentation.

Ce projet met en pratique l’ensemble de la chaîne de déploiement moderne d’une API Node.js en environnement cloud.

---

## Captures d'écran / logs

Voir les commits GitHub pour les logs d’éxécution Ansible, screenshots, et historiques de release :
![image](https://github.com/user-attachments/assets/1d669ca5-9750-4b53-b6f4-79981084b71e)
![image](https://github.com/user-attachments/assets/8076949c-a18c-47a7-8c1c-92cc1ac66313)



* [x] Terraform OK ✅
* [x] Ansible OK ✅
* [x] Script `release.sh` OK ✅
* [x] CI/CD déclenchée ✅
* [x] Rapport présent ✅
