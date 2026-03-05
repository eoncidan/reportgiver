# 📊 Report Giver

Uma ferramenta prática em **PowerShell** que gera uma Interface Gráfica (GUI) para extração automatizada de relatórios detalhados de diagnóstico do Windows. Com um clique, você obtém logs essenciais sobre hardware, rede, bateria e integridade do sistema operacional, exportados nos formatos `.txt` e `.html`.

## 🖼️ Interface

<img width="497" height="287" alt="image" src="https://github.com/user-attachments/assets/d059228c-71ef-4fdc-9c01-b06ec2a7a20e" />

## 📋 Relatórios Extraídos
Os arquivos gerados são salvos automaticamente na pasta: `Desktop\Relatorios`.

* **Desempenho:** Uso geral de CPU e RAM, além de listar os 10 processos que mais consomem recursos.
* **Disco:** Espaço disponível, status S.M.A.R.T. dos discos e varredura lógica em busca de erros.
* **Sistema:** Status do antivírus/segurança, últimos patches instalados (Windows Update), erros críticos recentes do Event Viewer e integridade do SO (via DISM e SFC).
* **Rede:** Adaptadores, detalhes de IP, Ping, resolução DNS, Tracert e relatórios completos de rede sem fio (WLAN report).
* **Bateria:** Saúde atual da bateria e um relatório de eficiência de energia (ideal para notebooks).

## 🚀 Como Usar

1. **Faça o download** do arquivo `ReportGiver.ps1` deste repositório.
2. **Execute o script:** * Clique com o botão direito no arquivo e selecione **"Executar com o PowerShell"**.
   * *Alternativamente:* Abra o terminal, navegue até a pasta do arquivo e digite `.\ReportGiver.ps1`.
3. **Aceite a elevação de privilégio** (Janela de Sim/Não do Windows), caso solicitada.
4. Na interface do Report Giver, **clique no botão** correspondente ao relatório que deseja gerar.
5. Acompanhe o progresso pelo terminal integrado na interface. Quando finalizado, acesse sua **Área de Trabalho > Relatorios** para visualizar os arquivos!

## ⚙️ Requisitos
* **Sistema Operacional:** Windows 10 ou Windows 11.
* **PowerShell:** Versão 5.1 ou superior (nativo no Windows).
* **Privilégios:** Acesso de Administrador (O script conta com um sistema inteligente que detecta a falta de privilégios e solicita a elevação do UAC automaticamente).

## 📄 Licença

Este projeto está sob a licença [MIT](LICENSE) - sinta-se à vontade para usar, modificar e distribuir.
