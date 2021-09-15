Před vytvořením kontejneru je nutné, aby existoval obraz serveru, na základě kterého se kontejner udělá. Jde o poměrně 
náročnou akci, kteou by nemusel low-cost VPS (1vCPU + 1 GB RAM) dokončit. Ovbykle to spadlo na nedostaku paměti. Obraz
ale lze sestavit na jakémkoliv jiném počítači, kam si docker nainstalujeme. To bude i tento případ.

1. instalace dockeru na počítači

2. vytvoření obrazu serveru (Dockerfile je konfigurace, která je v aktuální adresáři), 
   docker build --no-cache -t nightscout_1422_image . -f ./Dockerfile
   * je dobrá praxe označovat soubory verzí Nigtscoutu
   * --no-cache zajistí, že se obraz vytvoří "nanovo, bez ohledu na předchozí akce"

3. Pokud to děláme na počítači (nebo jiném serveru), je třeba obraz vyexportovat (defaultně je v lokálním docker úložišti)
   Dobrá praxe je ho rovnou zkomprimovat.
   docker save nightscout_1422_image | gzip -9 >  nightscout_1422_image.tgz


3. zkopírování vytvořeného obrazu na server (WinSCP apod....)

4. Na serveru se obraz naimportuje. Pokud jsme ho nahráli do /root/docker/images/, pak je to takto:
   docker load -i /root/docker/images/nightscout_1422_image.tgz

5. Hotovo, můžeme přejít na vytvření kontejneru