# Arquivo: /ReportGiver.ps1
# Ferramenta para extração de relatórios do Windows.

# UNBLOCK DO .PS1
Unblock-File -Path "$PSScriptRoot\ReportGiver.ps1"

# ELEVAÇÃO UAC
$Principal = [Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
if (-not $Principal.IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    # Se não for Admin, reinicia o script pedindo elevação (Tela Sim/Não do Windows).
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# OCULTAR TERMINAL
$t = '[DllImport("user32.dll")] public static extern bool ShowWindow(int handle, int state);'
Add-Type -MemberDefinition $t -Name Api -Namespace Win32
$hwnd = (Get-Process -Id $PID).MainWindowHandle
[void][Win32.Api]::ShowWindow($hwnd, 0)

# ÍCONE
$AppIdCodigo = '[DllImport("shell32.dll")] public static extern int SetCurrentProcessExplicitAppUserModelID(string AppID);'
Add-Type -MemberDefinition $AppIdCodigo -Name AppIdHelper -Namespace Win32
[Win32.AppIdHelper]::SetCurrentProcessExplicitAppUserModelID("ReportGiver.App.1")

# ASSEMBLIES
Add-Type -AssemblyName System.Windows.Forms, System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

# INTERFACE
$TemaEscuro = @{ Fundo = "#121212"; Texto = "#FFFFFF"; Barra = "#1F1F1F" }
$TemaClaro  = @{ Fundo = "#F9F9F9"; Texto = "#202020"; Barra = "#F3F3F3" }
$script:Cor = $TemaEscuro

$BackGUI = New-Object System.Windows.Forms.Form; $BackGUI.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("$env:windir\ImmersiveControlPanel\SystemSettings.exe"); $BackGUI.Size = New-Object System.Drawing.Size(500, 290); $BackGUI.BackColor = $script:Cor.Fundo; $BackGUI.ForeColor = $script:Cor.Fundo; $BackGUI.FormBorderStyle = 'None'; $BackGUI.MaximizeBox = $false
$BarGUI = New-Object System.Windows.Forms.Panel; $BarGUI.Height = 30; $BarGUI.Dock = "Top"; $BarGUI.BackColor = $script:Cor.Barra; $BackGUI.Controls.Add($BarGUI)
$TemaGUI = New-Object System.Windows.Forms.Button; $TemaGUI.Text = "⮻"; $TemaGUI.Size = New-Object System.Drawing.Size(35, 30); $TemaGUI.Dock = "Right"; $TemaGUI.ForeColor = $script:Cor.Texto; $TemaGUI.BackColor = $script:Cor.Barra; $TemaGUI.FlatStyle = "Flat"; $TemaGUI.FlatAppearance.BorderSize = 0; $TemaGUI.Cursor = [System.Windows.Forms.Cursors]::Hand; $BarGUI.Controls.Add($TemaGUI)
$MinimGUI = New-Object System.Windows.Forms.Button; $MinimGUI.Text = "-"; $MinimGUI.Size = New-Object System.Drawing.Size(35, 30); $MinimGUI.Dock = "Right"; $MinimGUI.FlatStyle = "Flat"; $MinimGUI.FlatAppearance.BorderSize = 0; $MinimGUI.ForeColor = $script:Cor.Texto; $MinimGUI.BackColor = $script:Cor.Barra; $MinimGUI.Add_Click({ $BackGUI.WindowState = [System.Windows.Forms.FormWindowState]::Minimized }); $MinimGUI.Add_MouseEnter({ $MinimGUI.BackColor = $script:Cor.Fundo }); $MinimGUI.Add_MouseLeave({ $MinimGUI.BackColor = $script:Cor.Barra }); $BarGUI.Controls.Add($MinimGUI)
$CloseGUI = New-Object System.Windows.Forms.Button; $CloseGUI.Text = "X"; $CloseGUI.Size = New-Object System.Drawing.Size(35, 30); $CloseGUI.Dock = "Right"; $CloseGUI.FlatStyle = "Flat"; $CloseGUI.FlatAppearance.BorderSize = 0; $CloseGUI.ForeColor = $script:Cor.Texto; $CloseGUI.BackColor = $script:Cor.Barra; $CloseGUI.Add_Click({ $BackGUI.Close() }); $CloseGUI.Add_MouseEnter({ $CloseGUI.BackColor = [System.Drawing.Color]::Red }); $CloseGUI.Add_MouseLeave({ $CloseGUI.BackColor = $script:Cor.Barra }); $BarGUI.Controls.Add($CloseGUI)
$TituloGUI = New-Object System.Windows.Forms.Label; $TituloGUI.Text = "Report Giver"; $TituloGUI.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter; $TituloGUI.Dock = "Fill"; $TituloGUI.ForeColor = $script:Cor.Texto; $BarGUI.Controls.Add($TituloGUI)
$script:TerminalGUI = New-Object System.Windows.Forms.TextBox; $script:TerminalGUI.Location = New-Object System.Drawing.Point(140, 40); $script:TerminalGUI.Size = New-Object System.Drawing.Size(350, 240); $script:TerminalGUI.Multiline = $true; $script:TerminalGUI.ReadOnly = $true; $script:TerminalGUI.BackColor = "#000000"; $script:TerminalGUI.ForeColor = $script:Cor.Texto; $script:TerminalGUI.AppendText("  █▀▀█ █▀▀ █▀▀█ █▀▀█ █▀▀█ ▀▀█▀▀ `r`n"); $script:TerminalGUI.AppendText("  █▄▄▀ █▀▀ █  █ █  █ █▄▄▀   █   `r`n"); $script:TerminalGUI.AppendText("  ▀ ▀▀ ▀▀▀ █▀▀▀ ▀▀▀▀ ▀ ▀▀   ▀   `r`n"); $script:TerminalGUI.AppendText("  █▀▀█ ░▀░ █  █ █▀▀ █▀▀█         `r`n"); $script:TerminalGUI.AppendText("  █ ▄▄ ▀█▀ ▀▄▄▀ █▀▀ █▄▄▀         `r`n"); $script:TerminalGUI.AppendText("  █▄▄█ ▀▀▀  ▀▀  ▀▀▀ ▀ ▀▀         `r`n"); $script:TerminalGUI.AppendText(" ─────────────────────────────── `r`n"); $script:TerminalGUI.AppendText(" >> Report Giver iniciado, bem-vindo! `r`n"); $script:TerminalGUI.BorderStyle = "None"; $script:TerminalGUI.Font = New-Object System.Drawing.Font("Consolas", 9); $BackGUI.Controls.Add($script:TerminalGUI)

$script:ListaBotoes = @()
$script:ProximaPosicaoY = 40
function Add-Relatorio {
    param($RelNome, [ScriptBlock]$Func)
	$script:Relatorio = New-Object System.Windows.Forms.Button; $script:Relatorio.Size = New-Object System.Drawing.Size(120, 40); $script:Relatorio.Location = New-Object System.Drawing.Point(10, $script:ProximaPosicaoY); $script:Relatorio.Text = "$RelNome"; $script:Relatorio.Margin = New-Object System.Windows.Forms.Padding(0, 0, 0, 10); $script:Relatorio.BackColor = $script:Cor.Barra; $script:Relatorio.ForeColor = $script:Cor.Texto; $script:Relatorio.FlatStyle = "Flat"; $script:Relatorio.FlatAppearance.BorderSize = 0; $script:Relatorio.Cursor = [System.Windows.Forms.Cursors]::Hand; $script:Relatorio.Add_Click($Func); $script:ListaBotoes += $script:Relatorio; $BackGUI.Controls.Add($script:Relatorio); $script:ProximaPosicaoY += ($script:Relatorio.Height + 10)
}

function Txt-Terminal {
    param([string]$Mensagem)
    $Hora = Get-Date -Format "HH:mm:ss"
    $script:TerminalGUI.AppendText("[$Hora] $Mensagem`r`n")
    $script:TerminalGUI.ScrollToCaret()
    [System.Windows.Forms.Application]::DoEvents()
}

# Cria pasta de relatorios.
function Fol-Relatorios {
	$script:Relatorios = "$env:USERPROFILE\Desktop\Relatorios"
	if (!(Test-Path $script:Relatorios)) { New-Item -ItemType Directory -Path $script:Relatorios }
}

# Relatorio de desempenho do sistema.
function Rel-Desempenho {
	
	# Codigo do relatorio.
    Fol-Relatorios
	Txt-Terminal "Iniciando relatório!"	
    $Arquivo = "$script:Relatorios\Relatorio_Desempenho.txt"	
	Txt-Terminal "Obtendo informações de cpu e ram..."	
	"================ RELATÓRIO DE DESEMPENHO - $(Get-Date) ===" | Out-File $Arquivo	
    "================ USO GERAL (CPU E RAM) ================" | Out-File $Arquivo
    Get-CimInstance Win32_Processor | Select-Object @{Name="Uso de CPU (%)";Expression={$_.LoadPercentage}} | Format-List | Out-File $Arquivo -Append
    Get-CimInstance Win32_OperatingSystem | Select-Object @{Name="RAM Total(GB)";Expression={[math]::Round($_.TotalVisibleMemorySize/1MB,2)}}, @{Name="RAM Livre(GB)";Expression={[math]::Round($_.FreePhysicalMemory/1MB,2)}} | Format-Table -AutoSize | Out-File $Arquivo -Append
	Txt-Terminal "Obtendo processos ativos..."
    "================ PROCESSOS (10) ================" | Out-File $Arquivo -Append
    Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 Name, CPU, @{Name="RAM(MB)";Expression={[math]::Round($_.WorkingSet/1MB,2)}}, Id | Format-Table -AutoSize | Out-File $Arquivo -Append
	Txt-Terminal "Relatório finalizado!"
}

# Relatorio de integridade de disco.
function Rel-Disco {

	# Codigo do relatorio.
    Fol-Relatorios
	Txt-Terminal "Iniciando relatório!"	
    $Arquivo = "$script:Relatorios\Relatorio_Disco.txt"	
	Txt-Terminal "Obtendo informações de disco..."		
	"================ RELATÓRIO DE DISCO - $(Get-Date) ===" | Out-File $Arquivo	
    "================ ESPAÇO EM DISCO ================" | Out-File $Arquivo
    Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | Select-Object DeviceID, @{Name="Total(GB)";Expression={[math]::Round($_.Size/1GB,2)}}, @{Name="Livre(GB)";Expression={[math]::Round($_.FreeSpace/1GB,2)}}, @{Name="% Livre";Expression={[math]::Round(($_.FreeSpace/$_.Size)*100,2)}} | Format-Table -AutoSize | Out-File $Arquivo -Append
    "================ STATUS S.M.A.R.T. ================" | Out-File $Arquivo -Append
	Txt-Terminal "Obtendo status de disco..."		
    wmic diskdrive get model,status | Out-File $Arquivo -Append
    "================ ERROS LÓGICOS DE DISCO (SCAN) ================" | Out-File $Arquivo -Append
    Get-Volume -DriveLetter C | Repair-Volume -Scan | Out-File $Arquivo -Append
	Txt-Terminal "Relatório finalizado!"	
}

# Relatorio de status do sistema.
function Rel-Sistema {
	
	# Codigo do relatorio.
    Fol-Relatorios
	Txt-Terminal "Iniciando relatório!"	
	$Arquivo = "$script:Relatorios\Relatorio_Sistema.txt"
	"================ RELATÓRIO DE SISTEMA - $(Get-Date) ===" | Out-File $Arquivo	
    "================ STATUS DE SEGURANÇA (ANTIVÍRUS/EDR) ================" | Out-File $Arquivo
    Get-MpComputerStatus -ErrorAction SilentlyContinue | Select-Object AMServiceEnabled, AntivirusEnabled, IsTamperProtected, IoavProtectionEnabled, OnAccessProtectionEnabled, RealTimeProtectionEnabled, BehaviorMonitorEnabled, AntispywareEnabled | Format-List | Out-File $Arquivo -Append
    "================ WINDOWS UPDATE (ÚLTIMOS PATCHES) ================" | Out-File $Arquivo -Append
	Txt-Terminal "Obtendo informações de sistema..."	
    Get-HotFix | Sort-Object InstalledOn -Descending | Select-Object -First 5 HotFixID, Description, InstalledOn | Format-Table -AutoSize | Out-File $Arquivo -Append
    "================ EVENT VIEWER: ERROS CRÍTICOS (ÚLTIMOS 7 DIAS) ================" | Out-File $Arquivo -Append
    Get-WinEvent -FilterHashtable @{LogName='System','Application'; Level=1,2; StartTime=(Get-Date).AddDays(-7)} -ErrorAction SilentlyContinue | Select-Object TimeCreated, Id, ProviderName, Message -First 30 | Format-Table -AutoSize | Out-File $Arquivo -Append -Width 200
	Txt-Terminal "Realizando verificação de integridade (DISM)..."
    "================ INTEGRIDADE DO SO (DISM / SFC) ================" | Out-File $Arquivo -Append
    "Status DISM (CheckHealth):" | Out-File $Arquivo -Append
    DISM /Online /Cleanup-Image /CheckHealth | Out-File $Arquivo -Append
	Txt-Terminal "Realizando verificação de sistema (SFC)..."	
    "Status SFC (Apenas Verificacao):" | Out-File $Arquivo -Append
    sfc /verifyonly | Out-File $Arquivo -Append
	Txt-Terminal "Relatório finalizado!"	
}

# Relatorio teste, informacões de rede.
function Rel-Rede {
	
	# Codigo do relatorio.
	Fol-Relatorios
	Txt-Terminal "Iniciando relatório!"
	netsh wlan show wlanreport
	Move-Item -Path "C:\ProgramData\Microsoft\Windows\WlanReport\wlan-report-latest.html" -Destination "$script:Relatorios\Relatorio_WLAN.html" -Force
	Txt-Terminal "Extraindo wlanreport..."

    $Arquivo = "$script:Relatorios\Relatorio_Redes.txt" 
	"================ RELATÓRIO DE REDE - $(Get-Date) ===" | Out-File $Arquivo
	"================ ADAPTADORES DE REDE ================" | Out-File $Arquivo -Append
	Txt-Terminal "Escrevendo informações de rede..."	
	Get-NetAdapter -ErrorAction SilentlyContinue | Select-Object Name, InterfaceDescription, Status, MacAddress | Out-String | Out-File $Arquivo -Append
	"================ DETALHES DE IP ================" | Out-File $Arquivo -Append
	ipconfig /all | Out-String | Out-File $Arquivo -Append
	Txt-Terminal "Realizando ping..."	
    "================ PING E LATÊNCIA  ================" | Out-File $Arquivo -Append
	Test-Connection -ComputerName 8.8.8.8 -Count 4 -ErrorAction SilentlyContinue | Select-Object Address, ResponseTime | Format-List | Out-File $Arquivo -Append	
	Txt-Terminal "Realizando resolução de dns..."
	"================ RESOLUÇÃO DNS ================" | Out-File $Arquivo -Append
    Resolve-DnsName google.com -Type A -ErrorAction SilentlyContinue | Select-Object Name, IPAddress | Format-Table -AutoSize | Out-File $Arquivo -Append
	Txt-Terminal "Realizando tracert..."    
	"================ TRACERT ================" | Out-File $Arquivo -Append
	tracert.exe -d -h 15 8.8.8.8 | Out-File $Arquivo -Append
	tracert.exe -d -h 15 8.8.4.4 | Out-File $Arquivo -Append
	Txt-Terminal "Relatório finalizado!"	
}

# Relatorio de status da bateria.
function Rel-Bateria {
	# Codigo do relatorio.
	Fol-Relatorios
	Txt-Terminal "Iniciando relatório!"
	powercfg /batteryreport /output "$script:Relatorios\Saude_Bateria.html"
	Txt-Terminal "Extraindo informacoes de saude da bateria..."	
	powercfg /energy /output "$script:Relatorios\Eficiencia_Energia.html" /duration 5
	Txt-Terminal "Relatório finalizado!"	
}

# Traz a lista de relatorios.
function Gerar-Relatorios {
Add-Relatorio -RelNome "Desempenho" -Func {Rel-Desempenho}
Add-Relatorio -RelNome "Disco" -Func {Rel-Disco}
Add-Relatorio -RelNome "Sistema" -Func {Rel-Sistema}
Add-Relatorio -RelNome "Rede" -Func {Rel-Rede}
Add-Relatorio -RelNome "Bateria" -Func {Rel-Bateria}
}
Gerar-Relatorios

# INTERFACE (FUNCS)
$TemaGUI.Add_Click({ if ($script:Cor -eq $TemaEscuro) { $script:Cor = $TemaClaro } else { $script:Cor = $TemaEscuro }; $BackGUI.BackColor = $script:Cor.Fundo; $BarGUI.BackColor = $script:Cor.Barra; $TituloGUI.ForeColor = $script:Cor.Texto; $TemaGUI.ForeColor = $script:Cor.Texto; $TemaGUI.BackColor = $script:Cor.Barra; $CloseGUI.ForeColor = $script:Cor.Texto; $CloseGUI.BackColor = $script:Cor.Barra; foreach ($Btn in $script:ListaBotoes) { $Btn.BackColor = $script:Cor.Barra; $Btn.ForeColor = $script:Cor.Texto}})
$TituloGUI.Add_MouseDown({$script:isDragging = $true; $cursorPos = [System.Windows.Forms.Cursor]::Position; $script:dragOffset = New-Object System.Drawing.Point(($cursorPos.X - $BackGUI.Location.X), ($cursorPos.Y - $BackGUI.Location.Y))})
$TituloGUI.Add_MouseMove({if ($script:isDragging) { $cursorPos = [System.Windows.Forms.Cursor]::Position; $BackGUI.Location = New-Object System.Drawing.Point(($cursorPos.X - $script:dragOffset.X), ($cursorPos.Y - $script:dragOffset.Y))}})
$TituloGUI.Add_MouseUp({ $script:isDragging = $false })

# INICIADOR DA INTERFACE
$BackGUI.ShowDialog() | Out-Null



