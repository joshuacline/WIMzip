@ECHO OFF&&COLOR 0B&&TITLE  Download from github.com/joshuacline
ECHO ============================== WIMzip ==============================
ECHO To archive the current folder, right click and run as administrator.
ECHO ====================================================================
ECHO Renaming (this) file, changes the name of the output archive.
ECHO ====================================================================
ECHO To extract, right click (this) file then create a new shortcut.
ECHO Right click shortcut-properties, advanced, then run as administrator.
ECHO Drag and drop the .$Z file onto the shortcut.
ECHO ====================================================================
Reg.exe query "HKU\S-1-5-19\Environment">NUL 2>&1
IF NOT "%ERRORLEVEL%" EQU "0" PAUSE&&EXIT 0
CD /D "%~DP0"&&IF "%1"=="" GOTO :RESTART
IF "%CD%"=="%TEMP%" IF "%1"=="RUN" GOTO:ARCHIVE
:EXTRACT
IF NOT "%~X1"==".$Z" ECHO Must be .$Z extenstion&&PAUSE&&EXIT 0
IF EXIST "%~DP0%~N0\*" RD /S /Q "%~DP0%~N0">NUL 2>&1
MD "%~DP0%~N0">NUL 2>&1
ECHO Extracting...
DISM /APPLY-IMAGE /IMAGEFILE:"%1" /INDEX:1 /APPLYDIR:"%~DP0%~N0">NUL 2>&1
ECHO DONE.
ECHO ====================================================================
GOTO:END
:RESTART
ECHO Press (1) to self-copy
ECHO ====================================================================
ECHO Press enter to create archive.&&SET /P "COPY=$>>"
IF "%COPY%"=="1" SET "FOLDER=%CD%"&&GOTO:JUMP
COPY /Y "%0" "%TEMP%">NUL 2>&1
ECHO %CD%>"%TEMP%\$TEMP"
CMD /C "%TEMP%\%~NX0" RUN
EXIT 0
:ARCHIVE
SET /P FOLDER=<"$TEMP"
IF EXIST "$TEMP" DEL /F "$TEMP">NUL 2>&1
IF EXIST "%FOLDER%\%~NX0" DEL /F "%FOLDER%\%~NX0">NUL 2>&1
:JUMP
IF EXIST "%TEMP%\%~N0.$Z" DEL /F "%TEMP%\%~N0.$Z">NUL 2>&1
ECHO ====================================================================
ECHO Archiving...
DISM /CAPTURE-IMAGE /CAPTUREDIR:"%FOLDER%" /IMAGEFILE:"%TEMP%\%~N0.$Z" /COMPRESS:FAST /NAME:"%~N0">NUL 2>&1
MOVE "%TEMP%\%~N0.$Z" "%FOLDER%">NUL 2>&1
IF "%COPY%"=="1" GOTO:END
COPY /Y "%0" "%FOLDER%">NUL 2>&1
DEL /F "%0">NUL 2>&1
:END