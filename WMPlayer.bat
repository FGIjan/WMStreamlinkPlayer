@echo off
WHERE streamlink >nul 2>nul
IF %ERRORLEVEL% NEQ 0 ECHO Streamlink was not found! Try installing it via pip...
IF %ERRORLEVEL%==0 GOTO start
WHERE pip >nul 2>nul
IF %ERRORLEVEL% NEQ 0 ECHO pip was not found... Please install pip first (you need python3!)
IF %ERRORLEVEL% NEQ 0 GOTO end
IF %ERRORLEVEL%==0 echo Should I install Streamlink? [y/n] 
set answer=y
set /p answer=
IF %answer% NEQ y GOTO end
pip install streamlink
:start
if [%1] == [] GOTO input
if %1==zdf GOTO zdf
if %1==ard GOTO ard
if %1==ZDF GOTO zdf
if %1==ARD GOTO ard
:input
if %date:~-10,2%%date:~-7,2%==2406 GOTO ard
if %date:~-10,2%%date:~-7,2%==2506 GOTO zdf_auswahl
if %date:~-10,2%%date:~-7,2%==2606 GOTO ard_auswahl
if %date:~-10,2%%date:~-7,2%==2706 GOTO zdf_auswahl
if %date:~-10,2%%date:~-7,2%==2806 GOTO ard_auswahl
echo "Welcher Sender? [ARD/ZDF]"
set sender=zdf
set /p sender=
if %sender%==zdf GOTO zdf
if %sender%==ZDF GOTO zdf
if %sender%==ard GOTO ard
if %sender%==ARD GOTO ard
if %sender%== GOTO end
echo "Falsche Eingabe!"
GOTO input
:zdf
streamlink https://www.zdf.de/live-tv 720p
GOTO end
:ard
streamlink "https://www.ardmediathek.de/tv/live?kanal=208" 4955k_alt2
GOTO end
:zdf_auswahl
echo "ZDFinfo oder ZDF? [ZDFinfo/ZDF]"
set sender=info
set /p sender=
if %sender$==zdf GOTO zdf
if %sender$==ZDF GOTO zdf
streamlink https://www.zdf.de/dokumentation/zdfinfo-doku/zdfinfo-live-beitrag-100.html 3096k
GOTO end
:ard_auswahl
echo "ARD oder ONE? [ARD/ONE]"
set sender=ARD
set /p sender=
if %sender$==ARD GOTO ard
if %sender$==ard GOTO ard
start https://www.ardmediathek.de/tv/live?kanal=673348
:end
