# vpExplorer
Repositório com a ferramenta VPExplorer que permite realizar conexões SMB diretamente da interface que ela cria para facilitar a vida do suporte.  

Para rodar a ferramenta temos algumas formas e ajustes.
Caso seu sistema utilize admins locais devemos definir ou o nome Administrador ou Administrator na linha 41, no final.

Para criar um executável com ícone personalizado e que não exiba o console ao iniciar, podemos usar o software ps2exe disponível no Windows com a seguinte sintaxe:
ps2exe.ps1 -inputFile C:\temp\explorer.ps1 -outputFile C:\temp\vpExplorer1.exe -noConsole -iconFile C:\temp\favicon.ico
Onde temos as seguintes variáveis definidas:
  -inputFile (Nosso script em ps1)
  -outputFile (Caminho onde iremos salvar o executável)
  -noConsole (Não apresenta a console na execução)
  -iconFile (O caminho onde temos a imagem .ico deve ser definido, assim como o ícone do nosso executável.)

Com essas alterações iremos obter um programa que valida previamente se a máquina está conectada na rede e ligada, caso não esteja ele irá retornar um erro ao usuário, permitindo assim que o mesmo possa selecionar outra máquina para acessar. Caso ela esteja conectada ele mostra uma mensagem de "Conexão realizada com sucesso!" e assim que o usuário clicar no botão irá abrir o explorer com o mapeamento realizado.

#vpExplorer
Repository with the VPExplorer tool that allows you to make SMB connections directly from the interface it creates to make life easier for support staff.

To run this tool we need to make some adjustments.
In case your system use local admins, we must set or the name Administrador or Administrator in the line number 41, in the end.

To create an executable with icon personalization and doesn't show the console when it initiate we can use the software ps2exe available in the windows with the sintaxe below.
ps2exe.ps1 -inputFile C:\temp\explorer.ps1 -outputFile C:\temp\vpExplorer1.exe -noConsole -iconFile C:\temp\favicon.ico
Where we have the followed variables defined:
  -inputFile (Our script in ps1)
  -outputFile (Path where we will save the executable)
  -noConsole (Doesn't show the console in execution)
  -iconFile (Path where we have the image .ico to must be defined such a icon of our executable)
