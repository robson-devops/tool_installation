#!/bin/bash

GITLAB_URL="gitlab.devopslabs.local"
USER="gitlab-runner"
PATH="/usr/local/bin/gitlab-runner"
FILE="https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64"

setup()
{
    clear
    echo "########################################################"
    echo "#         --INSTALAÇÃO DO GITLAB RUNNER--              #"
    echo "########################################################"

    sudo curl -L --output $PATH  $FILE
    sudo chmod u+x $PATH
    sudo useradd --comment 'Gitlab Runner' --create-home $USER --shell /bin/bash

    # - Resolve o problema na execução do runner pela pipeline.
    sudo mv /home/gitlab-runner/.bash_logout /home/gitlab-runner/.bash_logout_

    sudo gitlab-runner install --user=$USER --working-directory=/home/$USER
    sudo gitlab-runner start
}

config()
{
    echo "----------------------------"
    echo "CADASTRAR O RUNNER NO GITLAB"
    echo "----------------------------"
    echo " "
    echo "1 - Informe o endereço do Gitlab: http://$GITLAB_URL/"
    echo "2 - Informe a chave de registro. Acesse o endereço:  http://$GITLAB_URL/admin/runners"
    echo "3 - Informe uma descrição. Exemplo: runner_pipelines"
    echo "4 - Informe uma tag. Exemplo: pipeline"
    echo "5 - Escolha um executor. Exemplo: shell"

sleep 3
sudo gitlab-runner register

echo "End of installation."
echo "Adicione a linha extra_hosts = ["$ENDERECO:IP_SERVIDOR"] no final do arquivo /etc/gitlab/config.tom"  
echo "Para ver os logs do runner, execute: gitlab-runner run"
}


setup
config

exit 0
