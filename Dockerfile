FROM rocker/shiny-verse

LABEL io.k8s.description="R Shiny" \
    io.k8s.display-name="R Shiny" \
    io.openshift.expose-services="3838:http" \
    io.openshift.tags="builder,webserver,html,r,shiny" \
    # this label tells s2i where to find its mandatory scripts
    # (run, assemble)
    io.openshift.s2i.scripts-url="image:///usr/libexec/s2i"
RUN apt-get update && apt-get install -y \ 
    libnss-wrapper \
    gettext 

COPY ./s2i/bin/ /usr/libexec/s2i
COPY ./passwd.template /home/shiny/passwd.template 
RUN chmod +x /usr/libexec/s2i/*

RUN mkdir -p /var/log/shiny-server


RUN chgrp -R 0 /home/shiny && \ 
    chmod -R g+rwX /home/shiny

RUN chgrp -R 0 /srv/shiny-server && \ 
    chmod -R g+rwX /srv/shiny-server

RUN chgrp -R 0 /var/log/shiny-server && \ 
    chmod -R g+rwX /var/log/shiny-server

RUN chgrp -R 0 /usr/local/lib/R && \ 
    chmod -R g+rwX /usr/local/lib/R

RUN chgrp -R 0 /var/lib/shiny-server && \ 
    chmod -R g+rwX /var/lib/shiny-server

USER 1001

EXPOSE 3838

CMD ["/usr/libexec/s2i/usage"]
