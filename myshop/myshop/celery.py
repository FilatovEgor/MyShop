
import os


from celery import Celery



# set the default Django settings module for the 'celery' program.


os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'myshop.settings')

# app = Celery('myshop', broker='amqp://guest:guest@rabbitmq:5672', backend='amqp://guest:guest@rabbitmq:5672')


app = Celery('myshop', broker='amqp://guest:guest@rabbitmq:5672', backend='rpc://')


#app = Celery('myshop')


app.config_from_object('django.conf:settings', namespace='CELERY')
app.autodiscover_tasks()
# # Optional configuration, see the application user guide.
app.conf.update(result_expires=3600,)


@app.task(bind=True)
def debug_task(self):
    print('Request: {0!r}'.format(self.request))


if __name__ == '__main__':
    app.start()
