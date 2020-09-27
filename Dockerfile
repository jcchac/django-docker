FROM python:3.8.6-alpine

WORKDIR /usr/src/app

# Set environment variables
ENV LANG C.UTF-8 \
    LC_ALL C.UTF-8 \
    PYTHONDONTWRITEBYTECODE 1 \
    PYTHONUNBUFFERED 1

# Update pip and install pipenv and compilation dependencies
RUN pip install --upgrade pip \
    && pip install pipenv \
    && apk update \
    && apk add postgresql-dev gcc python3-dev musl-dev

# Install dependencies in ./venv
COPY ./Pipfile* ./
RUN PIPENV_VENV_IN_PROJECT=1 pipenv install --deploy --system
COPY ./ ./

# run entrypoint.sh
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]