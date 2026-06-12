#!/bin/bash

set -euo pipefail

echo "
*******************************************************
*  Instalacni skript pro pripravu Nightscout serveru  *
*******************************************************

-> instalace zakladnich baliku (ca-certificates curl gnupg lsb-release)
-> pridani repozitare docker
-> nainstaluje docker a spusti jeho sluzbu
-> nainstaluje Portainer

Pozn: skript funguje pro:
- root prihlaseni
- bezneho uzivatele se sudo pravy

*******************************************************
"

# Detekce opravneni
if [ "$(id -u)" -eq 0 ]; then
    SUDO=""
    echo "Bezim jako root - sudo neni potreba."
else
    if command -v sudo >/dev/null 2>&1; then
        SUDO="sudo"
        echo "Bezim jako bezny uzivatel - bude pouzito sudo."
    else
        echo "Chyba: nejste root a prikaz sudo neni k dispozici."
        echo "Prihlaste se jako root nebo pouzijte uzivatele se sudo pravy."
        exit 1
    fi
fi

echo
echo -n "Budeme pokracovat? [a/n]: "
read -r REAKCE

case "$REAKCE" in
    a|A)
        echo "OK, pokracujeme......"

        $SUDO apt update
        $SUDO apt -y install ca-certificates curl gnupg lsb-release

        $SUDO install -m 0755 -d /etc/apt/keyrings
        $SUDO curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
        $SUDO chmod a+r /etc/apt/keyrings/docker.asc

        $SUDO tee /etc/apt/sources.list.d/docker.sources > /dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

        $SUDO mkdir -p /opt/docker/mongodb
        $SUDO tee /opt/docker/add-mongo-user.js > /dev/null <<EOF
db = db.getSiblingDB("admin");
db.auth("admin", "XXXXXXXXX");

db = db.getSiblingDB("nightscoutdb");
db.createUser({
  user: "nsuser",
  pwd: "MOJE-TAJNE-HESLO-PRO-DB",
  roles: [{ role: "readWrite", db: "nightscoutdb" }]
});
EOF
        $SUDO apt update
        $SUDO apt -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        $SUDO systemctl enable --now docker

        echo "Instaluji Portainer"
        $SUDO docker network create --driver bridge web
        $SUDO docker volume create portainer_data

        $SUDO docker run -d \
            -p 8000:8000 \
            -p 9443:9443 \
            --name portainer \
            --restart=always \
            --network web \
            -v /var/run/docker.sock:/var/run/docker.sock \
            -v portainer_data:/data \
            portainer/portainer-ce:lts

        echo
        echo "*******************************************************"
        echo "* Hotovo                                              *"
        echo "*******************************************************"
        echo
        echo "Docker i Portainer byly nainstalovany."
        echo "Portainer otevres v prohlizeci na adrese:"
        echo "https://IP_SERVERU:9443"
        echo
        echo "Poznamka:"
        echo "- Port 9443 = doporucene HTTPS rozhrani Portaineru"
        echo "- Port 8000 = edge agent tunnel"
        ;;
    *)
        echo "OK, koncime....."
        exit 0
        ;;
esac
