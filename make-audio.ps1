$path = "C:\Users\arielle joy\OneDrive\Desktop\25th\music\our-song.wav"
$sampleRate = 22050
$duration = 8.0
$channels = 1
$bitsPerSample = 16
$blockAlign = $channels * ($bitsPerSample / 8)
$byteRate = $sampleRate * $blockAlign
$dataSize = [int]($sampleRate * $duration * $blockAlign)
$list = [System.Collections.Generic.List[byte]]::new()

foreach ($b in [System.Text.Encoding]::ASCII.GetBytes("RIFF")) { $list.Add($b) }
foreach ($b in [System.BitConverter]::GetBytes([System.Int32](36 + $dataSize))) { $list.Add($b) }
foreach ($b in [System.Text.Encoding]::ASCII.GetBytes("WAVE")) { $list.Add($b) }
foreach ($b in [System.Text.Encoding]::ASCII.GetBytes("fmt ")) { $list.Add($b) }
foreach ($b in [System.BitConverter]::GetBytes([System.Int32]16)) { $list.Add($b) }
foreach ($b in [System.BitConverter]::GetBytes([System.Int16]1)) { $list.Add($b) }
foreach ($b in [System.BitConverter]::GetBytes([System.Int16]$channels)) { $list.Add($b) }
foreach ($b in [System.BitConverter]::GetBytes([System.Int32]$sampleRate)) { $list.Add($b) }
foreach ($b in [System.BitConverter]::GetBytes([System.Int32]$byteRate)) { $list.Add($b) }
foreach ($b in [System.BitConverter]::GetBytes([System.Int16]$blockAlign)) { $list.Add($b) }
foreach ($b in [System.BitConverter]::GetBytes([System.Int16]$bitsPerSample)) { $list.Add($b) }
foreach ($b in [System.Text.Encoding]::ASCII.GetBytes("data")) { $list.Add($b) }
foreach ($b in [System.BitConverter]::GetBytes([System.Int32]$dataSize)) { $list.Add($b) }

for ($i = 0; $i -lt [int]($sampleRate * $duration); $i++) {
    $t = [double]$i / [double]$sampleRate
    $freq = 392 + 24 * [Math]::Sin(2 * [Math]::PI * 0.35 * $t)
    $env = [Math]::Min(1.0, $t / 0.3)
    if ($t -gt (8.0 - 0.3)) { $env = [Math]::Max(0.0, 1.0 - (($t - (8.0 - 0.3)) / 0.3)) }
    $sample = [int]([Int16]::MaxValue * 0.18 * $env * [Math]::Sin(2 * [Math]::PI * $freq * $t))
    foreach ($b in [System.BitConverter]::GetBytes([System.Int16]$sample)) { $list.Add($b) }
}

[System.IO.File]::WriteAllBytes($path, $list.ToArray())
Write-Output "created $path"
