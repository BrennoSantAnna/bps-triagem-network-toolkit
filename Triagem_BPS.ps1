# ==============================================================================
# BPS Tech & Security - Utilitário de Triagem e Otimização de Sistemas
# Autor: Brenno Sant'Anna
# Descrição: Limpa arquivos temporários e coleta conexões de rede ativas.
# ==============================================================================

# 1. Definindo o diretório de saída (O próprio Cartão SD onde o script está rodando)
$ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$OutputFile = Join-Path $ScriptPath "..\01_Triagem_e_Analise\Log_Conexoes_Ativas.txt"

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "[-] Execute como Administrador para resultados completos." -ForegroundColor Red
    exit
}

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "     BPS TECH & SECURITY - FERRAMENTA DE TRIAGEM   " -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

# 2. Etapa de Triagem (Coleta de Conexões de Rede Ativas)
Write-Host "[*] Coletando conexoes de rede ativas (Auditoria de Portas)..." -ForegroundColor Yellow

# Cabeçalho do arquivo de Log
$Header = "==================================================`n" +
"LOG DE AUDITORIA DE REDE - BPS TECH & SECURITY`n" +
"Data/Hora da Coleta: $(Get-Date)`n" +
"==================================================`n"
$Header | Out-File -FilePath $OutputFile -Encoding utf8

# Coleta das conexões TCP estabelecidas ou em escuta (Listen)
Get-NetTCPConnection | Where-Object { $_.State -eq "Established" -or $_.State -eq "Listen" } | 
Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State,
    @{Name="ProcessName"; Expression={(Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue).ProcessName}},
    @{Name="ProcessPath"; Expression={(Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue).Path}} |
Out-File -FilePath $OutputFile -Append -Encoding utf8

Write-Host "[+] Triagem concluida! Relatorio salvo em: $OutputFile" -ForegroundColor Green
Write-Host ""

# 3. Etapa de Otimização (Limpeza de Temporários)
Write-Host "[*] Iniciando otimizacao do sistema (Limpeza)..." -ForegroundColor Yellow
$TempFolder = "C:\Windows\Temp\*"
try {
    Remove-Item $TempFolder -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "[+] Limpeza de arquivos temporarios concluida com sucesso." -ForegroundColor Green
}
catch {
    Write-Host "[-] Falha parcial ao limpar alguns arquivos em uso." -ForegroundColor Red
}

Write-Host ""
Write-Host "==================================================" -ForegroundColor Cyan
