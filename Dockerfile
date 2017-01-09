
FROM alpine:latest

RUN apk update
RUN apk add ansible git sshpass
RUN ansible-galaxy install yutannihilation.module-cran
#RUN git clone https://github.com/yutannihilation/ansible-module-cran.git
COPY hosts /etc/ansible/hosts
COPY otb.yml /otb.yml
ADD conf /
ENV ANSIBLE_HOST_KEY_CHECKING False
#CMD ["ansible-playbook","--module-path=./ansible-module-cran/library","otb.yml"]
CMD ["ansible-playbook","otb.yml"]

