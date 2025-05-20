#!/bin/bash

set -e  # Arrêter le script en cas d'erreur

echo "\n=== Étape 1 : Génération du changelog ==="

# Vérifie si standard-version est installé globalement ou localement
if ! command -v standard-version &> /dev/null && [ ! -f node_modules/.bin/standard-version ]; then
  echo "Erreur : standard-version n'est pas installé. Installez-le avec 'npm install --save-dev standard-version'"
  exit 1
fi

# Exécuter standard-version pour créer changelog et incrémenter version
npx standard-version || {
  echo "Erreur lors de l'exécution de standard-version"
  exit 1
}


VERSION=$(node -p "require('./package.json').version")
echo "\nNouvelle version : $VERSION"

echo "\n=== Étape 2 : Création du tag Git v$VERSION ==="
git add .
git commit -m "release: v$VERSION"
git tag "v$VERSION"

echo "\n=== Étape 3 : Push des changements et du tag ==="
git push origin main --tags


echo "\n=== Étape 4 : Déploiement avec Ansible ==="
# Lancer le playbook Ansible
ansible-playbook -i ansible/inventory.ini ansible/deploy.yml

echo "\n✅ Release v$VERSION complétée."
