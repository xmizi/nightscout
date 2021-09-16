# Nastavení mongodb

## Instalace ##
standardně podle distribuce. Používám Debian, takže podle https://docs.mongodb.com/manual/tutorial/install-mongodb-on-debian/. Aktuálně mám mongodb 4.2. Vyšší verze jsou na vyzkoušení.....

## Uživatelé ##

1. vytvoření administrátora (v konfiguraci serveru se vypne auth, vytvoří se administrátor, a pak se zase zapne)
```
mongo  --port 27017 admin --eval "db.createUser({user:'nsadmin',pwd:'mojetajneheslo', roles:[{role:'root',db:'admin'}]})"
```

2. vytvoření běžného uživatele (co se bude přihlašovat z nightscoutu). Pro každý Nightscout je potřeba vytvořit speciální databázi (např. nightscoutdb1. nightscoutdb2....)
```
mongo --port 27017 -u nsadmin -pmojetajneheslo --authenticationDatabase admin nightscoutdb1 --eval "db.createUser({user: 'nsuser1', pwd: 'mojeheslo123',roles: ['readWrite']})"
```
  _analogicky se vytvoří další_
```
mongo --port 27017 -u nsadmin -pmojetajneheslo --authenticationDatabase admin nightscoutdb2 --eval "db.createUser({user: 'nsuser2', pwd: 'mojeheslo123',roles: ['readWrite']})"
```

3. Kontrola
```
root@nightscout:~# netstat -lnpt | grep mongo
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 0.0.0.0:27017           0.0.0.0:*               LISTEN      21674/mongod
```
Pro připojení z dockerů musí mongodb naslouchat na 0.0.0.0
