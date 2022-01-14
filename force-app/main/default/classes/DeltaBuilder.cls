Public class DeltaBuilder {
/*
Param(
#   [string]$giturl = $(throw "sourcesDirectory is null!"),
#   [string]$sourcebranch = $(throw "sourcebranch is null!"),
#   [string]$targetbranch = $(throw "targetbranch is null!"),
[string]$buildtype = $(throw "Build Type is null!")
)
function BuildDeltaStructure {
    Write-Host -ForegroundColor "Green" "****************************************"
    Write-Host -ForegroundColor "Green" "Starting build of delta structure......."
    $path = "./delta.txt"
    $drive = "./deploy-artifacts"
    New-Item -Path "./" -Name "deploy-artifacts" -ItemType "directory"
    #read line one by one
    ForEach($line in Get-Content -Path $path)
    {
        if ($line -Match "force-app"){
        $Fline = $line
        Write-Debug $Fline
    # get the file name
        $presult = $Fline.Substring(0, $Fline.LastIndexOf('/'))
        Write-Debug $presult
    #remove the file name from the path
        $result = $Fline.Trim($presult)
        Write-Debug $result
    #create the directory
        If(!(test-path $drive\$presult)){
            New-Item -Path $drive\$presult -ItemType Directory
        }
        else{
            Write-Debug "Directory already exist"
        }
    }
    else {
        Write-Debug "Delta build out of scope"
    }
    }
    Write-Host -ForegroundColor "Green" "Finishing build of delta structure......."
    Write-Host -ForegroundColor "Green" "****************************************"
}
function Copydeltafiles {
    Write-Host -ForegroundColor "Green" "***********************************"
    Write-Host -ForegroundColor "Green" "Starting Copy of delta files......."
    $path = "./delta.txt"
    $drive = "./deploy-artifacts"
    #read line one by one
    ForEach($line in Get-Content -Path $path)
    {
        if ($line -Match "force-app"){
        $sfline= $line
        #Write-Debug "Line is" $sfline
        $sftype = ($sfline -split "/")[3]
        #Write-Debug "Type is" $sftype
        switch ($sftype) {
            {($_ -Match "classes") -or ($_ -Match "contentassets") -or ($_ -Match "pages") -or ($_ -Match "triggers")} {
                Write-Debug "Entering Classes type Condition"
                $Fline = $line
                Write-Debug $Fline
            # get the file name
                $presult = $Fline.Substring(0, $Fline.LastIndexOf('/'))
                Write-Debug $presult
            #remove the file name from the path
                $result = $Fline.Trim($presult)
                Write-Debug $result
            #For Classes
                $linexml= -join($line,"-meta.xml")
            #create the directory
                if ($line -Match "-meta.xml"){
                Copy-Item -Path $line $drive\$presult}
                else {
                Copy-Item -Path $line $drive\$presult 
                Copy-Item -Path $linexml $drive\$presult}}
            {($_ -Match "aura") -or ($_ -Match "lwc")} {
                Write-Debug "Entering Aura and LWC Condition"
                $Fline = $line
                Write-Debug $Fline
            # get the file name
                $presult = $Fline.Substring(0, $Fline.LastIndexOf('/'))
                Write-Debug $presult
            #remove the file name from the path
                #$result = $Fline.Trim($presult)
                #Write-Host $result
            #create the directory
                    Copy-Item -Path $presult\* $drive\$presult -recurse}
            {($_ -Match "reports")} {
                Write-Debug "Entering Reports Condition"
                $Fline = $line
                Write-Debug $Fline
            # get the file name
                $presult = $Fline.Substring(0, $Fline.LastIndexOf('/'))
                $pfresult = $presult.Substring(0, $presult.LastIndexOf('/'))
                Write-Debug $presult
            #remove the file name from the path
            $folname = ($presult.Substring($presult.LastIndexOf('/'))).Trim('/')
            $finfolname= -join($folname,".reportFolder-meta.xml")
            #create the directory
                    Copy-Item -Path $line $drive\$presult
                    Copy-Item -Path $pfresult\$finfolname $drive\$pfresult}
            {($_ -Match "dashboards")} {
                Write-Debug "Entering Dashboards Condition"
                $Fline = $line
                Write-Debug $Fline
            # get the file name
                $presult = $Fline.Substring(0, $Fline.LastIndexOf('/'))
                $pfresult = $presult.Substring(0, $presult.LastIndexOf('/'))
                Write-Debug $presult
            #remove the file name from the path
            $folname = ($presult.Substring($presult.LastIndexOf('/'))).Trim('/')
            $finfolname= -join($folname,".dashboardFolder-meta.xml")
            #create the directory
                    Copy-Item -Path $line $drive\$presult
                    Copy-Item -Path $pfresult\$finfolname $drive\$pfresult}
            Default {
                Write-Debug "Entering Default Condition"
                $Fline = $line
                Write-Debug $Fline
            # get the file name
                $presult = $Fline.Substring(0, $Fline.LastIndexOf('/'))
                Write-Debug $presult
            #remove the file name from the path
                $result = $Fline.Trim($presult)
                Write-Debug $result
            #create the directory
                If(test-path $line){
                Copy-Item -Path $line $drive\$presult}
                else{Write-Debug "Artifact not found"}}
        }
    }
    else {
        Write-Debug "Delta build out of scope"
    }
    }
    Write-Host -ForegroundColor "Green" "Ending Copy of delta files......."
    Write-Host -ForegroundColor "Green" "***********************************"
    $wshell = New-Object -ComObject Wscript.Shell
    $wshell.Popup("Success: Delta Package built with name deploy-artifacts",0,"Done",0x40)
}
function gitactivity{
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

    $objForm = New-Object System.Windows.Forms.Form 
    $objForm.Text = "Delta Package Builder"
    $objForm.Size = New-Object System.Drawing.Size(320,400) 
    $objForm.StartPosition = "CenterScreen"

    $objForm.KeyPreview = $True
    $objForm.Add_KeyDown({
        if ($_.KeyCode -eq "Enter" -or $_.KeyCode -eq "Escape"){
            $objForm.Close()
        }
    })

    $OKButton = New-Object System.Windows.Forms.Button
    $OKButton.Location = New-Object System.Drawing.Size(75,250)
    $OKButton.Size = New-Object System.Drawing.Size(75,23)
    $OKButton.Text = "OK"
    $OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $OKButton.Add_Click({$objForm.Close()})
    $objForm.Controls.Add($OKButton)

    $CancelButton = New-Object System.Windows.Forms.Button
    $CancelButton.Location = New-Object System.Drawing.Size(150,250)
    $CancelButton.Size = New-Object System.Drawing.Size(75,23)
    $CancelButton.Text = "Cancel"
    $CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $CancelButton.Add_Click({$objForm.Close()})
    $objForm.Controls.Add($CancelButton)

    $objLabel = New-Object System.Windows.Forms.Label
    $objLabel.Location = New-Object System.Drawing.Size(10,20) 
    $objLabel.Size = New-Object System.Drawing.Size(350,40) 
    $objLabel.Text = "          Welcome to SFDX Delta Package Builder           "
    $objForm.Controls.Add($objLabel) 

    $objLabel = New-Object System.Windows.Forms.Label
    $objLabel.Location = New-Object System.Drawing.Size(10,60) 
    $objLabel.Size = New-Object System.Drawing.Size(280,20) 
    $objLabel.Text = "Enter GIT Repository URL:"
    $objForm.Controls.Add($objLabel)

    $giturl = New-Object System.Windows.Forms.TextBox 
    $giturl.Location = New-Object System.Drawing.Size(10,80) 
    $giturl.Size = New-Object System.Drawing.Size(260,20) 
    $objForm.Controls.Add($giturl) 

    $objLabel = New-Object System.Windows.Forms.Label
    $objLabel.Location = New-Object System.Drawing.Size(10,120) 
    $objLabel.Size = New-Object System.Drawing.Size(280,20) 
    $objLabel.Text = "Enter GIT Source Branch:"
    $objForm.Controls.Add($objLabel)
    $sourcebranch = New-Object System.Windows.Forms.TextBox 
    $sourcebranch.Location = New-Object System.Drawing.Size(10,140) 
    $sourcebranch.Size = New-Object System.Drawing.Size(260,20) 
    $objForm.Controls.Add($sourcebranch)

    $objLabel = New-Object System.Windows.Forms.Label
    $objLabel.Location = New-Object System.Drawing.Size(10,180) 
    $objLabel.Size = New-Object System.Drawing.Size(280,20) 
    $objLabel.Text = "Enter GIT Target Branch:"
    $objForm.Controls.Add($objLabel)
    $targetbranch = New-Object System.Windows.Forms.TextBox 
    $targetbranch.Location = New-Object System.Drawing.Size(10,200) 
    $targetbranch.Size = New-Object System.Drawing.Size(260,20) 
    $objForm.Controls.Add($targetbranch) 

    $objLabel = New-Object System.Windows.Forms.Label
    $objLabel.Location = New-Object System.Drawing.Size(10,340) 
    $objLabel.Size = New-Object System.Drawing.Size(280,20) 
    $objLabel.Text = "                             *Powered*                                "
    $objForm.Controls.Add($objLabel)

    $objForm.Topmost = $True

    $objForm.Add_Shown({$objForm.Activate()})
    $result = $objForm.ShowDialog()
    #Write-Host -ForegroundColor "Green" $result
    if (($giturl.Text) -and ($sourcebranch.Text) -and ($targetbranch.Text) -and ($result -eq "OK"))
    {
    Write-Host -ForegroundColor "Green" "GIT Repository URL: "$giturl.Text
    Write-Host -ForegroundColor "Green" "GIT Source Branch: "$sourcebranch.Text
    Write-Host -ForegroundColor "Green" "GIT Target Branch: "$targetbranch.Text

    Write-Host -ForegroundColor "Green" "*******************************************************"
    Write-Host -ForegroundColor "Green" "*                                                     *"
    Write-Host -ForegroundColor "Green" "*        *************************************        *"
    Write-Host -ForegroundColor "Green" "*        *SFDX:Delta Builder Tool*           *"
    Write-Host -ForegroundColor "Green" "*        *************************************        *"
    Write-Host -ForegroundColor "Green" "*                                                     *"
    Write-Host -ForegroundColor "Green" "*******************************************************"
    Write-Host -ForegroundColor "Green" "Starting GIT Activities......."
    $giturlclone = $giturl.Text
    $sourcebranchgit = $sourcebranch.Text
    $targetbranchgit = $targetbranch.Text
    Write-Host -ForegroundColor "Green" "Cloning GIT Repository"
    $commandClone = -join("git clone ",$giturlclone)
    iex $commandClone
    $commandPost = -join("cd Salesforce_SCE")
    iex $commandPost
    Write-Host -ForegroundColor "Green" "Checking out Target Branch"
    $commandCheckoutTarget = -join("git checkout ",$targetbranchgit)
    iex $commandCheckoutTarget
    Write-Host -ForegroundColor "Green" "Checking out Source Branch"
    $commandCheckoutSource = -join("git checkout ",$sourcebranchgit)
    iex $commandCheckoutSource
    Write-Host -ForegroundColor "Green" "Computing Delta between branches......."
    $commandClone = -join("git diff --name-only ",$targetbranchgit," 1>delta.txt 2>&1")
    iex $commandClone
    Write-Host -ForegroundColor "Green" "Ending GIT Activities......."
    Write-Host -ForegroundColor "Green" "***********************************"
    }
    elseif ($result -eq "Cancel"){
    $wshell = New-Object -ComObject Wscript.Shell
    $wshell.Popup("Exit the Tool",0,"Exit",0x20)
    exit
    }
    else {
    $wshell = New-Object -ComObject Wscript.Shell
    $wshell.Popup("Error: Please enter required inputs",0,"Error",0x40)
    exit
    }
}
    try {
        if ($buildtype -eq "Manual"){
        Write-Host -ForegroundColor "Green" "Manual Build Type Selected"
        gitactivity
        BuildDeltaStructure
        Copydeltafiles
        }
        elseif ($buildtype -eq "Automatic"){
        Write-Host -ForegroundColor "Green" "Automatic Build Type Selected"
        }else {
        $wshell = New-Object -ComObject Wscript.Shell
        $wshell.Popup("Error: Invalid Build Type",0,"Error",0x40)
        exit
        }
    }catch {
        Write-Host "##[error][$(get-date -Format 'dd/MM/yyyy HH:mm')] :: Error!"
        throw
    }
*/
}