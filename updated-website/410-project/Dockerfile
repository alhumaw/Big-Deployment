FROM ubuntu
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt -y install python3
RUN apt -y install python3-flask
RUN apt -y install python3-requests
RUN apt -y install curl
RUN apt -y install whois
COPY flask_example.py ./
COPY index.html ./
COPY about.html ./
COPY ftp.html ./
EXPOSE 5000
CMD ["python3", "flask_example.py"]

