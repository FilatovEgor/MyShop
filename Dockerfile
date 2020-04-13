# start from an official image
FROM python:3.7.4

# arbitrary location choice: you can change the directory
RUN mkdir -p /opt/services/djangoapp/src
WORKDIR /opt/services/djangoapp/src

# install our dependencies
# we use --system flag because we don't need an extra virtualenv
COPY Pipfile Pipfile.lock /opt/services/djangoapp/src/
RUN pip install pipenv && pipenv install --system

# copy our project code
COPY . /opt/services/djangoapp/src

#RUN groupadd -r user -g 901 && useradd -u 901 -r -g user

# expose the port 8000
EXPOSE 8000
EXPOSE 5555

#RUN { \
#  echo 'import os'; \
#  echo "BROKER_URL = os.environ.get('CELERY_BROKER_URL', 'amqp://')"; \
#} > celeryconfig.py

# --link some-rabbit:rabbit "just works"
#ENV CELERY_BROKER_URL amqp://guest@rabbitmq

#USER user
#CMD ["celery", "worker"]
# celery -A myshop worker -l info
# define the default command to run when starting the container
CMD ["gunicorn", "--chdir", "myshop", "--bind", ":8000", "myshop.wsgi:application"]
#CMD ["celery", "-A", "myshop", "worker", "-l", "info", "--broker=amqp://guest:guest@rabbitmq:5672"]
#CMD ["celery", "-A", "myshop", "flower"]
#["flower", "--broker=amqp://guest:guest@rabbitmq:5672", "--port=5555"]