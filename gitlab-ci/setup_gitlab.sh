#!/bin/bash

# - DISTRO: Debian GNU/Linux 12 (bookworm)

GITLAB_URL="gitlab.devopslabs.local"
GITLAB_REPOSITORY="https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh"

setup()
{
    
    echo "$(/usr/sbin/ifconfig | grep inet | grep -v inet6 | head -n1  | awk {'print $2'}) gitlab.devopslabs.local" | sudo tee -a /etc/hosts
 
    clear
    echo "########################################################"
    echo "#         -- GITLAB-CI INSTALLATION --                 #"
    echo "########################################################"

    sudo apt-get update -y && sudo apt-get install curl net-tools
    #sudo apt-get install postfix -y
    curl -sS $GITLAB_REPOSITORY | sudo bash
    sudo apt-get install gitlab-ce -y
}

config()
{
    sudo firewall-cmd --zone=public --add-service=https
    sudo firewall-cmd --zone=public --add-service=https --permanent
    
    sudo sed -i s/gitlab.example.com/$GITLAB_URL/g /etc/gitlab/gitlab.rb
    sudo EXTERNAL_URL="http://$GITLAB_URL" 
    sudo gitlab-ctl reconfigure
    clear

    echo "######################################################################################################"
    echo "#                                     INSTALLATION COMPLETED                                         #"
    echo "#----------------------------------------------------------------------------------------------------#"
    echo "######################################################################################################"
    echo " "
    echo URL     : http://$GITLAB_URL                                                                       
    echo Username: root                                                                                     
    echo Password: $(sudo grep -i password /etc/gitlab/initial_root_password | tail -n1 | awk '{print $2}') 


}

setup
config

exit 0