@echo off

REM this is the original unintall script that has been ported to chocolatey

REM agent_uninstall.bat
REM
REM A wrapper script for calling agent_uninstall.pyc with the proper python path 
REM and python binary. We also perform the .msi removal and clean up after ourselves.

REM Run the removal script
setlocal

set ADIR=%SystemDrive%\Program Files\Opsware\agent
if exist "%ProgramFiles%\Opsware\agent" set ADIR=%ProgramFiles%\Opsware\agent
set PATH=%ADIR%\lcpython15;%PATH%


set SRC=%ADIR%\pylibs\cog
python "%SRC%\uninstall\agent_uninstall.pyc" %*

if "%ERRORLEVEL%" NEQ "0" goto :eof 

REM Figure out the platform and perform the appropriate install.
IF "%PROCESSOR_ARCHITECTURE%"=="AMD64" goto :REMOVE_X64
IF "%PROCESSOR_ARCHITECTURE%"=="x86" goto :REMOVE_X86
IF "%PROCESSOR_ARCHITECTURE%"=="IA64" goto :REMOVE_IA64

goto :REMOVE_ERROR

:REMOVE_X64
set uninstall_launcher=%SystemRoot%\system32\run_python_uninstaller_sas_x64.exe
set uninstall_msi=%ADIR%\pylibs\cog\uninstall\agent_uninstall_x64.msi
goto :REMOVE_FILES

:REMOVE_X86
set uninstall_launcher=%SystemRoot%\system32\run_python_uninstaller_sas_x86.exe
set uninstall_msi=%ADIR%\pylibs\cog\uninstall\agent_uninstall_x86.msi
goto :REMOVE_FILES

:REMOVE_IA64
set uninstall_launcher=%SystemRoot%\system32\run_python_uninstaller_sas_ia64.exe
set uninstall_msi=%ADIR%\pylibs\cog\uninstall\agent_uninstall_ia64.msi
goto :REMOVE_FILES

REM On strange platforms, issue an error
:REMOVE_ERROR
echo Unknown processor architecture %PROCESSOR_ARCHITECTURE% 
echo Uninstall failed.
set ERRORLEVEL=1
goto :eof

REM Perform the removal of all the shtuff
REM FORCE="1" was added by Joey Piccola
:REMOVE_FILES
msiexec /qn /x "%uninstall_msi%" REMOVE_MSI_ONLY=1 FORCE=1
if exist "%uninstall_launcher%" del /q /f "%uninstall_launcher%"
cd \

REM **NOTE** This MUST be the last line in the file!! Otherwise sadness will ensue.
REM This is essentially a self-deleting batch file.  In order to avoid locked directories and
REM "BATCH FILE NOT FOUND" errors, we spawn the final removal into a separate process.  That
REM process changes its working directory to the root, deletes the opsware install, and then closes 
REM out the spawned interpreter process.  Spawning the removal in this way allows the original command
REM process to finish processing the batch file and go away before the removal takes place.
REM The CD here is NOT redundant! Some cmd.exe environments have an autodir set. We want to make sure
REM that we are not in the critical path.
start /b /low cd \ && rmdir /q /s "%ADIR%" && exit
