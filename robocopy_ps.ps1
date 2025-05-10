# Run as Administrator option
# Set-ExecutionPolicy RemoteSigned
Start-Process powershell -Verb runAs

# Load required assemblies to GUI
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()  

# Create a form object (canvas)
$Form = New-Object Windows.Forms.Form
$Form.Text = "Robocopy!"
$Form.BackColor="LightBlue"
$form.Size = New-Object System.Drawing.Size(650,400)  
$form.StartPosition = 'CenterScreen'  

# browse Func
Function Get-File ($InitialDirectory)  
{  
Add-Type -AssemblyName System.Windows.Forms  
$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog  
$OpenFileDialog.Title = "Please Select File"  
$OpenFileDialog.InitialDirectory = $InitialDirectory  
$OpenFileDialog.filter = "All files (*.*)|*.*"  
$openFileDialog.ShowHelp = $true  
If ($OpenFileDialog.ShowDialog() -eq "Cancel")  
{  
[System.Windows.Forms.MessageBox]::Show("No File Selected. Please select a file !", "Error", 0,  
[System.Windows.Forms.MessageBoxIcon]::Exclamation)  
}  
$Global:SelectedFile = $OpenFileDialog.FileName  
Return $SelectedFile   
}  

# Get-Folder Func
Function Get-Folder($initialDirectory="")
{
[System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null

$foldername = New-Object System.Windows.Forms.FolderBrowserDialog
$foldername.Description = "Please Select folder"
$foldername.rootfolder = "MyComputer"
$foldername.SelectedPath = $initialDirectory

if($foldername.ShowDialog() -eq "OK")
{
    $folder += $foldername.SelectedPath
}
return $folder
}

# Robocopy Func
Function RobocopyFunc ($x)  
{  
Add-Type -AssemblyName System.Windows.Forms  
$RobocopySource = $SourcePathTextBox.Text
$RobocopyDest = $DestPathTextBox.Text
$RobocopyOptions = "/E /J /ZB /MT"
$Robocopy_No_output =   "/NFL /NDL /NJH /NJS /nc /ns /np"
$Robocopy_quiet_output = "/NFL /NDL /NJH /nc /ns /np"
$RobocopyOutput = robocopy "$RobocopySource" "$RobocopyDest" /E /J /MT /Z   /NFL /NDL /NJH /nc /ns /np
$FuncOutput = "completed"
#$FuncOutput = "$RobocopyOutput"
Return $FuncOutput
}  

# CancelButton
$cancelButton = New-Object System.Windows.Forms.Button  
$cancelButton.Location = New-Object System.Drawing.Point(490,300)  
$cancelButton.Size = New-Object System.Drawing.Size(75,25)  
$cancelButton.Text = 'Cancel'  
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel  
$form.CancelButton = $cancelButton  
$form.Controls.Add($cancelButton)  

# Source
$Sourcelabel = New-Object System.Windows.Forms.Label  
$Sourcelabel.Location = New-Object System.Drawing.Point(10,50)  
$Sourcelabel.Size = New-Object System.Drawing.Size(120,25)  
$Sourcelabel.Text = 'Source file/folder:'  
$Sourcelabel.Font = New-Object System.Drawing.Font("Roboto",10)
$form.Controls.Add($Sourcelabel)  
  
$SourceTextBox = New-Object System.Windows.Forms.TextBox  
$SourceTextBox.Location = New-Object System.Drawing.Point(140,50)  
$SourceTextBox.Size = New-Object System.Drawing.Size(335,25)  
$SourceTextBox.ReadOnly = $true  
$SourceTextBox.Font = New-Object System.Drawing.Font("Roboto",10)
$form.Controls.Add($SourceTextBox)  

$SourcePathlabel = New-Object System.Windows.Forms.Label 
$SourcePathlabel.Location = New-Object System.Drawing.Point(10,75)  
$SourcePathlabel.Size = New-Object System.Drawing.Size(120,25)  
$SourcePathlabel.Text = 'full path:'  
$SourcePathlabel.Font = New-Object System.Drawing.Font("Roboto",10)
$form.Controls.Add($SourcePathlabel)  
  
$SourcePathTextBox = New-Object System.Windows.Forms.TextBox  
$SourcePathTextBox.Location = New-Object System.Drawing.Point(140,75)  
$SourcePathTextBox.Size = New-Object System.Drawing.Size(335,25)  
$SourcePathTextBox.Text = ''  
$SourcePathTextBox.AcceptsReturn = $true  
$SourcePathTextBox.ReadOnly = $true
$SourcePathTextBox.Font = New-Object System.Drawing.Font("Roboto",10)
$form.Controls.Add($SourcePathTextBox)

$SourceBrowse = New-Object System.Windows.Forms.Button  
$SourceBrowse.Location = New-Object System.Drawing.Point(500,50)  
$SourceBrowse.Size = New-Object System.Drawing.Size(100,25)  
$SourceBrowse.Text = 'Browse...'  
$SourceBrowse.Font = New-Object System.Drawing.Font("Roboto",10)
$SourceBrowse.add_click({$x = Get-Folder; $SourceTextBox.Text = $x|Split-Path -leaf; $SourcePathTextBox.Text=$x})    
$form.Controls.Add($SourceBrowse)  

# Dest
$Destlabel = New-Object System.Windows.Forms.Label  
$Destlabel.Location = New-Object System.Drawing.Point(10,150)  
$Destlabel.Size = New-Object System.Drawing.Size(120,25)  
$Destlabel.Text = 'Dest file/folder:'  
$Destlabel.Font = New-Object System.Drawing.Font("Roboto",10)
$form.Controls.Add($Destlabel)  
  
$DestTextBox = New-Object System.Windows.Forms.TextBox  
$DestTextBox.Location = New-Object System.Drawing.Point(140,150)  
$DestTextBox.Size = New-Object System.Drawing.Size(335,25)  
$DestTextBox.ReadOnly = $true
$DestTextBox.Font = New-Object System.Drawing.Font("Roboto",10)
$form.Controls.Add($DestTextBox)  

$DestPathlabel = New-Object System.Windows.Forms.Label  
$DestPathlabel.Location = New-Object System.Drawing.Point(10,175)  
$DestPathlabel.Size = New-Object System.Drawing.Size(120,25)  
$DestPathlabel.Text = 'full path:'  
$DestPathlabel.Font = New-Object System.Drawing.Font("Roboto",10)
$form.Controls.Add($DestPathlabel)  
  
$DestPathTextBox = New-Object System.Windows.Forms.TextBox  
$DestPathTextBox.Location = New-Object System.Drawing.Point(140,175)  
$DestPathTextBox.Size = New-Object System.Drawing.Size(335,25)  
$DestPathTextBox.Text = ''  
$DestPathTextBox.AcceptsReturn = $true  
$DestPathTextBox.ReadOnly = $true
$DestPathTextBox.Font = New-Object System.Drawing.Font("Roboto",10)
$form.Controls.Add($DestPathTextBox)

$DestBrowse = New-Object System.Windows.Forms.Button  
$DestBrowse.Location = New-Object System.Drawing.Point(500,150)  
$DestBrowse.Size = New-Object System.Drawing.Size(100,23)  
$DestBrowse.Text = 'Browse...'  
$DestBrowse.Font = New-Object System.Drawing.Font("Roboto",10)
$DestBrowse.add_click({$x = Get-Folder; $DestTextBox.Text = $x|Split-Path -leaf; $DestPathTextBox.Text=$x})    
$form.Controls.Add($DestBrowse)  

# robocopy header label:
$Robocopyheaderlabel = New-Object System.Windows.Forms.Label  
$Robocopyheaderlabel.Location = New-Object System.Drawing.Point(10,260)  
$Robocopyheaderlabel.Size = New-Object System.Drawing.Size(300,25)  
$Robocopyheaderlabel.Text = 'Robocopy:'  
$Robocopyheaderlabel.Font = New-Object System.Drawing.Font("Roboto",14)
$form.Controls.Add($Robocopyheaderlabel)  

# robocopy label:
$Robocopylabel = New-Object System.Windows.Forms.Label  
$Robocopylabel.Location = New-Object System.Drawing.Point(10,280)  
$Robocopylabel.Size = New-Object System.Drawing.Size(1000,300)  
$Robocopylabel.Text = 'Waiting for selection'  
$Robocopylabel.Font = New-Object System.Drawing.Font("Roboto",12)
$form.Controls.Add($Robocopylabel) 

# robocopy button:
$RobocopyButton = New-Object System.Windows.Forms.Button  
$RobocopyButton.Location = New-Object System.Drawing.Point(260,220)  
$RobocopyButton.Size = New-Object System.Drawing.Size(110,25)  
$RobocopyButton.Text = 'Robocopy!'  
#$RobocopyButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$RobocopyButton.Font = New-Object System.Drawing.Font("Roboto",12,[System.Drawing.FontStyle]::Bold)
#$RobocopyButton.add_click({$Robocopylabel.Text = "Robocopy: Activated..."; $x = RobocopyFunc; $Robocopylabel.Text = "$x"})    
$RobocopyButton.add_click({$Robocopylabel.Text = "Robocopy: Activated"; $x = RobocopyFunc; ;$Robocopylabel.Text = "$x"})    
$form.Controls.Add($RobocopyButton)  

# Activate the form
$form.Topmost = $true  
$Form.Add_Shown({$Form.Activate()})
$Form.ShowDialog()