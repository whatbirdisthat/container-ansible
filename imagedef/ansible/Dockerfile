ARG SOE=whatbirdisthat/null
FROM ${SOE}

ARG ANSIBLE_USER=ansible
RUN adduser -D -g '' ${ANSIBLE_USER}
RUN addgroup ${ANSIBLE_USER} ansible
RUN sed -i 's/export PS1/#export PS1/' /etc/profile

WORKDIR /home/${ANSIBLE_USER}
COPY user_profile.bash .profile
RUN chown ${ANSIBLE_USER} /home/${ANSIBLE_USER}/.profile

USER ${ANSIBLE_USER}

RUN mkdir -p /home/${ANSIBLE_USER}/.ssh/
RUN cp /etc/ssh/known_hosts /home/${ANSIBLE_USER}/.ssh/known_hosts
RUN touch /home/${ANSIBLE_USER}/.ssh/config
RUN chmod 400 /home/${ANSIBLE_USER}/.ssh/config

ENV ENV="/home/${ANSIBLE_USER}/.profile"

ENTRYPOINT [ "ash" ]
