# 🛡️ BPS Triagem — Script de Auditoria de Rede e Otimização

Ferramenta em PowerShell desenvolvida pela **BPS Tech & Security** para triagem inicial de máquinas Windows: audita conexões de rede ativas antes de qualquer otimização do sistema.

## O que o script faz

1. **Verifica privilégio administrativo** — interrompe a execução se não estiver rodando como Administrador, evitando coleta parcial/incompleta sem aviso.
2. **Audita conexões de rede** — coleta todas as conexões TCP em estado `Established` (ativas) e `Listen` (portas expostas), já resolvendo o processo responsável (`ProcessName` e `ProcessPath`) por cada uma. Salva tudo num log com timestamp.
3. **Otimiza o sistema** — remove arquivos temporários (`C:\Windows\Temp`), **somente depois** que a auditoria de rede já foi salva em disco.

## Por que a ordem importa

A sequência **verificar permissão → coletar evidência → só então limpar** não é acidental. Em qualquer triagem real, agir antes de documentar corre o risco de apagar informação relevante (arquivos temporários podem conter rastro de execução ou payload) antes de ela ser analisada. Esse script segue a mesma lógica que se aplicaria numa resposta a incidente real.

## Como usar

```powershell
# Execute o PowerShell como Administrador, depois:
.\Triagem_BPS.ps1
```

O relatório é salvo automaticamente na pasta `01_Triagem_e_Analise`, um nível acima de onde o script está.

## Exemplo de saída

```
==================================================
LOG DE AUDITORIA DE REDE - BPS TECH & SECURITY
Data/Hora da Coleta: <timestamp>
==================================================

LocalAddress  LocalPort  RemoteAddress  RemotePort  State        ProcessName  ProcessPath
------------  ---------  -------------  ----------  -----        -----------  -----------
192.168.1.14  62599      34.223.124.45  443         Established  chrome       C:\...\chrome.exe
```

## Autor

**Brenno Sant'Anna** — Fundador, [BPS Tech & Security](https://linktr.ee/bpstechsecurity)
