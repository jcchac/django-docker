#!/bin/sh

if [ "$DATABASE" = "postgres" ]
then
    echo "Waiting for postgres..."

    while ! nc -z $DJANGO_SQL_HOST $DJANGO_SQL_PORT; do
      sleep 0.1
    done

    echo "PostgreSQL started"
fi

# Instead of running in every container start or re-start
# python manage.py flush --no-input
# python manage.py migrate
# Run manually
#       docker-compose exec web python manage.py flush --no-input
#       docker-compose exec web python manage.py migrate

exec "$@"