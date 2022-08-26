# Vytvoření obrazu kontejneru
Před vytvořením kontejneru je nutné, aby existoval obraz serveru, na základě kterého se kontejner udělá. Jde o poměrně 
náročnou akci, kteou by nemusel low-cost VPS (1vCPU + 1 GB RAM) dokončit. Ovbykle to spadlo na nedostaku paměti. Obraz
ale lze sestavit na jakémkoliv jiném počítači, kam si docker nainstalujeme. To bude i tento případ.

## A. na počítači

1. vytvořit obraz NS serveru (použije se Dockerfile přímo z naklonovaného projektu)
   NS naklonujeme do libovolného adresáře 
   (pozn: názvy obrazů volím kvůli přehledu podle aktuální verze Nightscoutu)
   ```
   git clone https://github.com/nightscout/cgm-remote-monitor.git
   cd cgm-remote-monitor
   docker build --no-cache -t nightscout_1425_image . -f ./Dockerfile
   ```
   * dobrá praxe je pojmneovat obraz podle verze Nigtscoutu
   * --no-cache zajistí, že se obraz vytvoří "nanovo, bez ohledu na předchozí akce"

2. vyexportovat hotový obraz z úložiště (defaultně je v lokálním docker úložišti), a rovnou ho zkomprimovat. 
   ```
   docker save nightscout_1425_image | gzip -9 >  nightscout_1425_image.tgz
   ```

3. zkopírovat vytvořeného obrazu na server (WinSCP apod....)

4. Na serveru obraz naimporovat do úložiště, aby ho docker mohl využít. Pokud jsme ho nahráli do /root/docker/images/, pak je to takto:
   ```
   docker load -i /root/docker/images/nightscout_1425_image.tgz
   ```

5. Hotovo, můžeme přejít na vytvoření kontejneru

## B. přímo na severu

Stačí kroky 1 a 4 z předchozí kapitoly. Po vytvoření je obraz automaticky uložen do lokálního úložiště dockeru a hned k dispozici.

# Vytvoření vlastního kontejneru

Konfigurace a skripty napriklad v ``~/docker/nightscout/``

*Alternativně je možno vytvořit kontejner cadvisor, který slouží k sledování spotřeby kontejnerů. Má ale vlastní spotřebu
   prostředků. Je-li VPS low-cost (1vCPU, 1GB RAM), nemusí to server utahnout. Není povinný *

## Vytvořit svoji konfiguraci editací šablony předpisu pro docker-compose (nightscout.yml). Šablony mám pro každý nightscout.
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


## vytvoření kontejneru
```
docker-compose -f {soubor s předpisem} -p {jmeno kontejneru} up -d
```
(vytvori kontejner, a rovnou ho spustí)

např.
```
docker-compose -f ./nightscout-pepicek.yml -p ns_pepicek up -d
```
## kontrola zda běží:
```
root@nightscout:~# docker ps
CONTAINER ID   IMAGE                                      COMMAND                  CREATED         STATUS                PORTS                        NAMES
fc7ec2a4f3fe   nightscout_1425_image:latest               "docker-entrypoint.s…"   6 months ago    Up 7 days             0.0.0.0:1337->1337/tcp       ns_pepicek
d64e6cc59faa   nightscout_1425_image:latest               "docker-entrypoint.s…"   6 months ago    Up 7 days             0.0.0.0:1338->1338/tcp       ns_honzicek
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
