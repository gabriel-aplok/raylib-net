# Configuration for the generator
$config = "multi-file", "generate-file-scoped-namespaces", "generate-helper-types", "exclude-funcs-with-body", "latest-codegen"
$namespace = "Raylib.Bindings"
$outputFolder = "./Raylib.Bindings/Generated"

# Ensure output directory exists
if (!(Test-Path $outputFolder)) { New-Item -ItemType Directory -Path $outputFolder }

$headers = @(
    "./raylib/src/raylib.h",
    "./raylib/src/raymath.h",
    "./raylib/src/rlgl.h"
)

foreach ($header in $headers) {
    $fileName = [System.IO.Path]::GetFileNameWithoutExtension($header)
    $className = (Get-Culture).TextInfo.ToTitleCase($fileName)

    Write-Host "---- Generating bindings for: $header ----"

    ClangSharpPInvokeGenerator `
        -c $config `
        --file $header `
        --include-directory "./raylib/src" `
        -n $namespace `
        --methodClassName $className `
        --libraryPath "raylib" `
        -o $outputFolder
}
