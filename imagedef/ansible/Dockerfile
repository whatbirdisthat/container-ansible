ARG SOE=whatbirdisthat/null
FROM ${SOE}

ARG ANSIBLE_USER=ansible
RUN adduser -D -g '' ${ANSIBLE_USER}
RUN addgroup ${ANSIBLE_USER} ansible
RUN sed -i 's/export PS1/#export PS1/' /etc/profile

WORKDIR /home/${ANSIBLE_USER}
COPY user_profile.bash .profile

USER ${ANSIBLE_USER}
ENV ENV="/home/${ANSIBLE_USER}/.profile"

ENTRYPOINT [ "ash" ]
