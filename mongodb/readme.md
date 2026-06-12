# Nastavení mongodb

## Instalace ##
MongoDB běží v docker kontejneru

## Uživatelé ##

1. Administrátor
   při instalaci v dockeru už je vytvořený (podle údajů proměnných MONGO_INITDB_ROOT_USERNAME + MONGO_INITDB_ROOT_PASSWORD, které vyplňujete v předpisu mongodb.yaml)

2. vytvoření běžného uživatele (co se bude přihlašovat z nightscoutu) a jeho databáze. Pro každý Nightscout je potřeba vytvořit speciální databázi (např. nightscoutdb. nightscoutdb2....). Soubor podle kterého se vytvoří uživatel je nahraný běhěm instalace do /opt/docker/add-user.js. Stačí ho jen upravit a zvolit si odpovídající přihlašovací jméno a heslo. To samé se musí napsat do připojovacího řetězce v konfiguraci Nightscoutu [nightscout.yaml](/docker/nightscout.yaml)
   
```
'MONGO_CONNECTION=mongodb://nsuser:MOJE-TAJNE-HESLO-PRO-DB@mongodb:27017/nightscoutdb'
```

Pak se spustí následující příkaz: 

```
cat /opt/docker/add-mongo-user.js  | docker exec -i mongodb mongosh
```
Ten vytvoří uživatele.
