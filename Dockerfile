FROM python:3.8.0b4-alpine

ENV PYTHONUNBUFFERED 1

RUN apk update && \
    apk add --virtual build-deps gcc python-dev musl-dev && \
    apk add postgresql-dev

RUN mkdir /code

WORKDIR /code

ADD requirements.txt /code/

RUN python -m pip install --upgrade pip && pip install -r requirements.txt

ADD . /code/