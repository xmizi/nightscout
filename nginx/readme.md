# instalace nginx
1. **Webový server nginx**:

    Obvykle je v repozitářích, takže není třeba nic přidávat. Standardní instalace je u debiana přes ```apt install nginx```. Dodatečně jsem instaloval ```libnginx-mod-http-geoip``` pro povolení přístupu z konkrétních zemí - aktuálně nepoužívám (i když je v konfiguraci). Pro zájemce odkazuji na dokumentaci. Pro použítí je nutné modul povolit. Další je a ```python3-certbot-nginx``` kvůli certifikátu.

2. **Certbot**:

    Zajišťuje vyvotření a pravidelnou obnovu certifikátu pro zabezpečené připojení k Nightscoutu. Instalace opět z repozitáře přes ```apt install certbot```. Spuštění příkazu ```certbot``` bez parametru poskytne interaktivní menu kde si lze vybrat, jaký certifikát se bude vystavovat. Při prvním spuštění bude potřeba zadat email admina. Ve vlastním zájmu zadejte váš funkční email. V případě, že se nepovede certifikát obnovit, budou na něj chodit varování. Po vystavení certifikátu nabídne certbot úpravu konfigurace. Doporučuji nastavit i přesměrování http→https.
  
3. **Konfigurace**

* nginx.conf - hlavní konfigurace nginxu. Jediná úprava oproti defaultnímu jsou websockety. Přes ně komunikuje klient (například AAPS). Každá instance nightscoutu vyžaduje vlastní konfgiraci websocketu. Základní je pro port 1337. Další se vytvří podle nastavených portů. Samozřejmě je třeba změnit jméno

   Např. první:
   ```
  upstream websocket-honzicek {
      server 127.0.0.1:1337;
      keepalive 15;
  }
  ```
   druhý
  ```
  upstream websocket-pepicek {
      server 127.0.0.1:1338;
      keepalive 15;
  }
  ```
   atd.
