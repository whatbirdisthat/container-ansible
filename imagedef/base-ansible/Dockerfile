FROM alpine
RUN apk add --no-cache ansible make openssh-client sshpass

RUN mkdir -p /etc/ssh
WORKDIR /etc/ssh
RUN ssh-keyscan -t rsa bitbucket.org >>known_hosts
RUN ssh-keyscan -t rsa github.com >>known_hosts
RUN nslookup bitbucket.org | grep ^Address | awk '{print $3}' | xargs -n1 ssh-keyscan -t rsa >> known_hosts
RUN nslookup github.com | grep ^Address | awk '{print $3}' | xargs -n1 ssh-keyscan -t rsa >> known_hosts
#RUN chgrp ${ANSIBLE_USER} known_hosts
RUN chmod ug+r known_hosts
