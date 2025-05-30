Remove-Item Alias:rm -ErrorAction SilentlyContinue
Remove-Item Alias:ls -ErrorAction SilentlyContinue
Remove-Item alias:diff -Force
Remove-Item Alias:find -ErrorAction SilentlyContinue
# Config
Set-Alias vi nvim
Set-PSReadLineOption -Colors @{ InlinePrediction = "$([char]0x1b)[90m" }

# Stuff
$proj = "D:/Projects"

# Keybindings
Set-PSReadLineKeyHandler -Key Ctrl+a -Function BeginningOfLine
Set-PSReadLineKeyHandler -Key Ctrl+e -Function EndOfLine
Set-PSReadLineKeyHandler -Key Ctrl+k -Function KillLine
Set-PSReadLineKeyHandler -Key Ctrl+j -Function AcceptSuggestion

# Oh My Posh
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/amro.omp.json" | Invoke-Expression
Import-Module posh-git
