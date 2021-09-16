# instalace nginx
1. **Webový server nginx**:


    Obvykle je v repozitářích, takže není třeba nic přidávat. Standardní instalace je u debiana přes ```apt install nginx```. 
    Dodatečně jsem instaloval ```libnginx-mod-http-geoip``` a ```python3-certbot-nginx```. GeoiIP (pro povolení přístupu z konkrétních zemí) 
    nemám v konfigiraci implementované (odkazuji na dokumentaci), certbot je kvůli certifikátu.

2. **Certbot**:

    Zajišťuje vyvotření a pravidelnou obnovu certifikátu pro zabezpečené připojení k Nightscoutu. Instalace opět z repozitáře přes ```apt install certbot```. 
    Spuštění příkazu ```certbot``` bez parametru poskytne interaktivní menu kde si lze vybrat, jaký certifikát se bude vystavovat. Při prvním spuštění bude potřeba zadat email admina. 
    Ve vlastním zájmu zadejte váš funkční email. V případě, že se nepovede certifikát obnovit, budou na něj chodit varování. Po vystavení certifikátu nabídne certbot úpravu konfigurace.
    Doporučuji nastavit i přesměrování http→https 
  
