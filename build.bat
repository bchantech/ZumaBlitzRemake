setlocal enabledelayedexpansion
7z a compiled.zip .\* -x@exlist.txt
copy /b "C:\Program Files\LOVE\love.exe"+compiled.zip "ZumaBlitzRemake.exe"
del compiled.zip
pause