Add-Type -AssemblyName System.Drawing
$root = $PSScriptRoot
$resourceLog = Get-Content -Raw -Encoding UTF8 "$root/submission/resource_usage.txt"
$network = $resourceLog.Substring($resourceLog.IndexOf('$ ip -s link'))
$benchmark = Get-Content -Raw -Encoding UTF8 "$root/submission/benchmark-output.txt"
function Export-LogImage($fileName, $title, $body) {
    $lines = ($body.TrimEnd() -split "`n")
    $bitmap = New-Object System.Drawing.Bitmap(1500, (150 + 27 * $lines.Count))
    $canvas = [System.Drawing.Graphics]::FromImage($bitmap)
    $canvas.Clear([System.Drawing.Color]::FromArgb(18,24,34))
    $font = New-Object System.Drawing.Font('Consolas', 15)
    $heading = New-Object System.Drawing.Font('Segoe UI', 18, [System.Drawing.FontStyle]::Bold)
    $canvas.DrawString($title, $heading, [System.Drawing.Brushes]::LightSkyBlue, 28, 20)
    $canvas.DrawString('Rendered SSH transcript | Actual EC2 output | Not a desktop screenshot', $font, [System.Drawing.Brushes]::Silver, 28, 62)
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $canvas.DrawString($lines[$i].TrimEnd("`r"), $font, [System.Drawing.Brushes]::WhiteSmoke, 28, (115 + 27 * $i))
    }
    $bitmap.Save("$root/submission/screenshots/$fileName", [System.Drawing.Imaging.ImageFormat]::Png)
    $canvas.Dispose(); $bitmap.Dispose(); $font.Dispose(); $heading.Dispose()
}
Export-LogImage '04-network-log.png' 'Network | EC2 t3.small | 2026-10-04 09:24:34 UTC+7' $network
Export-LogImage '06-benchmark-log.png' 'LightGBM | EC2 t3.small | 2026-10-04 09:24:02 UTC+7' $benchmark
