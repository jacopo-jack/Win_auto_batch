@echo off
:: apre pannello di controllo e impostazioni
:: per ricercare app da disinstallare
:start
start ms-settings:appsfeatures
start appwiz.cpl
::routine per regedit ed
::esplora risorse
:regedit
start regedit
start explorer
::routine per pulizia file temporanei
:temp 
start %temp% 
