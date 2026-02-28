<#
.SYNOPSIS
    Report Giver
.DESCRIPTION
    Ferramenta para extração de relatórios do Windows.
.NOTES
    Versão: 1.0
#>

# Arquivo: /ReportGiver.ps1

# ELEVAÇÃO UAC
$Principal = [Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
if (-not $Principal.IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    # Se não for Admin, reinicia o script pedindo elevação (Tela Sim/Não do Windows).
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}
# UNBLOCK DO .PS1
Unblock-File -Path "$PSScriptRoot\ReportGiver.ps1"

# OCULTAR TERMINAL
$t = '[DllImport("user32.dll")] public static extern bool ShowWindow(int handle, int state);'
Add-Type -MemberDefinition $t -Name Api -Namespace Win32
$hwnd = (Get-Process -Id $PID).MainWindowHandle
[void][Win32.Api]::ShowWindow($hwnd, 0)

# ASSEMBLIES
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

# INTERFACE
$TemaEscuro = @{ Fundo = "#121212"; Texto = "#FFFFFF"; Barra = "#1F1F1F" }
$TemaClaro  = @{ Fundo = "#F9F9F9"; Texto = "#202020"; Barra = "#F3F3F3" }
$script:Cor = $TemaEscuro

$BackGUI = New-Object System.Windows.Forms.Form; $BackGUI.Size = New-Object System.Drawing.Size(600, 700); $BackGUI.BackColor = $script:Cor.Fundo; $BackGUI.ForeColor = $script:Cor.Fundo; $BackGUI.FormBorderStyle = 'None'; $BackGUI.MaximizeBox = $false
$BarGUI = New-Object System.Windows.Forms.Panel; $BarGUI.Height = 30; $BarGUI.Dock = "Top"; $BarGUI.BackColor = $script:Cor.Barra; $BackGUI.Controls.Add($BarGUI)
$TemaGUI = New-Object System.Windows.Forms.Button; $TemaGUI.Text = "⮻"; $TemaGUI.Size = New-Object System.Drawing.Size(35, 30); $TemaGUI.Dock = "Right"; $TemaGUI.ForeColor = $script:Cor.Texto; $TemaGUI.BackColor = $script:Cor.Barra; $TemaGUI.FlatStyle = "Flat"; $TemaGUI.FlatAppearance.BorderSize = 0; $TemaGUI.Cursor = [System.Windows.Forms.Cursors]::Hand; $BarGUI.Controls.Add($TemaGUI)
$CloseGUI = New-Object System.Windows.Forms.Button; $CloseGUI.Text = "X"; $CloseGUI.Size = New-Object System.Drawing.Size(35, 30); $CloseGUI.Dock = "Right"; $CloseGUI.FlatStyle = "Flat"; $CloseGUI.FlatAppearance.BorderSize = 0; $CloseGUI.ForeColor = $script:Cor.Texto; $CloseGUI.BackColor = $script:Cor.Barra; $CloseGUI.Add_Click({ $BackGUI.Close() }); $CloseGUI.Add_MouseEnter({ $CloseGUI.BackColor = [System.Drawing.Color]::Red }); $CloseGUI.Add_MouseLeave({ $CloseGUI.BackColor = $script:Cor.Barra }); $BarGUI.Controls.Add($CloseGUI)
$TituloGUI = New-Object System.Windows.Forms.Label; $TituloGUI.Text = "Report Giver"; $TituloGUI.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter; $TituloGUI.Dock = "Fill"; $TituloGUI.ForeColor = $script:Cor.Texto; $BarGUI.Controls.Add($TituloGUI)

# INTERFACE (FUNCS)
$TemaGUI.Add_Click({ if ($script:Cor -eq $TemaEscuro) { $script:Cor = $TemaClaro } else { $script:Cor = $TemaEscuro }; $BackGUI.BackColor = $script:Cor.Fundo; $BarGUI.BackColor = $script:Cor.Barra; $TituloGUI.ForeColor = $script:Cor.Texto; $TemaGUI.ForeColor = $script:Cor.Texto; $TemaGUI.BackColor = $script:Cor.Barra; $CloseGUI.ForeColor = $script:Cor.Texto; $CloseGUI.BackColor = $script:Cor.Barra })

$TituloGUI.Add_MouseDown({$script:isDragging = $true; $cursorPos = [System.Windows.Forms.Cursor]::Position; $script:dragOffset = New-Object System.Drawing.Point(($cursorPos.X - $BackGUI.Location.X), ($cursorPos.Y - $BackGUI.Location.Y))})
$TituloGUI.Add_MouseMove({if ($script:isDragging) { $cursorPos = [System.Windows.Forms.Cursor]::Position; $BackGUI.Location = New-Object System.Drawing.Point(($cursorPos.X - $script:dragOffset.X), ($cursorPos.Y - $script:dragOffset.Y))}})
$TituloGUI.Add_MouseUp({ $script:isDragging = $false })

# INICIADOR DA INTERFACE
$BackGUI.ShowDialog() | Out-Null




