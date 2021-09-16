# Systém
Nebudu zde uvádět konfiguraci a nastavení krok za krokem. Protože jde o server ve vlastní správě, měl by člověk něco málo znát. 
Takže základy typu instace balíčků, editace souborů, restart služeb, kde najít logy nebudu popisovat. 

Nightscout je spouštěn v docker kontejneru (viz návod [docker](/docker) ). Není doporučováno, aby i databáze běžela v kontejneru. Databázi [mongodb](/mongodb) mám tedy nainstalovanou mimo kontejnery přímo na serveru. Aby mohly kontejnery komunikovat s databází na localhostu, je třeba nastavit alias k loopback rozhraní.

```
auto lo:1
iface lo:1 inet static
    address 10.10.10.1
    netmask 255.255.0.0
```
Upravený soubor s konfigurací sítě ``interfaces`` je v seznamu souborů
