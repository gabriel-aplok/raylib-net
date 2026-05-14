Write-Host "--- Starting Raylib Binding Generation ---"

./init.ps1

Write-Host "--- Generating Bindings ---"
./generate.ps1

Write-Host "--- Updating Version Metadata ---"
./version.ps1

Write-Host "--- Done! ---"
