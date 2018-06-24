Param([switch]$gui, [string]$sender)

function StartTV(){
    Switch($sender){
        "ZDF"{zdf}
        "ARD"{ard}
        "ONE"{one}
        "ZDFinfo"{zdfinfo}
    }
}

function zdf(){
    echo "Die Übertragung von $sender startet"
    streamlink "https://www.zdf.de/live-tv" 720p
}

function zdfinfo(){
    echo "Die Übertragung von $sender startet"
    streamlink "https://www.zdf.de/dokumentation/zdfinfo-doku/zdfinfo-live-beitrag-100.html" 3096k
}

function ard(){
    echo "Die Übertragung von $sender startet"
    streamlink "https://www.ardmediathek.de/tv/live?kanal=208" 4955k_alt2
}

function one(){
    echo "Die Übertragung von $sender startet"
    start "https://www.ardmediathek.de/tv/live?kanal=673348"
}


if (!(Get-Command streamlink -ErrorAction SilentlyContinue))
{
    echo "Streamlink was not found! Try installing it via pip..."
    if (!(Get-Command pip -ErrorAction SilentlyContinue)){
        echo "pip was not found... Please install pip first (you need python3!)"
    }else{
        do{
            $answer= Read-Host -Prompt "Should I install Streamlink? [y/n]"
        }
        until ($answer -eq "y" -or $answer -eq "n" -or $answer -eq "")
        if($answer -eq "y"){
            pip install streamlink
        }else{
            exit
        }
    }
}

StartTV

$date=Get-Date -UFormat %Y%m%d
$multisender=$false
if($date -eq 20180624){
    $sender="ARD"
}elseif($date -eq 20180625 -or $date -eq 20180627){
    $sender="ZDF"
    $multisender=$true
}elseif($date -eq 20180626 -or $date -eq 20180628){
    $sender="ARD"
    $multisender=$true
}
if($multisender){
    if($gui){
        Add-Type -AssemblyName System.Windows.Forms
        Add-Type -AssemblyName System.Drawing

        $form = New-Object System.Windows.Forms.Form
        $form.Text = 'Sender wählen'
        $form.Size = New-Object System.Drawing.Size(300,200)
        $form.StartPosition = 'CenterScreen'

        $OKButton = New-Object System.Windows.Forms.Button
        $OKButton.Location = New-Object System.Drawing.Point(40,10)
        $OKButton.Size = New-Object System.Drawing.Size(100,100)
        $OKButton.Text = 'OK'
        $OKButton.DialogResult = [System.Windows.Forms.DialogResult]::Yes
        $form.AcceptButton = $OKButton
        $form.Controls.Add($OKButton)

        $CancelButton = New-Object System.Windows.Forms.Button
        $CancelButton.Location = New-Object System.Drawing.Point(140,10)
        $CancelButton.Size = New-Object System.Drawing.Size(100,100)
        $CancelButton.Text = 'Cancel'
        $CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::No
        $form.AcceptButton = $CancelButton
        $form.Controls.Add($CancelButton)

        $form.Topmost = $true

        if($multisender -and $sender -eq "zdf"){
            $OKButton.Text = 'ZDF'
            $CancelButton.Text = 'ZDFinfo'
        }
         elseif($multisender -and $sender -eq "ard"){
                  $OKButton.Text = 'ARD'
            $CancelButton.Text = 'ONE'
        }
        $sender=""
        $result = $form.ShowDialog()
        if ($result -eq [System.Windows.Forms.DialogResult]::Yes)
        {
            $sender=$OKButton.Text
        }elseif($result -eq [System.Windows.Forms.DialogResult]::No){
            $sender=$CancelButton.Text
        }

    }else{
        if($multisender -and $sender -eq "zdf"){
            do{
            $sender= Read-Host -Prompt "Welcher Sender? [zdf/zdfinfo]"
            }
            until ($sender -eq "zdf" -or $sender -eq "zdfinfo" -or $sender -eq "")
        if($sender -eq ""){
            $sender="zdf"
            }
        }
        elseif($multisender -and $sender -eq "ard"){
            do{
            $sender= Read-Host -Prompt "Welcher Sender? [ard/one]"
            }
            until ($sender -eq "ard" -or $sender -eq "one" -or $sender -eq "")
            if($sender -eq ""){
            $sender="ard"
            }
        }
    }
}

StartTV
