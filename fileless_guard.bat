@echo off
title file_less_guard
::rem lancio il pannello di controllo
::una volta entrato nella funzione main
echo parte del comando richiede di eseguire PowerShell come amministratore.
echo Digita 1 per proseguire senza privilegi, 2 per chiudere il programma.
echo Se chiudi il programma, ricordati di avviarlo come amministratore facendo
echo click col tasto destro del mouse!
goto :main

:main
setLocal
:: Apri la finestra "Caratteristiche opzionali" di Windows
:: cerca meglio nelle cartelle di sistema il percorso e poi
:: decommenta per ora fai manualmente
:: start control\optionalfeatures
echo Apri la finestra "Caratteristiche opzionali" di Windows
echo una volta che lo script ti apre il pannello di controllo.
echo Cerca la voce "PowerShell 2.0" e togli il segno di spunta, poi premi OK
start control 
goto PowerShell

:PowerShell
echo per prevenire attacchi fileless digitare:
echo "1. get-executionpolicy"
echo "2. set-executionpolicy remotesigned (nel caso sia unrestricted o restricted)"
echo "3. Ridigita nuovamente il primo comando per vedere se le policy sono state opportunamente modificate."
echo "4. Digita 'continue' per uscire e proseguire con lo script"
echo "5. Digita 'close'per uscire dal programma
set /p scelta="Scelta: "
powershell
if "%scelta%"=="continue" goto :policy
if "%scelta%"=="close" goto :eof

:policy 
:: mi connetto via powershell sul sito gentiluomo digitale e
:: scarico policy plus che permette di modificare le policy di
:: sistema anche in windows10/11 
:: prima exit o cmd per proseguire se no non va
set "url=https://www.gentiluomodigitale.it/?s=policy+plus"
start "" "%url%"
pause > nul 
:: cartella dove opzionalmente mettere il programma portatile
:: e farlo partire in automatico caso main
mkdir pplus
cd pplus
dir
if exist policyplus.exe (
    start policyplus.exe
) else (
    echo file non trovato; apri la cartella da download e 
    echo aprilo da li. Altrimenti trascinalo qui dentro e
    echo fai ripartire lo script!
)
goto :eof
endLocal
:eol
