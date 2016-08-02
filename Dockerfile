# API-Lovely-production docker
# TODO

FROM p404/python3.4:latest
MAINTAINER Pablo Opazo "p@sequel.ninja"

# Added custom ssh config / keys to the root user
ENV HOME /root
ADD ssh/ /root/.ssh/

# Fixes permission if needed
RUN chmod 600 /root/.ssh/*

# Avoid first connection host confirmation
RUN ssh-keyscan github.com> /root/.ssh/known_hosts

RUN git clone git@github.com:p404/API-Lovely.git /djangoapp

# Run pip install 
RUN pip3.4 install -r /djangoapp/requirements.txt

# Add init script's
RUN mkdir -p /etc/my_init.d

# Static Files
ADD bash_scripts/django_tasks_prod.sh /etc/my_init.d/django_tasks_prod.sh
RUN chmod +x /etc/my_init.d/django_tasks_prod.sh

ADD bash_scripts/webserver_prod.sh /etc/my_init.d/webserver_prod.sh
RUN chmod +x /etc/my_init.d/webserver_prod.sh

EXPOSE 8000:8000

CMD ["/sbin/my_init"]
