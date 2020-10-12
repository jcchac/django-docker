FROM python:3.8.6-alpine as base

# Set environment variables
ENV LANG C.UTF-8 \
    LC_ALL C.UTF-8 \
    PYTHONDONTWRITEBYTECODE 1 \
    PYTHONUNBUFFERED 1

#=========#
# BUILDER #
#=========#
FROM base as builder

# Update pip and install pipenv and compilation dependencies
RUN pip install --upgrade pip \
    && pip install pipenv \
    && apk update \
    && apk add postgresql-dev gcc python3-dev musl-dev

# Install dependencies in /.venv
COPY ./Pipfile* ./
RUN PIPENV_VENV_IN_PROJECT=1 pipenv install --deploy

#=======#
# FINAL #
#=======#
FROM base

ENV HOME=/home/app \
    APP_HOME=/home/app/web
RUN mkdir -p $APP_HOME/static \
    && mkdir $APP_HOME/media
WORKDIR $APP_HOME

# Create directory for the app user and the user (non-root)
RUN addgroup -S appgroup \
    && adduser -S appuser -G appgroup \
    && chown -R appuser $APP_HOME

# Copy venv from builder stage
COPY --from=builder /.venv /.venv 
COPY --from=builder /usr/lib /usr/lib 
ENV PATH="/.venv/bin:$PATH"

COPY ./ ./
USER appuser

# run entrypoint.sh
ENTRYPOINT ["/home/app/web/entrypoint.sh"]