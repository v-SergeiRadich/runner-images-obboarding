################################################################################
##  File:  Install-Docker-Compose.ps1
##  Desc:  Install Docker Compose.
################################################################################
Write-Host "Install-Package Docker-Compose v2"
$dockerVersion = (Get-ToolsetContent).docker.components.docker
$toolsetVersion = (Get-ToolsetContent).docker.components.compose
$composeVersion = (Get-GithubReleasesByVersion -Repo "docker/compose" -Version "${toolsetVersion}").version
$dockerComposev2Url = "https://github.com/docker/compose/releases/download/v${composeVersion}/docker-compose-windows-x86_64.exe"
$cliPluginsDir = "C:\ProgramData\docker\cli-plugins"
if (($dockerVersion -split ".")[0] -ge 29 -and ($dockerVersion -split ".")[1] -ge 2) {
    $cliPluginsDir = "C:\Program Files\Docker\cli-plugins"
}
Write-Host "Installing Docker Compose v2 plugin"
New-Item -Path $cliPluginsDir -ItemType Directory
Invoke-DownloadWithRetry -Url $dockerComposev2Url -Path "$cliPluginsDir\docker-compose.exe"

Invoke-PesterTests -TestFile "Docker" -TestName "DockerCompose"
