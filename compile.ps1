# 1. Setup Paths
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$RootDir = Split-Path -Parent $ScriptDir

$RaylibSrc = Join-Path $RootDir "raylib"
$ProjectDir = Join-Path $RootDir "Raylib.Bindings"

$RuntimeName = if ($IsWindows) { "win-x64" } elseif ($IsMacOS) { "osx-x64" } else { "linux-x64" }
$RuntimeDir = Join-Path $ProjectDir "runtimes/$RuntimeName/native"
$NativeBuildDir = Join-Path $ProjectDir "bin/native_build"

if (!(Test-Path $RuntimeDir)) { New-Item -ItemType Directory -Path $RuntimeDir -Force }

Write-Host "--- Starting Raylib Compilation ---" -ForegroundColor Cyan

# 2. Configure CMake
Write-Host "Configuring CMake..." -ForegroundColor Yellow
cmake -S $RaylibSrc -B $NativeBuildDir `
    -D BUILD_SHARED_LIBS=ON `
    -D BUILD_EXAMPLES=OFF `
    -D PLATFORM=RGFW `
    -D CMAKE_BUILD_TYPE=Debug

# 3. Build Raylib
Write-Host "Building Raylib Binary..." -ForegroundColor Yellow
cmake --build $NativeBuildDir --config Debug --parallel

# 4. Locate and Move the Library (Enhanced Detection)
Write-Host "Locating compiled binary..." -ForegroundColor Yellow

# Define potential names and subfolders based on your logs
$PossibleNames = @("raylib.dll", "libraylib.dll", "libraylib.so", "libraylib.dylib", "raylib.so", "raylib.dylib")
$PossibleFolders = @(
    "$NativeBuildDir/raylib",
    "$NativeBuildDir/raylib/Debug",
    "$NativeBuildDir/raylib/Release"
)

$DllSource = $null

foreach ($folder in $PossibleFolders) {
    foreach ($name in $PossibleNames) {
        $Path = Join-Path $folder $name
        if (Test-Path $Path) {
            $DllSource = $Path
            break
        }
    }
    if ($DllSource) { break }
}

if ($DllSource) {
    # We want the final file in our C# project to always be named 'raylib.dll' (or .so/.dylib)
    # to match our P/Invoke [LibraryImport("raylib")]
    $FinalName = if ($IsWindows) { "raylib.dll" } elseif ($IsMacOS) { "libraylib.dylib" } else { "libraylib.so" }
    $DllDest = Join-Path $RuntimeDir $FinalName

    Copy-Item -Path $DllSource -Destination $DllDest -Force
    Write-Host "SUCCESS: Found $DllSource" -ForegroundColor Gray
    Write-Host "SUCCESS: Moved to $DllDest" -ForegroundColor Green
}
else {
    Write-Error "FAILED: Could not find compiled library in $NativeBuildDir"
    exit
}

# 5. Build the C# Project
Write-Host "Building C# Project..." -ForegroundColor Yellow
dotnet build $ProjectDir /p:SkipLocalBuild=true
