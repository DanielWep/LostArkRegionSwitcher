# Lost Ark Region Switcher
# Description: With this script you can change the Lost Ark region without starting the game.
# (c) totedan 23.02.2022 v1.0.5
# freeware license.

Set-ExecutionPolicy Bypass -Scope CurrentUser -Force

Write-Host ("Lost Ark Region Switcher!") -ForegroundColor Blue
If (!(Test-Path $env:TEMP\lostarkregionswitcher.ini)) {
    Write-Host ("Please select the Steam installation path, e.g. 'C:\Program Files (x86)\Steam'")
    Add-Type -AssemblyName System.Windows.Forms
    $browser = New-Object System.Windows.Forms.FolderBrowserDialog
    $null = $browser.ShowDialog()
    $steampath = $browser.SelectedPath
    $steampath | Out-File ("$env:TEMP\lostarkregionswitcher.ini")
} else {
$steampath = Get-Content ("$env:TEMP\lostarkregionswitcher.ini")
}
$file = ($steampath+"\steamapps\common\Lost Ark\EFGame\Config\UserOption.xml")
    If (Test-Path $file) {
    Copy-Item $file -Destination ($env:TEMP+"\UserOption_"+(get-date).ToString(‘yyyy-mm-dd-h-ss’)+".xml")
    Write-Verbose ("Backup was created in the user temp file")
    [XML]$xmldata = Get-Content $file
    $message = 'In which region would you like to launch Lost Ark?'
    $we = New-Object System.Management.Automation.Host.ChoiceDescription '&West Europe', 'Region: West Europe'
    $ce = New-Object System.Management.Automation.Host.ChoiceDescription '&Central Europe', 'Region: Central Europe'
    $wa = New-Object System.Management.Automation.Host.ChoiceDescription '&North America West', 'Region: North America West'
    $ea = New-Object System.Management.Automation.Host.ChoiceDescription 'North America &East', 'Region: North America East'
    $sa = New-Object System.Management.Automation.Host.ChoiceDescription '&South America', 'Region: South America'
    $current = New-Object System.Management.Automation.Host.ChoiceDescription 'Current &Region', 'Shows the current region'
    $options = [System.Management.Automation.Host.ChoiceDescription[]]($we, $ce, $wa, $ea, $sa, $current)
    $result = $host.ui.PromptForChoice($title, $message, $options,5)
    switch ($result) {
            0 { $NewRegionID = "WE" }
            1 { $NewRegionID = "CE" }
            2 { $NewRegionID = "WA" }
            3 { $NewRegionID = "EA" }
            4 { $NewRegionID = "SA" }
            5 { $ShowRegion = $true }
        }
        If ($ShowRegion -eq $true) {

            $CurrentRegion = $xmlData.UserOption.SaveAccountOptionData.RegionID
            Write-Host ("**Info: WE = West Europe; CE = Central Europe; WA = North America West; EA = North America East; SA = South America**")
            Write-Host ("Your current region is **$CurrentRegion**") -ForegroundColor Green
            Write-Host ("If you want to change the region, please run the script again!") -ForegroundColor Green
        } else {

            @($xmlData.UserOption.SaveAccountOptionData.SelectNodes('//RegionID')) | %{$_.'#text'=($_.'#text' -replace $_.'#text',$NewRegionID)}
            $xmlData.Save($file)
            Write-Host ("Your new region is set to **$NewRegionID**") -ForegroundColor Green
            Write-Host ("Now you can launch Lost Ark via Steam. Have fun in Arkesia!") -ForegroundColor Green
        }
    } else {
        Write-Host ("Something went wrong. We could not found the Lost Ark user data.") -ForegroundColor Red
        Write-Host ("Please run the script again and select the correct Steam installation path!!") -ForegroundColor Red
        Remove-Item ("$env:TEMP\lostarkregionswitcher.ini")
    }
pause