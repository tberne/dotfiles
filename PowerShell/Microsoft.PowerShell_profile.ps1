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

function prompt {
	$esc = [char]27
	$Reset = "${esc}[0m"

	# Cores (ajuste para seu gosto)
	$PathBG = "${esc}[48;5;32m"   # Verde escuro de fundo
	$PathFG = "${esc}[38;5;231m"  # Branco para texto
	$GitBG = "${esc}[48;5;52m"  # Rosa de fundo
	$GitFG = "${esc}[38;5;15m"  # Amarelo para git branch
	$ArrowFG = "${esc}[38;5;32m"   # Verde para setas
	$PromptFG = "${esc}[38;5;46m"   # Verde limão para ">"
	$GitArrowFG = "${esc}[38;5;52m" # Rosa para setas do git
    
	$BlockSepL = "" # precise usar Nerd Font! Ou troque para >
	$BlockSepR = "" # precise usar Nerd Font! Ou troque para <
	$CircBlockSepL = "" # precise usar Nerd Font! Ou troque para >
	$CircBlockSepR = "" # precise usar Nerd Font! Ou troque para <

	$cwd = $(Get-Location)
	# $msg = "`n$PathBG$PathFG 📁 $cwd $Reset$ArrowFG$BlockSepL$Reset"
	$msg = "`n$ArrowFG$CircBlockSepR$Reset$PathBG$PathFG📁 $cwd $Reset$ArrowFG$CircBlockSepL$Reset"

	# GIT Info
	$isGit = Test-GitRepository
	if ($isGit) {
		$isGit = (git rev-parse --is-inside-work-tree 2>$null) -eq "true"
	}
	if ($isGit) {
		$branch = git rev-parse --abbrev-ref HEAD 2>$null
		$msg += " $GitArrowFG$BlockSepR$GitBG$GitFG  $branch $Reset$GitArrowFG$BlockSepL$Reset"
	}

	$msg += "`n$PromptFG❯ $Reset"
	return $msg
}