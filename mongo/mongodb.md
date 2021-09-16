# Nastavení mongodb

## Instalace ##
standardně podle distribuce. Používám Debian, takže podle https://docs.mongodb.com/manual/tutorial/install-mongodb-on-debian/. Aktuálně mám mongodb 4.2. Vyšší verze jsou na vyzkoušení.....

## Uživatelé ##

1. vytvoření administrátora
```
mongo  --port 27017 admin --eval "db.createUser({user:'nsadmin',pwd:'mojetajneheslo', roles:[{role:'root',db:'admin'}]})"
```
2. vytvoření běžného uživatele (co se bude přihlašovat z nightscoutu)
```
mongo --port 27017 -u nsadmin -pmojetajneheslo --authenticationDatabase admin nightscoutdb --eval "db.createUser({user: 'nsuser', pwd: 'mojeheslo123',roles: ['readWrite']})"
```
  _analogicky se vytvoří další_

3. Kontrola
```
root@nightscout:~# netstat -lnpt | grep mongo
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 0.0.0.0:27017           0.0.0.0:*               LISTEN      21674/mongod
```
Pro připojení z dockerů musí mongodb naslouchat na 0.0.0.0
