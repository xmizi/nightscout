# Nastavení mongodb

=== Instalace ===
standardně podle distribuce. Používánme Debian, takže podle https://docs.mongodb.com/manual/tutorial/install-mongodb-on-debian/. Aktuálně mám mongodb 4.2. Vyšší verze jsou na vyzkoušení.....

=== Uživatelé ===

1. vytvoření administrátora
```
mongo  --port 27017 admin --eval "db.createUser({user:'nsadmin',pwd:'mojetajneheslo', roles:[{role:'root',db:'admin'}]})"
```
2. vytvoření běžného uživatele (co se bude přihlašovat z nightscoutu)
```
mongo --port 27017 -u nsadmin -pmojetajneheslo --authenticationDatabase admin nightscoutdb --eval "db.createUser({user: 'nsuser', pwd: 'mojeheslo123',roles: ['readWrite']})"
```
_analogicky se vytvoří další_
