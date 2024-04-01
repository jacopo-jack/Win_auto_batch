# Win_auto_batch
Una raccolta di script per automatizzare operazioni da sistemisti su Windows. Ho preso spunto da diversi video su Youtube.
Eseguendo tali script molte operazioni rutinarie di ottimizzazione verranno eseguite dagli script come ad esempio aprire
Poweshell dove ce n'è bisogno e altri tool da riga di comando

## Nel repository troverai:
    1. Un debloater: da eseguire come amministratore in quanto si collega al github di CTT per scaricare il debloater effettivo;
    2. Uno script chiamato filess_guard: ti guida nella disinstallazione di Powershell2.0 e ti consente di cambiare policy per l'esecuzione
       di script Powershell. Consigliabile eseguirlo come amministratore; tutta via puoi anche proseguire con lo script che ti permette di
       scaricare policy plus che permette anche sotto windows10 e 11 home di cambiare policy del pc
    3.Nella cartella SpeedUp_disk c'è un file main che una volta eseguito ti permette di scaricare delle utility per ottimizzare l'ssd
      ed hard disk; l'utility per l'hard disk è portabile e se inserita nella cartella Portable  viene lanciata automaticamente dal main.bat
    4. Nella cartella Rescue: un file batch da lanciare come amministratore per riparare vari guasti a usb e hard disk esterni grazie a diskpart
       utility di Windows che per funzionare ha appunto bisogno di privilegi elevati.
    5.Browser_flag: una lista di flag per ottimizzare vari browser
    6.extra_win: un elenco di comandi shell da dare dopo aver eseguito la shell con win+ r

## Note

- Assicurarsi di eseguire gli script solo su sistemi Windows e di comprendere le operazioni che eseguono prima di utilizzarli.
- Prima di eseguire gli script, è consigliabile fare un backup dei dati importanti per evitare la perdita accidentale di informazioni.
- Fork e miglioramenti vari sono bene accetti
