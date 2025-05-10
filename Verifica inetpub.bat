@echo off
setlocal EnableDelayedExpansion

:: --- Configurazione -----------------------------------------
set "SERVICE=W3SVC"
set "FOLDER=C:\inetpub"
set "ACL_BASE=acl_baseline.txt"
set "HASH_BASE=hash_baseline.txt"

:: --- 1) Verifica privilegi amministratore -------------------
net session >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERRORE] Questo script deve essere eseguito come amministratore!
    echo Per favore, chiudi questa finestra e riavvia lo script facendo clic destro e selezionando 'Esegui come amministratore'
    pause
    exit /b 1
)

:: --- 2) Rilevo presenza e stato originale di IIS ------------
echo.
echo [*] Verifica servizio IIS...
sc query "%SERVICE%" >nul 2>&1
if %ERRORLEVEL% EQU 1060 (
    set "SERVICE_PRESENT=0"
    echo [ERRORE] Servizio IIS non trovato
) else (
    set "SERVICE_PRESENT=1"
    for /F "tokens=3" %%A in ('sc query "%SERVICE%" ^| findstr /I "STATE"') do set "ORIG_SERVICE_STATE=%%A"
    for /F "tokens=3" %%B in ('sc qc "%SERVICE%"    ^| findstr /I "START_TYPE"') do set "ORIG_START_TYPE_RAW=%%B"
    if /I "!ORIG_START_TYPE_RAW!"=="AUTO_START"   set "ORIG_START_TYPE=auto"
    if /I "!ORIG_START_TYPE_RAW!"=="DEMAND_START" set "ORIG_START_TYPE=demand"
    if /I "!ORIG_START_TYPE_RAW!"=="DISABLED"     set "ORIG_START_TYPE=disabled"
    echo [OK] Servizio IIS trovato (Stato: !ORIG_SERVICE_STATE!, Avvio: !ORIG_START_TYPE!)
)

:: --- 3) Verifico/eseguo ricreazione cartella ---------------
echo.
echo [*] Verifica cartella Inetpub...
if exist "%FOLDER%" (
    set "EXIST_STATUS=OK"
    echo [OK] Cartella Inetpub trovata
) else (
    echo [ERRORE] Cartella Inetpub non trovata
    if "!SERVICE_PRESENT!"=="1" (
        echo [*] Tentativo di ricreazione tramite IIS...
        sc config "%SERVICE%" start= auto >nul 2>&1
        sc start  "%SERVICE%"           >nul 2>&1
        timeout /t 3 >nul
        if exist "%FOLDER%" (
            set "EXIST_STATUS=NON ESISTENTE"
            set "CREATE_STATUS=OK"
            echo [OK] Cartella ricreata con successo tramite IIS
        ) else (
            echo [*] Fallito con IIS, tentativo con mkdir...
            mkdir "%FOLDER%" >nul 2>&1
            if exist "%FOLDER%" (
                set "EXIST_STATUS=NON ESISTENTE"
                set "CREATE_STATUS=OK"
                echo [OK] Cartella ricreata con successo tramite mkdir
            ) else (
                set "EXIST_STATUS=NON ESISTENTE"
                set "CREATE_STATUS=ERRORE"
                echo [ERRORE] Impossibile ricreare la cartella
            )
        )
    ) else (
        echo [*] IIS non presente: tentativo con mkdir...
        mkdir "%FOLDER%" >nul 2>&1
        if exist "%FOLDER%" (
            set "EXIST_STATUS=NON ESISTENTE"
            set "CREATE_STATUS=OK"
            echo [OK] Cartella ricreata con successo tramite mkdir
        ) else (
            set "EXIST_STATUS=NON ESISTENTE"
            set "CREATE_STATUS=ERRORE"
            echo [ERRORE] Impossibile ricreare la cartella
        )
    )
)

