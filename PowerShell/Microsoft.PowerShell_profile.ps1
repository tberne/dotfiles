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
	
	Push-Location -Path C:\Lumis\trunk\svnroot\Lumis_PortalJava
	svn diff --cl $ChangeList > $FilePath
	Pop-Location
}

function Mvn() {
	C:\Apps\apache-maven-3.9.6\bin\mvn.cmd $args
}