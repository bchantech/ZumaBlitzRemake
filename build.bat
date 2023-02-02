@echo off
setlocal enabledelayedexpansion

:: 0/7: Setup
set SVZFOUND=0
set RHFOUND=0
set 32FOUND=0
set 64FOUND=0
set SVZ=
set RH=

:: Flags
set NOPACKAGES=0

for %%a in (%*) do (
    if "%%a"=="--no-packages" (
        set NOPACKAGES=1
    )
)

if exist ".\build" (
    echo Deleting previous build folder.
    del /s /q ".\build"
)

:: Check for 7-zip
echo Checking for 7-zip...
for %%a in (7z "C:\Program Files\7-Zip\7z.exe" "C:\Program Files (x86)\7-Zip\7z.exe") do (
    if !SVZFOUND!==0 (
        %%a>nul
        if !ERRORLEVEL!==0 (
            set SVZ=%%a
            set SVZFOUND=1
            echo 7-zip found^^!
        )
    )
)
if %SVZFOUND%==0 (
    echo Error: Could not locate 7z in %%PATH%% or Program Files.
    pause && exit
)

:: Check for Resource Hacker
echo Checking for Resource Hacker...
for %%a in (ResourceHacker "C:\Program Files (x86)\Resource Hacker\ResourceHacker.exe") do (
    if !RHFOUND!==0 (
        %%a -help>nul
        if !ERRORLEVEL!==0 (
            set RH=%%a
            set RHFOUND=1
            echo Resource Hacker found^^!
        )
    )
)

:: 1/5: Prepare for fusing
echo Compiling files... (1/7)
if not exist exlist.txt (
    echo Error: exlist.txt not found.
    echo Make sure this file exists - this is a list of what not to include in the archive.
    pause && exit
)
%SVZ% a compiled.zip .\* -x@exlist.txt

:: 2/5: 32-bit compiling
echo.
echo Fusing 32-bit LOVE exe... (2/7)
if %PROCESSOR_ARCHITECTURE%==32 (
    :: 32-bit
    if exist "C:\Program Files\LOVE\love.exe" (
        set 32FOUND=1
        mkdir build\x32
        copy /b "C:\Program Files\LOVE\love.exe"+compiled.zip "build\x32\ZumaBlitzRemake.exe"
    ) else (
        echo 32-bit LOVE directory could not be found. Skipping...
    )
    
    if exist "C:\Program Files\LOVE\love.exe" (
        set 32FOUND=1
        mkdir build\x32
        copy /b "C:\Program Files\LOVE\love.exe"+compiled.zip "build\x32\ZumaBlitzRemake.exe"
    ) else (
        echo 32-bit LOVE directory could not be found. Skipping...
    )
) else (
    :: 64-bit
    if exist "C:\Program Files (x86)\LOVE\love.exe" (
        set 32FOUND=1
        mkdir build\x32
        copy /b "C:\Program Files (x86)\LOVE\love.exe"+compiled.zip "build\x32\ZumaBlitzRemake.exe"
    ) else (
        echo 32-bit LOVE directory could not be found. Skipping...
    )

    if exist "C:\Program Files (x86)\LOVE\love.exe" (
        set 32FOUND=1
        mkdir build\x32
        copy /b "C:\Program Files (x86)\LOVE\love.exe"+compiled.zip "build\x32\ZumaBlitzRemake.exe"
    ) else (
        echo 32-bit LOVE directory could not be found. Skipping...
    )
)

:: 3/5: 64-bit compiling
echo.
if %PROCESSOR_ARCHITECTURE%==32 (
    echo 32-bit machine detected, skipping 64-bit build...
    goto skip64bitif32
)

echo Fusing 64-bit LOVE exe... (3/7)
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

:skip64bitif32
:: 4/5: copy files
echo.
echo Copying assets... (4/7)
for %%a in (32 64) do ( 
    if exist "build\x%%a" (
        :: LOVE/shared binaries
        if %%a==32 (
            if %PROCESSOR_ARCHITECTURE%==32 (
                for %%f in (love.dll lua51.dll mpg123.dll msvcp120.dll msvcr120.dll OpenAL32.dll SDL2.dll) do (
                    copy /b "C:\Program Files\LOVE\%%f" "build\x%%a\%%f"
                )
            ) else (
                for %%f in (love.dll lua51.dll mpg123.dll msvcp120.dll msvcr120.dll OpenAL32.dll SDL2.dll) do (
                    copy /b "C:\Program Files (x86)\LOVE\%%f" "build\x%%a\%%f"
                )
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

:: 5/7: change metadata
if %RHFOUND%==0 (
    echo Resource Hacker was not found, skipping...
    goto skipresourcehacker
)
echo.
echo Changing EXE metadata... (5/7)
for %%a in (32 64) do ( 
    if exist "build\x%%a" (
        %RH% -open .\build\x%%a\ZumaBlitzRemake.exe -save .\build\x%%a\ZumaBlitzRemake.exe -action addoverwrite -res exe_resources.res
    )
)

:skipresourcehacker
:: 6/7: create packages
if !NOPACKAGES!==1 (
    echo Package creation skipped.
    goto skippackages
)
echo.
echo Creating packages... (6/7)
for %%a in (32 64) do ( 
    if exist "build\x%%a" (
        %SVZ% a "build\ZumaBlitzRemake-x%%a.zip" .\build\x%%a\*
    )
)

:skippackages
:: 7/7: cleanup
echo.
echo Cleaning up... (7/7)
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