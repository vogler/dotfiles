Rem Execute this in administrative shell!

Rem Was using scoop before, now choco & winget. Differences: https://www.bowmanjd.com/chocolatey-scoop-winget/
Rem Prefer winget since it's included with Windows and also lists/updates apps not installed via CLI.
Rem Use https://winget.run and https://community.chocolatey.org/packages to search for packages

Rem https://chocolatey.org/install
Rem The package manager for Windows
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

Rem https://chrisant996.github.io/clink/
Rem Bash's powerful command line editing in cmd.exe - Completions, Auto-Suggestions, Persistent History, Shortcuts, Alt-H to show key bindings
winget install -e --id chrisant996.Clink
Rem Installs a command to cmd.exe's autorun to start Clink
clink autorun install

Rem https://github.com/QL-Win/QuickLook
winget install -e --id QL-Win.QuickLook

Rem https://www.nirsoft.net/utils/wifi_channel_monitor.html - install failed due to wrong checksum
Rem choco install --ignore-checksums wifichannelmonitor

winget install LibreOffice

Rem https://github.com/astral-sh/uv Rust, fast Python package installer and resolver, `uv tool install lastversion`, `uvx lastversion`, replaces most other Python tools incl. Poetry, macOS: `uvx` -> `.cache/uv`, `uv tool install` -> `.local/{bin,share/uv/tools}`
winget install --id=astral-sh.uv  -e

Rem Upgrade
choco upgrade all
winget upgrade --all
