NORMAL="\[\e[0m\]"
RED="\[\e[1;31m\]"
GREEN="\[\e[1;32m\]"
MAGENTA="\[\e[1;35m\]"
YELLOW="\[\e[1;33m\]"
WHITE="\[\e[1;37m\]"

export PS1="${GREEN}$MACUSER${WHITE}@${MAGENTA}\h${NORMAL} \w${YELLOW} ∆${NORMAL} "

source /etc/profile.d/bash_completion.sh

ANSIBLE_VERSION=`ansible --version | grep 'ansible' | head -n1 | awk ' { print $2 } '`
echo -e "\e[1;33mContainer-Ansible : ${ANSIBLE_VERSION}\e[0m"
