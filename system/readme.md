# Systém
Nebudu zde uvádět konfiguraci a nastavení krok za krokem. Základní instalace po objednání dostačuje. VPS Protože jde o server ve vlastní správě, měl by člověk něco málo znát. 
Takže základy typu instace balíčků, editace souborů, restart služeb, kde najít logy nebudu popisovat. Kromě nastavení firewallu (kvůli omezení přístupu k systému z důvěryhodných IP adres) není třeba žádné větší instalace. Doporučuji nastavit automatické upgrady systému - v Debianu jde o unattended-upgrades

Připravil jsem instalační skript [instalace-systemu.sh](instalace-systemu.sh). Je třeba ho nahrát na server a spustit jako root. Pokud se přihlašujete jako běžný uživatel a systémové příkazy spouštíte přes sudo, zvolí skript použítí sudo. Skript nainstaluje potřebné balíčky a Portainer. Po ukončení instalace doporučuji server rebootovat. Po rebootu se pokračuje vytvořením docker kontejnerů pro webovou proxy (traefik), nightscout a jeho mongo databázi.
