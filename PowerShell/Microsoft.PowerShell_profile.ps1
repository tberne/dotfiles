function LL {
	Get-ChildItem | Select-Object -Property Name, Directory, Length, LastWriteTime | Sort-Object -Property LastWriteTime -Descending
}

function Test-GitRepository {
	$currentPath = Get-Location

	while ($null -ne $currentPath) {
		$gitFolder = Join-Path $currentPath '.git'
		$gitFolderExists = Test-Path $gitFolder
		if ($gitFolderExists) {
			return $true
		}

		$lastPath = $currentPath
		$currentPath = Join-Path -Resolve $currentPath '..'
		if ($currentPath -eq $lastPath) {
			break
		}
	}

	return $false
}

function Test-JSRoot {
	$currentPath = Get-Location

	if (Test-Path (Join-Path $currentPath 'package.json')) {
		return $true
	}

	return $false
}

function Test-DockerRoot {
	$currentPath = Get-Location

	if (Test-Path (Join-Path $currentPath 'Dockerfile')) {
		return $true
	}

	if (Test-Path (Join-Path $currentPath 'docker-compose.yml')) {
		return $true
	}

	return $false
}

function Test-JavaRoot {
	$currentPath = Get-Location

	if (Test-Path (Join-Path $currentPath 'pom.xml')) {
		return $true
	}

	if (Test-Path (Join-Path $currentPath 'build.gradle')) {
		return $true
	}

	return $false
}

function Get-JSBadge {
	if (Test-JSRoot) {
		$jsBadgeColor = switch (Test-Path (Join-Path (Get-Location) 'node_modules')) {
			$true { "11" } # Amarelo se node_modules existe
			$false { "196" } # Vermelho se node_modules não existe
		}
		$msg = Get-TagStr -tag "JS" -fgColor "0" -bgColor $jsBadgeColor -sepLeft "" -sepRight ""
		$msg += " "
		return $msg
		# return ""
	}
	return ""
}

function Get-DockerBadge {
	if (Test-DockerRoot) {
		$dockerBadgeColor = "15"
		# $dockerIcon = ""
		$dockerIcon = "🐋"

		$msg = Get-TagStr -tag "$dockerIcon " -fgColor "0" -bgColor $dockerBadgeColor -sepLeft "" -sepRight ""
		$msg += " "
		return $msg
	}
	return ""
}

function Get-JavaBadge {
	if (Test-JavaRoot) {
		$javaBadgeColor = "55"
		# $javaIcon = ""
		$javaIcon = "☕"

		$msg = Get-TagStr -tag "$javaIcon " -fgColor "0" -bgColor $javaBadgeColor -sepLeft "" -sepRight ""
		$msg += " "
		return $msg
	}
	return ""
}

function Get-TagStr {
	param(
		[string]$tag,
		[string]$fgColor,
		[string]$bgColor,
		[string]$sepLeft,
		[string]$sepRight
	)
	$esc = [char]27
	$Reset = "${esc}[0m"

	$FGToken = "${esc}[38;5"
	$BGToken = "${esc}[48;5"

	$fg = "$FGToken;${fgColor}m"
	$bg = "$BGToken;${bgColor}m"

	$sepFG = "$FGToken;${bgColor}m"

	return "$sepFG$sepLeft$fg$bg$tag$Reset$sepFG$sepRight$Reset"
}


function prompt {
	$esc = [char]27
	$Reset = "${esc}[0m"

	# Cores (ajuste para seu gosto)
	$PathFG = "15"
	$PathBG = "32"
	$GitFG = "0"
	$PromptFG = "${esc}[38;5;46m"
    
	$BlockSepR = "" # precise usar Nerd Font! Ou troque para >
	$BlockSepL = "" # precise usar Nerd Font! Ou troque para <
	$CircBlockSepR = "" # precise usar Nerd Font! Ou troque para >
	$CircBlockSepL = "" # precise usar Nerd Font! Ou troque para <

	$cwd = $(Get-Location)
	$msg = "`n"
	$msg += Get-TagStr -tag "📁 $cwd " -fgColor $PathFG -bgColor $PathBG -sepLeft "$CircBlockSepL" -sepRight "$CircBlockSepR"

	# GIT Info
	$isGit = Test-GitRepository
	if ($isGit) {
		$isGit = (git rev-parse --is-inside-work-tree 2>$null) -eq "true"
	}
	if ($isGit) {
		$branch = git rev-parse --abbrev-ref HEAD 2>$null
		$branchColor = switch -Wildcard ($branch) {
			"master" { "11" }
			"main" { "11" }
			"develop" { "11" }
			"feature/*" { "49" }
			"release/*" { "196" }
			Default { "250" }
		}

		$msg += " "
		$msg += Get-TagStr -tag "  $branch " -fgColor $GitFG -bgColor $branchColor -sepLeft $BlockSepL -sepRight $BlockSepR
	}

	$msg += "`n"
	$msg += Get-JSBadge
	$msg += Get-DockerBadge
	$msg += Get-JavaBadge
	$msg += "$PromptFG❯ $Reset"
	return $msg
}