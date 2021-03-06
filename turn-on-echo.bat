::=================================================
:: Turn on echo to debug and locate problems.
:: Basically, Replace "echo off" to "echo on":
:: msr -rp directory1,file1 -f "\.(bat|cmd)$" -it "^(\s*@\s*echo)\s+off\b" -o "$1 on" -R
::=================================================
@echo off
SetLocal EnableExtensions EnableDelayedExpansion

where msr.exe 2>nul >nul || if not exist %~dp0\msr.exe powershell -Command "Invoke-WebRequest -Uri https://github.com/qualiu/msr/blob/master/tools/msr.exe?raw=true -OutFile %~dp0\msr.exe"
where msr.exe 2>nul >nul || set "PATH=%PATH%;%~dp0"

@if "%~1" == "" (
    echo Usage  : %~n0 Files_Directories [msr_Options: Optional]   | msr -aPA -e "%~n0\s+(\S+).*"
    echo Example: %~n0 "directory1,file1,file2"        | msr -aPA -e "%~n0\s+(\S+).*"
    echo Example: %~n0 "directory1,file1,file2" -R     | msr -aPA -e "%~n0\s+(\S+).*"
    echo Example: %~n0 "directory1,file1,file2" -r     | msr -aPA -e "%~n0\s+(\S+).*"
    echo Example: %~n0 "directory1,file1,file2" -r -R  | msr -aPA -e "%~n0\s+(\S+).*"
    echo Example: %~n0 "directory1,file1,file2" --nd "^(softwares|logs|data|target|bin|obj|Debug|Release)$" -r -R    | msr -aPA -e "%~n0\s+(\S+).*"
    echo Use -r to recursively search or replace; Use -R to replace, preview without -R. | msr -aPA -t "-\w\b" -e .+
    echo Should not use -p as occuppied. | msr -PA -t "-\S+|(\w+)"
    echo It just calls: msr -rp directory1,file1 -f "\.(bat|cmd)$" -it "^(\s*@\s*echo)\s+off\b" -o "$1 on" -R | msr -aPA -e "msr (-rp \S+).*" -t "\s+-[rp]+\s+|\s+(-\w+)\s+"
    exit /b -1
)



:: first argument must be the path, just like above examples.
msr -f "\.(bat|cmd)$" -it "^(\s*@\s*echo)\s+off\b" -o "$1 on" -p %*
