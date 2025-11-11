# Nastavení mongodb

## Instalace ##
MongoDB běží v docker kontejneru

## Uživatelé ##

1. Administrátor
   při instalaci v dockeru už je vytvořený (podle údajů proměnných MONGO_INITDB_ROOT_USERNAME + MONGO_INITDB_ROOT_PASSWORD, které vyplňujete v předpisu )

2. vytvoření běžného uživatele (co se bude přihlašovat z nightscoutu). Pro každý Nightscout je potřeba vytvořit speciální databázi (např. nightscoutdb1. nightscoutdb2....)
```
mongo --port 27017 -u nsadmin -pmojetajneheslo --authenticationDatabase admin nightscoutdb1 --eval "db.createUser({user: 'nsuser1', pwd: 'mojeheslo123',roles: ['readWrite']})"
```
  _analogicky se vytvoří další databáze + uživatel pro ní_
```
mongo --port 27017 -u nsadmin -pmojetajneheslo --authenticationDatabase admin nightscoutdb2 --eval "db.createUser({user: 'nsuser2', pwd: 'mojeheslo123',roles: ['readWrite']})"
```
