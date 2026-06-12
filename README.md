# Jak vytvořit [Nightscout](https://www.nightscout.info) server pro osobní použití

# Popis serveru
* Linuxový server založený na distribuci debian
* Nightscout instance jsou provozované v Docker kontejnerech
* Databáze MongoDB je v dockeru
* Řízení přístupu do kontejneru je zajišováno přes proxy traefik
* Instalace a správa kontejnerů je přes grafické rozhraní Portainer (pro soukromé použítí je k dispozici i bussiness verze)
  
# Požadavky
1. **Server**: pro provoz 2-3 NS instancí postačuje virtuální server 1vCPU, 1 GB RAM. Disk alespoň 20 GB (záleží, jak se promazávají data v mongodb). Aktuálně provozuji 2 Nightscout instance + monitoring na VPS 1vCPU/1GB RAM/20GB u [Forpsi](https://www.forpsicloud.cz/vps.aspx) varianta VPS O1I1 s IPv4 za 62 Kč (stav 06.2026) bez jakýchkoliv problémů s výkonem (do aktivního nightscoutu se zapisuje přes AAPS, takže zápisy jsou četnější, než jen od senzoru - Dexcom, Libre).
2. **Programové vybavení**
   * distribuce Debian (lze použít ubuntu, centos... - tady jsou ale trochu jiné cestu a způsob instalace)
   * Docker

 3. **Doména**: pro přístup na nightscout je nutné [doménové jméno](https://www.forpsi.com/domain/). Obejdete se ale i bez registrace (a tudíž ročního poplatku za její udržování). Stačí mít kamaráda (kolegu) který má vlastní doménu a umožní vám na server nasměrovat subdoménu (např ns-pepicek.mojedomena.cz). Jde o nastavení A záznamu v DNS na IP adresu serveru. 

# Postup instalace a konfigurace
Ve složkách v tomto návodu (docker, system, mongodb) najdete konfigurační soubory nebo pomocné skripty (je nutné upravit podle svého), stručný postup co dělat

Instalace probíhá v těchto krocích:
1. **Nastavení systému**: ve složce [system](system) je připraven kompletní instalační skript
2. **Vytvoření kontejnerů***: podle předpisu použitelného v Portaineru: soubory [mongodb.yaml](docker/mongodb.yaml), [nightscout.yaml](docker/nightscout.yaml), [traefik.yaml](docker/traefik.yaml). Postup je v [docker/README.md](docker/README.md)
3. **Vytvoření mongo databáze**: postup ve složce mongodb

# Zabezpečení serveru
* Nightscout má své vlastní ochrany (API_KEY + přístupové tokeny)
* Zabezpečení serveru (firewall) není ovsahem tohoto návodu 

# License
[![Creative Commons: Uveďte původ-Neužívejte komerčně 4.0 Mezinárodní License](https://i.creativecommons.org/l/by-nc/4.0/88x31.png "Creative Commons: Uveďte původ-Neužívejte komerčně 4.0 Mezinárodní License")](http://creativecommons.org/licenses/by-nc/4.0/)
