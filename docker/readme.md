# Vytvoření obrazu kontejneru
Před vytvořením kontejneru je nutné, aby existoval obraz serveru, na základě kterého se kontejner udělá. Jde o poměrně 
náročnou akci, kteou by nemusel low-cost VPS (1vCPU + 1 GB RAM) dokončit. Ovbykle to spadlo na nedostaku paměti. Obraz
ale lze sestavit na jakémkoliv jiném počítači, kam si docker nainstalujeme. To bude i tento případ.

1. instalace dockeru na počítači

2. vytvoření obrazu serveru (Dockerfile je konfigurace, která je v aktuální adresáři), 
   docker build --no-cache -t nightscout_1422_image . -f ./Dockerfile
   * je dobrá praxe označovat soubory verzí Nigtscoutu
   * --no-cache zajistí, že se obraz vytvoří "nanovo, bez ohledu na předchozí akce"

3. Pokud to děláme na počítači (nebo jiném serveru), je třeba obraz vyexportovat (defaultně je v lokálním docker úložišti)
   Dobrá praxe je ho rovnou zkomprimovat.
   docker save nightscout_1422_image | gzip -9 >  nightscout_1422_image.tgz


3. zkopírování vytvořeného obrazu na server (WinSCP apod....)

4. Na serveru se obraz naimportuje. Pokud jsme ho nahráli do /root/docker/images/, pak je to takto:
   docker load -i /root/docker/images/nightscout_1422_image.tgz

5. Hotovo, můžeme přejít na vytvření kontejneru


# Vytvoření vlastního kontejneru

Konfigurace a skripty napriklad v ~/docker/nightscout/

0. Alternativně je možno vytvořit kontejner cadvisor, který slouží k sledování spotřeby kontejnerů. Má ale vlastní spotřebu
   prostředků. Je-li VPS low-cost (1vCPU, 1GB RAM), nemusí to server utahnout. Není povinný 

1. Vytvořit svoji konfiguraci editací šablony předpisu pro docker-compose (nightscout.yml). Šablony mám pro každý nightscout.
Je nutné změnit:
* první řádek: jméno předpisu
* image: podle jména obrazu serveru, ktery jsme vytvořili dříve
* hostname: URL, na které budeme k nightscoutu přistupovat
* mem_limit: doporučuji nastvait - vyhnete se přetížení serveru (300 MB je dostačující). Možno experimentovat
* enviroment: 
  API_SECRET + MONGO_CONNECTION + BASE_URL
  PORT - stejný jako v sekci ports
  moduly v ENABLE podle potřeby (jednotlivé moduly odděluje %20 )
* ports: 1337:1337 (každý kontejner musí mít unikátní - tzn. další třeba 1338:1338)


2. vytvoření kontejneru
```
docker-compose -f {soubor s předpisem} -p {jmeno kontejneru} up -d
```
(vytvori kontejner, a rovnou ho spustí)

např.
```
docker-compose -f ./nightscout-pepicek.yml -p ns_pepicek up -d
```
3. kontrola zda běží:
```
root@nightscout:~# docker ps
CONTAINER ID   IMAGE                                      COMMAND                  CREATED         STATUS                PORTS                        NAMES
fc7ec2a4f3fe   nightscout_1422_image:latest               "docker-entrypoint.s…"   6 months ago    Up 7 days             0.0.0.0:1337->1337/tcp       ns_pepicek
d64e6cc59faa   nightscout_1422_image:latest               "docker-entrypoint.s…"   6 months ago    Up 7 days             0.0.0.0:1338->1338/tcp       ns_honzicek
4c2e9836edee   gcr.io/google-containers/cadvisor:latest   "/usr/bin/cadvisor -…"   14 months ago   Up 7 days (healthy)   0.0.0.0:8080->8080/tcp       cadvisor
```
kontejnery spuštěné, běží.
```
root@nightscout:~# netstat -lnpt | grep docker
tcp6       0      0 :::1337                 :::*                    LISTEN      20343/docker-proxy  
tcp6       0      0 :::1338                 :::*                    LISTEN      20280/docker-proxy  
tcp6       0      0 :::8080                 :::*                    LISTEN      20252/docker-proxy  
```
docker naslouchá na portech nastavených v předpisu (1337....)
