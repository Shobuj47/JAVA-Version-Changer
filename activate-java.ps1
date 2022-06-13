$scriptPath = $MyInvocation.MyCommand.Path 
$baseDir = Split-Path $scriptPath -Parent

$javaList = @()
$javaObj = "" | select version, path

function Get-TimeStamp {
    return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
}



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
	if ($script:javaList.count -eq 0 ){
		Write-Host "$(Get-TimeStamp)	| No Java Found"
		Exit 1
	}
	Write-Host "$(Get-TimeStamp)	| Select Your Java Version `n`n"
	$i = 0 
	Write-Host "Id	|	Version		->	Path"
	Write-Host "--------------------------------------------"
    foreach ($javaApp in $script:javaList){
			Write-Host " $i	|	$($javaApp.version)	->	$($javaApp.path) "
			$i++
	}
    Write-Host "`nQ: Press 'Q' to quit. `n"
}


function Select-Java {
	[int]$selection = Read-Host "$(Get-TimeStamp)	| Enter Selected Java Version Id"
	if ( $selection -lt $script:javaList.Length -and $selection -ge 0 ){
		Write-Host "$(Get-TimeStamp)	| Selected Java Version $($script:javaList[$selection].version). Configuring ... "
	}else{
		Write-Host "$(Get-TimeStamp)	| Invalid Selection"
		Exit 1
	}
}







Find-Java-Versions
Show-Menu
Select-Java
