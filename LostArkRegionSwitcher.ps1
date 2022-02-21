# Lost Ark Region Switcher
# Description: With this script you can change the Lost Ark region without starting the game.
# (c) totedan 21.01.2022 v1.0
# freeware license.

Set-ExecutionPolicy Bypass -Scope CurrentUser -Force

$title = 'Lost Ark Region Switcher'
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


$file = ([Environment]::GetEnvironmentVariable("ProgramFiles(x86)")+"\Steam\steamapps\common\Lost Ark\EFGame\Config\UserOption.xml")

If (Test-Path $file) {

[XML]$xmldata = Get-Content $file

    If ($ShowRegion -eq $true) {

        $CurrentRegion = $xmlData.UserOption.SaveAccountOptionData.RegionID
        Write-Host ("**Info: WE = West Europe; CE = Central Europe; WA = North America West; EA = North America East; SA = South America**")
        Write-Host ("Your current region is **$CurrentRegion**")
        Write-Host ("If you want to change the region, please run the script again!")

    } else {

        @($xmlData.UserOption.SaveAccountOptionData.SelectNodes('//RegionID')) | %{$_.'#text'=($_.'#text' -replace $_.'#text',$NewRegionID)}
        $xmlData.Save($file)
        Write-Host ("Your new region is set to **$NewRegionID**")
        Write-Host ("Now you can launch Lost Ark via Steam. Have fun in Arkesia!")
    }

}