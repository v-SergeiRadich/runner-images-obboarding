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

Write-Host "[DEBUG] Detected Docker version: $dockerVersion"
if ([version]$dockerVersion -ge [version]"29.2") {
    Write-Host "[DEBUG] Detected Docker version greater than or equal to 29.2, using new cli-plugins directory"
    $cliPluginsDir = "C:\Program Files\Docker\cli-plugins"
}
Write-Host "Installing Docker Compose v2 plugin"
New-Item -Path $cliPluginsDir -ItemType Directory
Invoke-DownloadWithRetry -Url $dockerComposev2Url -Path "$cliPluginsDir\docker-compose.exe"

Invoke-PesterTests -TestFile "Docker" -TestName "DockerCompose"
