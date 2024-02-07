function Make-Diff() {
	param(
		[Parameter(Mandatory)]
		[string] $ChangeList,

		[Parameter(Mandatory)]
		[string] $Issue,

		[string] $Dir
	)

	if($Dir -eq "") {
		$Dir = $Issue
	}

	$FilePath = "C:\Users\tberne\OneDrive\Documentos\Issues\$Dir\$Issue.diff"
	
	if(-not(Test-Path "C:\Users\tberne\OneDrive\Documentos\Issues\$Dir")) {
		New-Item -Type Directory -Path "C:\Users\tberne\OneDrive\Documentos\Issues\$Dir" | Out-Null
	}
	else {
		if(-not (Test-Path "C:\Users\tberne\OneDrive\Documentos\Issues\$Dir" -PathType Container)) {
			throw "ERRO! 'C:\Users\tberne\OneDrive\Documentos\Issues\$Dir' existe e nao e um diretorio!"
		}
	}

	Push-Location -Path C:\Lumis\trunk\svnroot\Lumis_PortalJava
	svn diff --cl $ChangeList > $FilePath
	Pop-Location

	Invoke-Item -Path "C:\Users\tberne\OneDrive\Documentos\Issues\$Dir"
}

function Mvn() {
	C:\Apps\apache-maven-3.9.6\bin\mvn.cmd @args
}

function Python2() {
	C:\Python27\python.exe @args
}

function Svn-Merge() {
	Python2 C:\Apps\svnmerge\svnmerge.py @args
}

function ll() {
	Get-ChildItem @args
}
