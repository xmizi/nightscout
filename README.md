# Jak vytvořit Nightscout server pro osobní použití

# Popis serveru
* Linuxový server založený na distribuci debian
* Nightscout instance jsou provozované v Docker kontejnerech
* Databáze MongoDB je v dockeru
* Řízení přístupu do kontejneru je zajišováno přes proxy traefik
* Instalace a správa kontejnerů je přes grafické rozhraní Portainer (pro soukromé použítí je k dispozici i bussiness verze)
  
# Požadavky
1. **Server**: pro provoz 2-3 NS instancí postačuje virtuální server 1vCPU, 1 GB RAM. Disk alespoň 20 GB (záleží, jak se promazávají data v mongodb). Aktuálně provozuji 2 Nightscout instance + monitoring na VPS 1vCPU/1GB RAM/20GB u [Forpsi](https://www.forpsicloud.cz/vps.aspx) varianta VPS O1I1 s IPv4 za 62 Kč (stav 06.2026) bez jakýchkoliv problémů s výkonem (do aktivního nightscoutu se zapisuje přes AAPS, takže zápisy jsou četnější, než jen od senzoru - Dexcom, Libre).
2. **Programové vybavení**
   * distribuce Debian (lze použít i ubuntu), Distribued založené na RedfHat (AlmaLinux, RockyLinux - tady jsou ale trochu jiné cesty a způsob instalace a nelze použít instalační skript)
   * Docker

 3. **Doména**: pro přístup na nightscout je nutné [doménové jméno](https://www.forpsi.com/domain/). Obejdete se i bez její registrace (a tudíž ročního poplatku za její udržování). Stačí mít kamaráda (kolegu) který má vlastní doménu, a umožní vám na server nasměrovat subdoménu (např. ns-pepicek.mojedomena.cz). Jde o nastavení A záznamu v DNS na IP adresu serveru. **POZOR!! Před instalací už MUSÍ být dména nasměrována na váš server (jinak se nevystaví certifikát)**

# Zabezpečení serveru
* Nightscout má své vlastní ochrany (API_KEY + přístupové tokeny)
* Zabezpečení serveru (firewall) není osahem tohoto návodu, ale důrazně doporučuji omezit přístup do Portaineru a SSH (minimálně přihlašování pouze SSH klíčem a ne heslem).
* Pravideloné aktualzaice zajišťují vyšší bezpečnost

# Instalace a konfigurace

## Systém

Nebudu zde uvádět konfiguraci a nastavení krok za krokem. Základní instalace po objednání VPS dostačuje. Protože jde o server ve vlastní správě, měl by člověk něco málo znát - základy jako instace balíčků, editace souborů, restart služeb. Kromě nastavení firewallu (kvůli omezení přístupu k systému z důvěryhodných IP adres) není třeba žádná větší úprava. Doporučuji nastavit automatické upgrady systému - v Debianu jde o unattended-upgrades

Připravil jsem instalační skript [instalace-systemu.sh](instalace-systemu.sh). Stačí ho nahrát na server a spustit jako root. Pokud se přihlašujete jako běžný uživatel a systémové příkazy spouštíte přes sudo, zvolí skript použítí sudo. Skript nainstaluje potřebné balíčky a Portainer. Po ukončení instalace doporučuji server rebootovat. Po rebootu se pokračuje vytvořením docker kontejnerů pro webovou proxy (traefik), nightscout a jeho mongo databázi.

## Portainer a kontejnery

Jde o grafické rozhraní (GUI) pro správu kontejnerů v dockeru (samozřejmě nejen pro Docker, ale podrobné využítí není náplní tohoto návodu). Podrobné info najdete na domovské stránce projektu https://www.portainer.io.

### Verze
Pro nekomerční použítí si můžete nainstalovat 2 verze Portaineru
1. *Community Edition:* základní (ale funkční) verze. Nevyžaduje žádné licencční klíče, poskytuje jen základní funkčnost (není tak jenoduchá aktualizace kontejnerů)
2. *Bussiness Edition:* rozšířené funkce (šablony, snadné aktualizace kontejnerů apod). Vyžafuje licenční klíč, ale pokud máte jen 3 nody (rozuměj 3 oddělené servery s Docker kontejnery - což v námi popisovaném případu nebude), můžete zístal licenci úplně zdarma. Pouze vyplníte formulář na požadavek licence: https://www.portainer.io/take-3. Na email vyplněný ve formuláři přijde obratem licecnční klíč. Ten použijete k odemčení prémiových funkcí. Klíč má platnost 1 rok. Poté přijde informace o jeho expiraci. V emailu je ale odkaz na prodloužení (https://www.portainer.io/renew). Opět free.

Portainer je nainstalován v předchozím kroku spuštěním instalačního skriptu. Pokud nezadáte licencční klíč (vlevo nahoře je odkaz na Business edici), poběží v "community edici"

#### První přihlášení
https://IP_ADRESA_SERVERU:9443

POZOR: Při instalaci se vytvoří certifikát podepsaný sám sebou (nedůvěryhodný). Pro přístrup bude potřeba v prohlížeči povolit "výjimku"

Na přihlašovací obrazovce vyplníáte heslo admina (doporučuji zvolit bezpečné heslo). Po přihlášení se zobrazí průvodce, který nabídne vytvoření Enviroment (prostředí, kde budeme instalovat své kontejnery - Nightscout, mongo, traefik a klidně i další). Nemusíme vytvářet nic nové - instalcí Portaineru se už jedno "lokální" připravilo. To nám bude stačit :). Takže klikneme na "Get started". Pak se připojíme k "local" prostředí (tlačítko "Live connect"). Dostaneme se na Dashboard. 

#### Zabezpečení ####
Protože je rozhraní Portaineru veřejně dostupné, je velmi důležité přístup zabezpečit volbou dostatečně dlouhého a "neuhádnutelného" hesla. Ještě lepší je omezit přihlášení pouze na důvěryhodné IP adresy za pomoci firewallu. Jde o port ```9443```. Konkrétní nastavení ale záleží na použitém firewallu, takže ho zde uvádět nebudu.

#### Vytváření kontejnerů

V levém menu Dashboardu najdeme vše co potřebujeme: 
* **Stacks**": skupina služeb běžících v kontejneru
* **Containers**: vlastní kontejnery
* **Templates**: šablony, na základě kterých můžete vytvářet nové Nightscout servery. Jsou pouze v Business edici.

Pro základní vytvoření jediného Nightsout serveru necháme stranou šablony a rovnou vytvoříme Stack. 
* traefik
* mongodb (vytvořený kontejner pojmenujte mongodb - toto jméno je totiž i v konfigiraci Nightscoutu)
* nightscout

Předpis pro Stack jsou soubory [traefik.yaml](traefik.yaml), [mongodb.yaml](mongodb.yaml), [nightscout.yaml](nightscout.yaml). Jejich obsah se vkopíruje do příslušné části formuláře po kliknutí na "Add stack". Jméno si zvolíte tak, aby odpovídalo tomu, co vytváříte (traefik + mongodb + nightscout). Po kliknutí na tl. Deploy stack se kontejner vytvoří. 

**POZOR**: nekopírujte slepě obsah souborů. Předpisy vyžadují nastavení proměnných - email pro vytvoření certifikátu, API_SECRET pro Nightscout apod. Takže věnujte pozornost každému řádku předpisu..... Proměnné jako je název mongo databáze pro Nightscout, přihlašovací jméno a heslo MUSÍ být předpisech mongodb.yaml + nightscout.yaml stejné. Nezapomeňte, že Nightscout API_SECRET, alespoň 12 náhodných znaků (nedávejte jméno a příjmení, diakritiku, mezery)

Traefik je webový server, který zajišťuje připojení z Internetu. Pro vystavení certifikátu nezapomeňte zadat funkční email do ```--certificatesResolvers.letsencrypt.acme.email=mail@domain.tld"```

## MongoDB

Zde jsou uložena data vašeho Nightscoutu.
Administrátor už existuje (podle údajů proměnných MONGO_INITDB_ROOT_USERNAME + MONGO_INITDB_ROOT_PASSWORD, které vyplňujete v předpisu mongodb.yaml). Zbývá vytvořit databázi a uživatele, který se bude z Nightscoutu přihlašovat. Pro každý Nightscout je potřeba vytvořit databázi (např. nightscoutdb, nightscoutdb1, nightscoutdb2....) a uživatele (nsuser, nsuser1, nsuser2....) . Soubor podle kterého se vytvoří uživatel je nahraný během instalace do ```/opt/docker/add-mongo-user.js```. Stačí ho jen upravit a zvolit si přihlašovací jméno a heslo. To samé se musí napsat do připojovacího řetězce v konfiguraci Nightscoutu [nightscout.yaml](nightscout.yaml).
   
```
'MONGO_CONNECTION=mongodb://nsuser:MOJE-TAJNE-HESLO-PRO-DB@mongodb:27017/nightscoutdb'
```
Nenechávejte ve skriptu původní jména a hesla, a nezadávejte snadno uhádnutelná hesla!!!

Po úpravě spustíte příkaz: 

```
cat /opt/docker/add-mongo-user.js  | docker exec -i mongodb mongosh
```
Ten vytvoří uživatele.

# Závěr
Pokud jste při vytváření neudělali chybu (například jste v konfigiraci Nightscoutu vyplnili jiné jiné přihlašovací jméno a heslo než při vytváření v mongodb), měla by vaše instance Nightscoutu běžet na odméně, kterou jste si vybrali 


# License
[![Creative Commons: Uveďte původ-Neužívejte komerčně 4.0 Mezinárodní License](https://i.creativecommons.org/l/by-nc/4.0/88x31.png "Creative Commons: Uveďte původ-Neužívejte komerčně 4.0 Mezinárodní License")](http://creativecommons.org/licenses/by-nc/4.0/)
