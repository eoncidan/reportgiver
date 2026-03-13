# 📊 Report Giver

Uma ferramenta prática em **PowerShell** que gera uma Interface Gráfica (GUI) limpa para extração de relatórios de diagnóstico do Windows. Com um clique, você obtém logs essenciais sobre hardware, rede, bateria e integridade do sistema operacional, exportados nos formatos `.txt` e `.html`.

<img width="497" height="287" alt="image" src="https://github.com/user-attachments/assets/f5c397c5-c1e7-4149-a405-6f70d1e76311" />

## ✨ Destaques da Ferramenta
* **Interface Limpa:** O script oculta o console nativo do PowerShell em segundo plano, rodando apenas a interface gráfica.
* **Modo Claro/Escuro:** Alternância rápida de tema com um clique na barra superior.
* **Auto-Elevação:** Detecta automaticamente a falta de privilégios de Administrador e solicita elevação via UAC antes de executar.

## 📋 Relatórios Extraídos
Os arquivos gerados são salvos automaticamente na pasta: `Desktop\Relatorios`.

* **Desempenho:** Uso geral de CPU e RAM, listando os 10 processos ativos que mais consomem recursos.
* **Disco:** Espaço disponível, status S.M.A.R.T. das unidades e varredura lógica (Scan) em busca de erros no disco C:.
* **Sistema:** Status de segurança (Antivírus/EDR), últimos 5 patches do Windows Update, erros críticos recentes do Event Viewer (últimos 7 dias) e verificação de integridade do SO (DISM CheckHealth e SFC VerifyOnly).
* **Rede:** Adaptadores, detalhes completos de IP, Ping, resolução DNS, Tracert e relatório completo de rede sem fio (WLAN Report).
* **Bateria:** Saúde atual da bateria e relatório de eficiência de energia (ideal para notebooks).

## 🚀 Como Usar

A maneira mais fácil de testar a ferramenta é rodá-la diretamente via terminal. Abra o seu PowerShell e cole o comando abaixo:

```powershell
irm https://tinyurl.com/reportgiver | iex
```

## ⚙️ Requisitos
* **Sistema Operacional:** Windows 10 ou Windows 11.
* **PowerShell:** Versão 5.1 ou superior (nativo no Windows).
* **Privilégios:** Acesso de Administrador (O script conta com um sistema inteligente que detecta a falta de privilégios e solicita a elevação do UAC automaticamente).

## 📄 Licença

Este projeto está sob a licença [MIT](LICENSE) - sinta-se à vontade para usar, modificar e distribuir.
