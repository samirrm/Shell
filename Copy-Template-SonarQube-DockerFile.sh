#!/bin/bash

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
