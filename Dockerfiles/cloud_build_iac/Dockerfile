FROM gcr.io/cloud-builders/kubectl
RUN apt install curl -y
COPY iac.sh /
RUN chmod a+x /iac.sh
ENTRYPOINT ["sh"]
