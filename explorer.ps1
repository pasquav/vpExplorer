# filepath: c:\temp\explorer.ps1
[void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
[void][System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')

# Criar formulário
$form = New-Object System.Windows.Forms.Form
$form.Text = "Acesso Remoto - Mapeamento de Unidade"
$form.Width = 400
$form.Height = 250
$form.StartPosition = "CenterScreen"
$form.Font = New-Object System.Drawing.Font("Arial", 10)

# Label e TextBox para Máquina
$labelMachine = New-Object System.Windows.Forms.Label
$labelMachine.Text = "Máquina (ex: TBLPC):"
$labelMachine.Location = New-Object System.Drawing.Point(10, 20)
$labelMachine.Width = 150

$textMachine = New-Object System.Windows.Forms.TextBox
$textMachine.Location = New-Object System.Drawing.Point(170, 20)
$textMachine.Width = 200
#checkbox para admin da maquina
$checkLocalAdmin = New-Object System.Windows.Forms.CheckBox
$checkLocalAdmin.Text = "Usar Administrador Local"
$checkLocalAdmin.Location = New-Object System.Drawing.Point(170, 55)
$checkLocalAdmin.Width = 200

# Label e TextBox para Usuário
$labelUser = New-Object System.Windows.Forms.Label
$labelUser.Text = "Usuário:"
$labelUser.Location = New-Object System.Drawing.Point(10, 80)
$labelUser.Width = 150

$textUser = New-Object System.Windows.Forms.TextBox
$textUser.Location = New-Object System.Drawing.Point(170, 80)
$textUser.Width = 200

# Preencher o campo de usuário com o nome do administrador local da máquina
$checkLocalAdmin.Add_CheckedChanged({
    if ($checkLocalAdmin.Checked) { 
        $textUser.Text = "$($textMachine.Text.Trim())\Administrador"
        $textUser.Enabled = $false
    }
    else {
        $textUser.Text = ""
        $textUser.Enabled = $true
    }
})


# Label e TextBox para Senha
$labelPassword = New-Object System.Windows.Forms.Label
$labelPassword.Text = "Senha:"
$labelPassword.Location = New-Object System.Drawing.Point(10, 100)
$labelPassword.Width = 150

$textPassword = New-Object System.Windows.Forms.TextBox
$textPassword.Location = New-Object System.Drawing.Point(170, 100)
$textPassword.Width = 200
$textPassword.UseSystemPasswordChar = $true

# Validação (validação de conexão antes de seguir para o próximo passo - linha 70)
function Test-MachineOnline {
    param([string]$Machine)

    try {
        $ping = New-Object System.Net.NetworkInformation.Ping
        $reply = $ping.Send($Machine,1000)

        return ($reply.Status -eq "Success")
    }
    catch {
        return $false
    }
}

# Botão Conectar
$buttonConnect = New-Object System.Windows.Forms.Button
$buttonConnect.Text = "Conectar"
$buttonConnect.Location = New-Object System.Drawing.Point(170, 150)
$buttonConnect.Width = 95

# Permitir pressionar Enter na senha para acionar o botão Conectar
$form.AcceptButton = $buttonConnect

$buttonConnect.Add_Click({

    $buttonConnect.Enabled = $false
    $form.Refresh()

    $machine = $textMachine.Text.Trim()
    $user = $textUser.Text.Trim()
    $password = $textPassword.Text

    if (-not $machine -or -not $user -or -not $password) {
        [System.Windows.Forms.MessageBox]::Show("Preenchimento obrigatório de todos os campos!", "Aviso")
        $buttonConnect.Enabled = $true
        return
    }

    if (-not (Test-MachineOnline $machine)) {
        [System.Windows.Forms.MessageBox]::Show("A máquina não está acessível na rede.", "Erro")
        $buttonConnect.Enabled = $true
        return
    }

    try {

        $securePassword = ConvertTo-SecureString $password -AsPlainText -Force
        $cred = New-Object System.Management.Automation.PSCredential ($user, $securePassword)
        
        $psDrive = New-PSDrive -Name MyRemoteDrive -PSProvider FileSystem -Root "\\$machine\C$" -Credential $cred -ErrorAction Stop
        
        [System.Windows.Forms.MessageBox]::Show("Conexão realizada com sucesso!", "Sucesso")
        
        # Abrir Explorer
        explorer.exe "\\$machine\C$"
        
        $form.Close()

    }
    catch {

        $msg = $_ | Out-String
        [System.Windows.Forms.MessageBox]::Show("Erro na conexão:`n$msg", "Erro")

        $buttonConnect.Enabled = $true
    }

})
# Botão Cancelar
$buttonCancel = New-Object System.Windows.Forms.Button
$buttonCancel.Text = "Cancelar"
$buttonCancel.Location = New-Object System.Drawing.Point(275, 150)
$buttonCancel.Width = 95
$buttonCancel.Add_Click({ $form.Close() })

# Adicionar controles
$form.Controls.Add($labelMachine)
$form.Controls.Add($textMachine)
$form.Controls.Add($checkLocalAdmin)
$form.Controls.Add($labelUser)
$form.Controls.Add($textUser)
$form.Controls.Add($labelPassword)
$form.Controls.Add($textPassword)
$form.Controls.Add($buttonConnect)
$form.Controls.Add($buttonCancel)

# Exibir formulário
[void]$form.ShowDialog()
