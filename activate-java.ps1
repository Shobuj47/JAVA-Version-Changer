$scriptPath = $MyInvocation.MyCommand.Path 
$baseDir = Split-Path $scriptPath -Parent

$javaList = @()
$javaObj = "" | select version, path

function Find-Java-Versions{

	$exeList = Get-ChildItem -Path $baseDir -Filter java.exe -Recurse -ErrorAction SilentlyContinue -Force | % { $_.FullName }
	
	foreach ($exePath in $exeList){
		$javaVersion = (Get-Command $exePath | Select-Object -ExpandProperty Version).toString()
		$javaObj.version = $javaVersion
		$javaObj.path = $exePath
		
		$script:javaList += @([pscustomobject]@{version=$javaVersion;path=$exePath;})
	}
}



function Show-Menu {
    Write-Host "Select Your Java Version"
    write-host ""
	$i = 0 
	Write-Host "Id	|	Version		->	Path"
	Write-Host "--------------------------------------------"
    foreach ($javaApp in $script:javaList){
			Write-Host " $i	|	$($javaApp.version)	->	$($javaApp.path) "
			$i++
	}
    Write-Host "Q: Press 'Q' to quit."
}


function Select-Java {
	[int]$selection = Read-Host "Enter Selected Java Version Id"
}







Find-Java-Versions
Show-Menu
Select-Java
