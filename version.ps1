$headerPath = "./raylib/src/raylib.h"
$content = Get-Content $headerPath

$major = ($content | Select-String -Pattern '#define RAYLIB_VERSION_MAJOR\s+(\d+)').Matches.Groups[1].Value
$minor = ($content | Select-String -Pattern '#define RAYLIB_VERSION_MINOR\s+(\d+)').Matches.Groups[1].Value
$patch = ($content | Select-String -Pattern '#define RAYLIB_VERSION_PATCH\s+(\d+)').Matches.Groups[1].Value

$versionFile = @"
namespace Raylib.Bindings;

public static partial class Raylib
{
    public static readonly Version Version = new(${major}, ${minor}, ${patch});
}
"@

Out-File -FilePath "./Raylib.Bindings/Raylib.Version.cs" -InputObject $versionFile -Encoding UTF8
Write-Host "Set Raylib Version to $major.$minor.$patch"