# Systém
Nebudu zde uvádět konfiguraci a nastavení krok za krokem. Základní instalace po objednání dostačuje. VPS Protože jde o server ve vlastní správě, měl by člověk něco málo znát. 
Takže základy typu instace balíčků, editace souborů, restart služeb, kde najít logy nebudu popisovat. Kromě nastavení firewallu (kvůli omezení přístupu k systému z důvěryhodných IP adres) není třeba žádné větší instalace. Doporučuji nastavit automatické upgrady systému - v Debianu jde o unattended-upgrades

Stačí doinstalovat docker, například podle [návodu][https://docs.docker.com/engine/install/debian/]. 
Nejdřív se nainstalují potřebné balíky, gpg klíč a nakonec repozitář. Před a po akci se provede aktualizace seznamu balíčků

```
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF
sudo apt update
```
Další krok je instalce docker balíčků: 
```
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```
Nakonec se zkontroluje, zda služba automaticky naběhla ```sudo systemctl status docker```. Pokud ne, nastartuje se ```sudo systemctl start docker```
