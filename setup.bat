Rem Execute this in administrative shell!

Rem https://chocolatey.org/install
Rem The package manager for Windows
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

Rem http://mridgers.github.io/clink/
Rem Powerful Bash-style command line editing for cmd.exe
choco install clink
Rem Installs a command to cmd.exe's autorun to start Clink
clink autorun install
