# Portainer

Jde o grafické rozhraní (GUI) pro správu kontejnerů v dockeru (samozřejmě nejen pro Docker, ale podrobné využítí není náplní tohoto návodu). Podrobné info najdete na domovské stránce projektu https://www.portainer.io. Pro nekomerční použítí si můžete nainstalovat 2 verze Portaineru

## Verze
1. *Community Edition:* základní (ale funkční) verze. nevyžaduje žádné licencční klíče
2. *Bussiness Edition:* rozšířené funkce (šablony, snadné aktualizace kontejnerů apod). Vyžafuje licenční klíč, ale pokud máte jen 3 nody (rozuměj 3 oddělené servery s Docker kontejnery - což v námi popisovaném případě nebude), můžete zístal licenci úplně zdarma. Pouze vyplníte fomrulář na požadavek licence: https://www.portainer.io/take-3. Na email vyplněný ve formuláři přijde obratem licecnční klíč. Ten použijete k odemčení prémiových funkcí. Klíč má platnost 1 rok. Poté přijde infomrace o jeho expiraci. V emailu je ale odkaz na prodloužení (https://www.portainer.io/renew). Opět free.

## Instalace 
Po přohlášení na server přes SSH spustíme jako administrátor (root) příkazy: 
```
docker volume create portainer_data
docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ee:lts
```


## Přihlášení
https://IP_ADRESA_SERVERU:9443

POZOR: Při instalaci se vytvoří certifikát podepsaný sám sebou (nedůvěryhodný). Pro přístrup bude potřeba v prohlížeči povolit "výjimku"

Na přihlašovací obrazovce vyplníáte heslo admina (doporučuji zvolit bezpečné heslo)

## Vytvoření prostředí pro Nightscout

Po přihlášení se zobrazí průvodce, který nabídne vytvoření Enviroment (prostředí, kde budeme instalovat své kontejnery - Nightscout, mongo, traefik a klidně i další). Nemusíme vytvářet nic nové - instalcí Portaineru se už jedno "lokální" připravilo. To nám bude stačit :). Takže klikneme na "Get started". Pak se připojíme k "local" prostředí (tlačítko "Live connect"). Dostaneme se na Dashboard. 

## Vytváření kontejnerů

V levém menu Dashboardu najdeme vše co potřebujeme: 
* Stacks (skupina služeb běžících v kontejneru)
* Containers (vlastní kontejnery)
* Templates (šablony, na základě kterých můžete vytvářet nové Nightscout servery)

Pro základní vytvoření jediného Nightsout serveru necháme stranou šablony a rovnou vytvoříme Stack. 
* traefik
* mongodb
* nightscout

Předpis pro Stack jsou soubory traefik.yaml, mongodb.yaml, nightscout.yaml. Jejich obsah se vkopíruje do příslušné části formuláře po kliknutí na "Add stack". Sazozřejmě jméno si zvolíte tak, aby odpovídalo tomu, co vytváříte (traefik + mongodb + nightscout). Po kliknutí na tl. Deploy stack se kontejner vytvoří. 

POZOR: nekopírujte slepě obsah souborů. Předpisy vyžadují nastavení proměnných - email pro vytvoření certifikátu, API klíč pro Nightscout apod. Takže věnujte pozornost každému řádku předpisu..... 
