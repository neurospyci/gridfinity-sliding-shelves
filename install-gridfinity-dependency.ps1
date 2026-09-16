$ErrorActionPreference = 'Stop'

$revision = '910e22d8607fd7f5f51ad5e5cbc5287a76810bfd'
$libraryRoot = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'OpenSCAD\libraries'
$destination = Join-Path $libraryRoot 'gridfinity-rebuilt-openscad'
$requiredFile = Join-Path $destination 'src\core\bin.scad'

if (Test-Path -LiteralPath $requiredFile) {
    Write-Host "Gridfinity Rebuilt is already installed at $destination"
    exit 0
}
if (Test-Path -LiteralPath $destination) {
    throw "The destination exists but is incomplete: $destination. Move it aside and run this script again."
}

$temporary = Join-Path ([IO.Path]::GetTempPath()) ('gridfinity-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $temporary | Out-Null

try {
    $archive = Join-Path $temporary 'upstream.zip'
    $extracted = Join-Path $temporary 'extracted'
    Invoke-WebRequest -Uri "https://github.com/kennetek/gridfinity-rebuilt-openscad/archive/$revision.zip" -OutFile $archive
    Expand-Archive -LiteralPath $archive -DestinationPath $extracted
    $source = Get-ChildItem -LiteralPath $extracted -Directory | Where-Object {
        Test-Path -LiteralPath (Join-Path $_.FullName 'src\core\bin.scad')
    } | Select-Object -First 1
    if ($null -eq $source) {
        throw 'The downloaded archive does not contain the expected Gridfinity Rebuilt source files.'
    }
    New-Item -ItemType Directory -Path $libraryRoot -Force | Out-Null
    Move-Item -LiteralPath $source.FullName -Destination $destination
    Write-Host "Installed Gridfinity Rebuilt at $destination"
    Write-Host 'Reopen gridfinity-pin-drawers.scad in OpenSCAD.'
}
finally {
    Remove-Item -LiteralPath $temporary -Recurse -Force
}

