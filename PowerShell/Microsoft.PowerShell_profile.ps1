function LL {
	Get-ChildItem | Select-Object -Property Name, Directory, Length, LastWriteTime | Sort-Object -Property LastWriteTime -Descending
}

# Alias Docker to Podman
function Docker {
	podman @args
}

function Test-GitRepository {
	$currentPath = Get-Location

	while ($null -ne $currentPath) {
		if (Test-Path (Join-Path $currentPath '.git')) {
			return $true
		}
		$currentPath = $currentPath.Parent
	}

	return $false
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

	$msg += "`n$PromptFG❯ $Reset"
	return $msg
}