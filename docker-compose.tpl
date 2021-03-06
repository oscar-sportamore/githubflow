version: "2"

services:
    app:
        build: .

        ports:
            - "5000"

        environment:
            CELERY_BROKER: "redis://redis"

            GITHUB_WEBHOOK_SECRET: ""
            GITHUB_TOKEN: ""

    wsgi-app:
        extends:
            service: app

        command: uwsgi ./uwsgi.ini

        depends_on:
            - redis
            - worker

    worker:
        extends:
            service: app

        command: celery -A tasks worker -c 1

        depends_on:
            - redis

    redis:
        image: "redis:latest"

        command: redis-server --save ""
