FROM alpine:latest

RUN apk add --no-cache 													\
	bash bash-completion 													\
	musl-dev libffi-dev gcc make 									\
	openssl-dev openssh-client sshpass 						\
	python py2-pip python-dev

RUN pip install cffi && pip install ansible

RUN mkdir -p /etc/ssh
WORKDIR /etc/ssh
RUN ssh-keyscan -t rsa bitbucket.org >>known_hosts
RUN ssh-keyscan -t rsa github.com >>known_hosts
RUN nslookup bitbucket.org | grep ^Address | awk '{print $3}' | xargs -n1 ssh-keyscan -t rsa >> known_hosts
RUN nslookup github.com | grep ^Address | awk '{print $3}' | xargs -n1 ssh-keyscan -t rsa >> known_hosts
RUN ssh-keyscan -t rsa docker.for.mac.host.internal >>known_hosts
RUN nslookup docker.for.mac.host.internal | grep ^Address | awk '{print $3}' | xargs -n1 ssh-keyscan -t rsa >> known_hosts

RUN chmod ug+r known_hosts
