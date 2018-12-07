FROM python:3.6

WORKDIR /usr/src/app
ADD ../code/python ./
RUN ls -l
ENV http_proxy=http://10.10.10.10:8080
ENV https_proxy=http://10.10.10.10:8080
ENV ftp_proxy=http://10.10.10.10:8080
ENV HTTP_PROXY=http://10.10.10.10:8080
ENV HTTPS_PROXY=http://10.10.10.10:8080
ENV FTP_PROXY=http://10.10.10.10:8080

RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT ["python","run.py"]
