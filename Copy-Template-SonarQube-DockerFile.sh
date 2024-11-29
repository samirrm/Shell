#!/bin/bash
#---
#Copy Template SonarQube DockerFile

#--- Removendo pasta caso exista
rm -rf ./SonarQube

#--- Utilizamos o git clone para realizar o download dos arquivos do SonarQube
git clone -b fix/restore 'https://$(userName):$(AccessToken)@<dominio>.visualstudio.com/<area-projeto>/_git/<repo>'

#--- Condicional para realizar teste unitario
if [ "$(executarTeste)" = "true" ]; then
     #--- Copia da pasta SonarQube com NUGET para a raiz do repositório original
      mv ./<repo>/dotnet/com-teste/SonarQube .
else
    #--- Copia da pasta SonarQube sem NUGET para a raiz do repositório original
      mv ./<repo>/dotnet/sem-teste/SonarQube . 
fi

#--- Apagando a pasta <repo>
rm -rf <repo>


#---
#Sonar Scanner

steps:
- task: Docker@2
  displayName: 'Sonar Scanner'
  inputs:
    containerRegistry: ProdPmenosCointanerRegistry
    repository: 'sonarqube/quality-sonarqube'
    command: build
    Dockerfile: SonarQube/Dockerfile.SonarQube.Template
    buildContext: .
    tags: '$(Build.BuildNumber)'
    arguments: '--no-cache --build-arg SONAR_TOKEN=$(sonar_token) --build-arg SONAR_HOST=$(sonar_host) --build-arg PROJECT_KEY=$(project_key)  --build-arg DOTNET_VERSION=$(dotnet_version)  --build-arg PROJECT_CSPROJ=$(project_csproj) --build-arg TESTE_CSPROJ=$(teste_csproj)'
#---
#Remove Scanner Image

docker rmi <repo-image>.<dominio>.com.br/sonarqube/quality-sonarqube:$(Build.BuildNumber)

#---
#Analise de Nota SonarQube

#!/bin/bash

# Defina o nome do sistema
nomeSistema=$(project_key)

# Defina a URL da API do SonarQube
url="$(sonar_host)/api/qualitygates/project_status?projectKey=$nomeSistema"

if [ "$(analisarProjeto)" = "true" ]; then
# Faça a chamada à API e obtenha a resposta
response=`curl -s "$url"`

# Extraia o status do projeto da resposta
read -r projectStatus < <(echo "$response" | jq -r '.projectStatus.status')

# Exiba o status do projeto
echo "Project Status: $projectStatus"

# Verifique se o status é "ERROR"
if [[ "$projectStatus" == "ERROR" ]]; then
    exit 1
fi     
else
    # Exiba o status do projeto
    echo "Project Status: $projectStatus"
fi


