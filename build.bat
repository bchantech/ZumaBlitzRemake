@echo off
setlocal enabledelayedexpansion

:: 0/5: Setup
:: Check if 7z is in %PATH%
7z>nul
if %ERRORLEVEL%==9009 (
    echo Error: Could not locate 7z in %%PATH%%.
    echo Make sure a directory where 7z.exe is located is in %%PATH%%.
    pause && exit
)
set 32FOUND=0
set 64FOUND=0

:: 1/5: Prepare for fusing
echo Compiling files... (1/5)
if not exist exlist.txt (
    echo Error: exlist.txt not found.
    echo Make sure this file exists - this is a list of what not to include in the archive.
    pause && exit
)
7z a compiled.zip .\* -x@exlist.txt

:: 2/5: 32-bit compiling
echo.
echo Fusing 32-bit LOVE exe... (2/5)
if exist "C:\Program Files (x86)\LOVE\love.exe" (
    set 32FOUND=1
    mkdir build\x32
    copy /b "C:\Program Files (x86)\LOVE\love.exe"+compiled.zip "build\x32\ZumaBlitzRemake.exe"
) else (
    echo 32-bit LOVE directory could not be found. Skipping...
)

:: 3/5: 64-bit compiling
echo.
echo Fusing 64-bit LOVE exe... (3/5)
if exist "C:\Program Files\LOVE\love.exe" (
    set 64FOUND=1
    mkdir build\x64
    copy /b "C:\Program Files\LOVE\love.exe"+compiled.zip "build\x64\ZumaBlitzRemake.exe"
) else (
    echo 64-bit LOVE directory could not be found. Skipping...
)

:: Abort if neither directories are found
if !32FOUND!==0 (
    if !64FOUND!== 0 (
        echo Error: Neither 32-bit nor 64-bit LOVE directories were found.
        echo Aborting...
        pause && exit
    )
)

:: 4/5: copy files
echo.
echo Copying assets... (4/5)
for %%a in (32 64) do ( 
    if exist "build\x%%a" (
        :: LOVE/shared binaries
        if %%a==32 (
            for %%f in (love.dll lua51.dll mpg123.dll msvcp120.dll msvcr120.dll OpenAL32.dll SDL2.dll) do (
                copy /b "C:\Program Files (x86)\LOVE\%%f" "build\x%%a\%%f"
            )
        ) else (
            for %%f in (love.dll lua51.dll mpg123.dll msvcp120.dll msvcr120.dll OpenAL32.dll SDL2.dll) do (
                copy /b "C:\Program Files\LOVE\%%f" "build\x%%a\%%f"
            )
        )
        :: doc files
        for %%h in (README.md CREDITS.md autoload.txt LICENSE) do (
            copy /b ".\%%h" "build\x%%a\%%h"
        )
        :: folders
        for %%g in (dll engine games schemas) do (
            robocopy "%%g" "build\x%%a\%%g" *.* /s
        )
    )
)

:: TODO: Create an extra step to edit EXE metadata via Resource Hacker.
:: I'll uncomment this step once icons have been made.

:: x/x: create packages
::echo.
::echo Creating packages... (x/x)
::for %%a in (32 64) do ( 
::    if exist "build\x%%a" (
::        7z a "build\ZumaBlitzRemake-x%%a.zip" .\build\x%%a\*
::    )
::)

:: 5/5: cleanup
echo.
echo Cleaning up... (5/5)
echo Deleting zip file...
del compiled.zip
if !ERRORLEVEL!==0 (
    echo Deleted compiled.zip
) else (
    echo Could not delete compiled.zip
)

echo.
echo ================================
echo.
echo Building finished:
if !32FOUND!==1 (
    echo - Built 32-bit version.
)
if !64FOUND!==1 (
    echo - Built 64-bit version.
)
pause