:: --- 4) Verifica permessi e sicurezza ----------------------
if exist "%FOLDER%" (
    echo.
    echo [*] Verifica permessi e sicurezza...
    
    :: Verifica permessi SYSTEM in modo più dettagliato
    set "SYSTEM_PERMISSIONS_OK=0"
    set "IIS_PERMISSIONS_OK=0"
    
    :: Verifica se la cartella è stata creata da IIS
    if "!CREATE_STATUS!"=="OK" (
        if "!SERVICE_PRESENT!"=="1" (
            set "IIS_PERMISSIONS_OK=1"
        )
    )
    
    :: Verifica permessi SYSTEM
    for /F "tokens=*" %%A in ('icacls "%FOLDER%" ^| findstr /I "SYSTEM"') do (
        echo %%A | findstr /I /C:"(F)" >nul && set "SYSTEM_PERMISSIONS_OK=1"
    )
    
    :: Verifica permessi IIS_IUSRS
    for /F "tokens=*" %%A in ('icacls "%FOLDER%" ^| findstr /I "IIS_IUSRS"') do (
        echo %%A | findstr /I /C:"(RX)" >nul && set "IIS_PERMISSIONS_OK=1"
    )
    
    if !SYSTEM_PERMISSIONS_OK! EQU 1 (
        if !IIS_PERMISSIONS_OK! EQU 1 (
            echo [OK] Permessi SYSTEM e IIS corretti
        ) else (
            echo [ERRORE] Permessi SYSTEM presenti ma non configurati correttamente da IIS
            set "SYSTEM_PERMISSIONS_OK=0"
        )
    ) else (
        echo [ERRORE] Permessi SYSTEM non corretti
    )
    
    if !SYSTEM_PERMISSIONS_OK! EQU 0 (
        echo.
        echo [SOLUZIONE] Per correggere i permessi, eseguire i seguenti passaggi:
        echo.
        echo 1. Disinstallare e reinstallare IIS:
        echo    - Aprire Pannello di controllo
        echo    - Programmi e funzionalità
        echo    - Attivare o disattivare le funzionalità Windows
        echo    - Deselezionare Internet Information Services
        echo    - Riavviare il sistema
        echo    - Riattivare Internet Information Services
        echo.
        echo 2. In alternativa, eseguire i comandi:
        echo    icacls "%FOLDER%" /reset
        echo    icacls "%FOLDER%" /grant "NT AUTHORITY\SYSTEM:(OI)(CI)F" /T
        echo    icacls "%FOLDER%" /grant "IIS_IUSRS:(OI)(CI)RX" /T
        echo    icacls "%FOLDER%" /grant "IUSR:(OI)(CI)RX" /T
        echo.
        echo 3. Riavviare il servizio IIS:
        echo    net stop w3svc
        echo    net start w3svc
        echo.
        set /p "CORREGGI=Vuoi correggere i permessi ora? (S/N): "
        if /I "!CORREGGI!"=="S" (
            echo.
            echo [*] Applicazione correzione permessi...
            icacls "%FOLDER%" /reset
            icacls "%FOLDER%" /grant "NT AUTHORITY\SYSTEM:(OI)(CI)F" /T
            icacls "%FOLDER%" /grant "IIS_IUSRS:(OI)(CI)RX" /T
            icacls "%FOLDER%" /grant "IUSR:(OI)(CI)RX" /T
            if !ERRORLEVEL! EQU 0 (
                echo [OK] Permessi corretti con successo
                echo [*] Riavvio servizio IIS...
                net stop w3svc >nul 2>&1
                net start w3svc >nul 2>&1
                echo [OK] Servizio IIS riavviato
                echo.
                echo [INFO] Per una correzione completa, si consiglia di:
                echo 1. Riavviare il sistema
                echo 2. Riavviare questo script per verificare i permessi
            ) else (
                echo [ERRORE] Impossibile correggere i permessi
            )
        )
    )
    
    :: Verifica modifiche recenti
    echo.
    echo [*] Verifica modifiche recenti...
    for /F "tokens=1-3 delims= " %%A in ('dir "%FOLDER%" /A:D /T:W ^| findstr /I /C:"%FOLDER%"') do (
        set "LAST_MOD=%%C"
    )
    echo [INFO] Ultima modifica: !LAST_MOD!
)

:: --- 5) Report finale --------------------------------------
echo.
echo ===========================================
echo REPORT FINALE
echo ===========================================
echo IIS: !SERVICE_PRESENT!
echo Cartella: !EXIST_STATUS!
if defined CREATE_STATUS echo Ricreazione: !CREATE_STATUS!
echo ===========================================

echo.
echo Premere un tasto per uscire...
pause >nul 