Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

# Tạo form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Ping Test Controller"
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = "CenterScreen"

# Nút Start
$startButton = New-Object System.Windows.Forms.Button
$startButton.Location = New-Object System.Drawing.Point(100,30)
$startButton.Size = New-Object System.Drawing.Size(100,30)
$startButton.Text = "Start Ping"
$form.Controls.Add($startButton)

# Nút Stop
$stopButton = New-Object System.Windows.Forms.Button
$stopButton.Location = New-Object System.Drawing.Point(100,80)
$stopButton.Size = New-Object System.Drawing.Size(100,30)
$stopButton.Text = "Stop Ping"
$form.Controls.Add($stopButton)

# Đường dẫn Desktop
$desktopPath = [Environment]::GetFolderPath("Desktop")
$pingFile1 = "$desktopPath\ping-webrtc-zalopay.txt"
$pingFile2 = "$desktopPath\ping-vngzalopay-freshdesk.txt"

# Hàm Start Ping
$startButton.Add_Click({
    # Xóa file cũ nếu tồn tại
    if (Test-Path $pingFile1) { Remove-Item $pingFile1 -Force }
    if (Test-Path $pingFile2) { Remove-Item $pingFile2 -Force }

    # Lệnh ping 1
    $cmd1 = "ping -t webrtc-zalopay.dxws.io | cmd /q /v /c `"(pause&pause)>nul & for /l %a in (1,1,999999) do (set /p data= && echo(!date! !time! !data!)&ping -n 2 webrtc-zalopay.dxws.io>nul`" > `"$pingFile1`""
    # Lệnh ping 2 (delay 2s)
    $cmd2 = "timeout /t 2 >nul & ping -t vngzalopay.freshdesk.com | cmd /q /v /c `"(pause&pause)>nul & for /l %a in (1,1,999999) do (set /p data= && echo(!date! !time! !data!)&ping -n 2 vngzalopay.freshdesk.com>nul`" > `"$pingFile2`""

    # Chạy ẩn
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c $cmd1" -WindowStyle Hidden -NoNewWindow
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c $cmd2" -WindowStyle Hidden -NoNewWindow

    [System.Windows.Forms.MessageBox]::Show("Ping tests started. Results are being saved to Desktop.", "Info")
})

# Hàm Stop Ping
$stopButton.Add_Click({
    # Tắt các tiến trình cmd
    Stop-Process -Name "cmd" -Force -ErrorAction SilentlyContinue

    # Xóa file txt
    if (Test-Path $pingFile1) { Remove-Item $pingFile1 -Force }
    if (Test-Path $pingFile2) { Remove-Item $pingFile2 -Force }

    [System.Windows.Forms.MessageBox]::Show("Ping tests stopped and files deleted.", "Info")
})

# Hiển thị form
$form.ShowDialog()
