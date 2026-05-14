$BeforeLocation = Get-Location
$GitTag = "6.0"

try {
    $RaylibFolder = './raylib'

    if (Test-Path -Path $RaylibFolder) {
        Set-Location $RaylibFolder
        git fetch origin
        git checkout $GitTag
        git pull origin
    }
    else {
        git clone https://github.com/raysan5/raylib.git
        Set-Location $RaylibFolder
        git checkout $GitTag
    }

    Write-Host "Raylib repository ready at $GitTag"
}
finally {
    Set-Location $BeforeLocation
}
