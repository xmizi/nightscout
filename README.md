# Stručný postup pro vytvoření [Nightscout](https://www.nightscout.info) serveru pro osobní použití

# Popis serveru
* Linuxový server založený na distribuci debian
* Nightscout instance jsou provozované v Docker kontejnerech
* Databáze MongoDB není v dockeru
* Přístup do kontejneru je zajišován nginxem, SSL certifikáty pro https LetsEncrypt

# Požadavky
1. **Server**: pro provoz 2-3 NS instancí postačuje virtuální server 1vCPU, 1 GB RAM. Disk alespoň 20 GB (záleží, jak se promazávají data v mongodb)
2. **Programové vybavení**
   * distribuce Debian (lze použít ubuntu, centos... - tady jsou ale trochu jiné cestu a způsob instalace)
   * Docker
   * Nginx
   * MongoDB
   * LetsEncrypt 
 3. **Doména**: pro přístup na nightscout je potřeba [registrovaná doména](https://www.forpsi.com/domain/). Bezpodmínečně nemusí být vlastní, pokud vám někdo umožní nasměrovat doménu 3. řádu (např ns-pepicek.mojedomena.cz). Jde o nastavení A záznamu v DNS

# Postup instalace a konfigurace
V každé složce je konfigirační soubor, který je nutné upravit podle svého

# License
[![Creative Commons: Uveďte původ-Neužívejte komerčně 4.0 Mezinárodní License](https://i.creativecommons.org/l/by-nc/4.0/88x31.png "Creative Commons: Uveďte původ-Neužívejte komerčně 4.0 Mezinárodní License")](http://creativecommons.org/licenses/by-nc/4.0/)
