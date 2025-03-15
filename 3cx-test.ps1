Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()


$form = New-Object System.Windows.Forms.Form
$form.Text = "Ping Test Controller"
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = "CenterScreen"


$startButton = New-Object System.Windows.Forms.Button
$startButton.Location = New-Object System.Drawing.Point(100,30)
$startButton.Size = New-Object System.Drawing.Size(100,30)
$startButton.Text = "Start Ping"
$form.Controls.Add($startButton)


$stopButton = New-Object System.Windows.Forms.Button
$stopButton.Location = New-Object System.Drawing.Point(100,80)
$stopButton.Size = New-Object System.Drawing.Size(100,30)
$stopButton.Text = "Stop Ping"
$form.Controls.Add($stopButton)


$desktopPath = [Environment]::GetFolderPath("Desktop")
$pingFile1 = "$desktopPath\ping-webrtc-zalopay.txt"
$pingFile2 = "$desktopPath\ping-vngzalopay-freshdesk.txt"


$startButton.Add_Click({

    $bat1 = @"
@echo off
ping -t webrtc-zalopay.dxws.io|cmd /q /v /c "(pause&pause)>nul & for /l %a in () do (set /p "data=" && echo(!date! !time! !data!)&ping -n 2 webrtc-zalopay.dxws.io>nul" >"$pingFile1"
"@
    $bat2 = @"
@echo off
timeout /t 2 >nul
ping -t vngzalopay.freshdesk.com|cmd /q /v /c "(pause&pause)>nul & for /l %a in () do (set /p "data=" && echo(!date! !time! !data!)&ping -n 2 vngzalopay.freshdesk.com>nul" >"$pingFile2"
"@

    Set-Content -Path "tempPing1.bat" -Value $bat1
    Set-Content -Path "tempPing2.bat" -Value $bat2

    # Chạy ẩn các lệnh
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c tempPing1.bat" -WindowStyle Hidden
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c tempPing2.bat" -WindowStyle Hidden

    [System.Windows.Forms.MessageBox]::Show("Ping tests started. Results are being saved to Desktop.", "Info")
})


$stopButton.Add_Click({

    Stop-Process -Name "cmd" -Force -ErrorAction SilentlyContinue


    if (Test-Path $pingFile1) { Remove-Item $pingFile1 -Force }
    if (Test-Path $pingFile2) { Remove-Item $pingFile2 -Force }
    if (Test-Path "tempPing1.bat") { Remove-Item "tempPing1.bat" -Force }
    if (Test-Path "tempPing2.bat") { Remove-Item "tempPing2.bat" -Force }

    [System.Windows.Forms.MessageBox]::Show("Ping tests stopped and files deleted.", "Info")
})


$form.ShowDialog()
