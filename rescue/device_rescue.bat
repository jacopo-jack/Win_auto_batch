@echo off
title device_rescue
cls
echo  benvenuto in device_rescue
type "img.txt"
goto menu
:menu
cls
color 9
type "img.txt"
echo "1.Help"
echo "2.PulisciRipristina"
echo "3.Fine"
set /p scelta="Fai la tua scelta (1-3): "
if "%scelta%"=="1" goto Help
if "%scelta%"=="2" goto PulisciRipristina
if "%scelta%"=="3" goto Fine
:Help
type "help.txt"
echo "1.torna al menu"
echo "2.strumenti"
echo "3.esci dal programma"
set /p scelta="Fai la tua scelta (1-3): "
if "%scelta%"=="1" goto menu
if "%scelta%"=="2" goto strumenti
if "%scelta%"=="3" goto Fine
:PulisciRipristina
cls 
diskpart 
::gestione file e altri strumenti per recupero disco::
:strumenti
start ""  "C:\Users"
start ""  "%windir%\system32\control.exe"
goto Fine
pause
:Fine
exit
