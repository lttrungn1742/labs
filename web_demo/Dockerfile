FROM python:3.8-slim-buster

WORKDIR /app
COPY ./app.py main.py
COPY ./data.db data.db

RUN pip3 install flask 


CMD ["python3", "/app/main.py"]
