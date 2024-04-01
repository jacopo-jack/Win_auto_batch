@echo off
title SpeedUp_disk
setlocal
rem Definisco variabile d'ambiente
set "path=autowin\speed_updisk\Portable"
rem Definisci l'URL del pacchetto ZIP
set "url=https://www.gentiluomodigitale.it/?s=disk+speed+tools"
rem Apri l'URL nel browser predefinito
start "" "%url%"
rem Aspetta che l'utente abbia scaricato il file manualmente e prema un tasto per continuare
echo Assicurati di aver scaricato il file ZIP dalla pagina web e poi premi un tasto per continuare...
pause > nul
rem Apri la cartella Download dell'utente standard
start "" "%USERPROFILE%\Downloads"
pause > nul 
echo premi un tasto per continuare
rem Se un'app è portatile
cd /d "%path%"
if exist ssdboostersetup.exe (
    start %path%\ssdboostersetup.exe
) else ( 
    echo Non ho trovato il programma; se vuoi che parta in automatico
    echo Per favore estrai qui il programma e riavvia lo script.
)
endlocal
