# testing_docker_ci
This is to test a docker django container with ci

## Getting Started
These instructions will get you a copy of the project up and running on your local machine for development purposes.
### Prerequisites
```
Docker and Docker Compose
```
### Installing
The order of operation should be followed.

Fork the repo and then clone it down to your local machine from your account
```
git clone https://github.com/phansiri/testing_docker_ci.git
```
Go to the root directory
```
cd testing_docker_ci
```
Build the docker-compose file and detach so it runs in the background
```
docker-compose up --build -d
```
Check the container ids for future use
```
docker ps
```
Configure the postgres database name, user, and password - the default login to psql is postgres without a password
```
docker container exec -it [container_id] psql -U postgres
```
Create database, create user, and grant database to user
```
CREATE DATABASE databasename;
CREATE USER dbuser WITH PASSWORD 'password';
GRANT ALL ON DATABASE databasename TO dbuser;
\q
```
Now update these specific locations on settings.py of your project
```python

SECRET_KEY = os.environ.get('SECRET_KEY', 'not-so-secret-key')

DEBUG = int(os.environ.get('DEBUG', default=1))

DATABASES = {
    'default': {
        'ENGINE': os.environ.get('DB_ENGINE', 'django.db.backends.sqlite3'),
        'NAME': os.environ.get('DB_DATABASE_NAME', os.path.join(BASE_DIR, 'db.sqlite3')),
        'USER': os.environ.get('DB_USERNAME', 'user'),
        'PASSWORD': os.environ.get('DB_PASSWORD', 'password'),
        'HOST': os.environ.get('DB_HOST', 'localhost'),
        'PORT': os.environ.get('DB_PORT', '5432'),
    }
}
```
Create .env and .env-db and populate the files
** ensure to the files are ignored.

.env
```
DEBUG=1
SECRET_KEY=

DB_ENGINE=django.db.backends.postgresql
DB_TYPE=postgres
DB_DATABASE_NAME=databasename  
DB_USERNAME=dbuser
DB_PASSWORD=password  
DB_HOST=db
DB_PORT=5432
```

.env-db
```
POSTGRES_DB=databasename
POSTGRES_USER=docdbuserking_user
POSTGRES_PASSWORD=password
```
Rebuild the container again with
```
docker-compose up --build -d
```
Run migrate and create a super user
```
docker ps
docker container exec -it [container_id] python manage.py migrate
docker container exec -it [container_id] python manage.py createsuperuser
```
Check what the docker-machine ip address is
```
docker-machine ls
```
This will tell you the ip address to put into the browser. The port number will be what is in the docker-compose file. For example
```
http://192.168.99.100:8001/
```
To shut it down and kill the volume
```
docker-compose down -v
```
To shut it down but NOT kill the volume
```
docker-compose down
```

Good luck!