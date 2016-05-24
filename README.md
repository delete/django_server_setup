# Script to Setting up Django with uWsgi and Nginx

>This script was created following the amazing [Digital Ocean's tutorial](https://www.digitalocean.com/community/tutorials/how-to-serve-django-applications-with-uwsgi-and-nginx-on-ubuntu-14-04).

## OS tested:
* Ubuntu 14.04 and 16.04.

>Was used Python 3.x version.

## First: Change the config files to your environment

* Change all the uppercase word to your data.

`nginx-example, uwsgi.conf, uwsgi-example.ini`


## Second: Setting uwsgi and nginx up

* Run `start.sh` (DO NOT run as root) giving the **project's name as the first argument** and your **user name as second**.

```sh
$ chmod +x start.sh
$ ./start.sh PROJECT_NAME YOUR_USER
```
## Third: Updating session and create virtual environment

### As virtualenvwrapper was installed, it is necessary reload the session.
```sh
$ source ~/.bashrc
```

#### Create the virtual environment giving the project's name:
```sh
$ mkvirtualenv PROJECT_NAME
```

## Four: Configure PostgreSQL

* Becoming postgres superuser 

`$sudo su - postgres`

* Connecting to the database server

`~$ psql template1`

* Add new user

`# create user MY_DB_USER with password 'MY_PASS';`

* Create database

`# create database MY_DATABASE;`

* Grant all privileges

`# grant all privileges on database MY_DATABASE to MY_DB_USER;`

* To quit
`\q`


## Five: Now, the Django process...

#### Create a directory at home with the same name of your project, install django and create a new project:
```sh
$ mkdir ~/PROJECT_NAME

$ cd ~/PROJECT_NAME

$ pip install django

$ django-admin.py startproject PROJECT_NAME .
```

#### Change SQLlite3(default) to PostgreSQL at `settings.py`

```sh
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': 'MY_DATABASE',
        'USER': 'MY_DB_USER',
        'PASSWORD': 'MY_PASS',
        'HOST': 'localhost',
        'PORT': '',
    }
}
```

#### Setting up static directory which will be serve by nginx.

* Add to your `settings.py`:

`STATIC_ROOT = os.path.join(BASE_DIR, "static/")`

* Then run:
```sh
 python manage.py collectstatic
```

## Last one: Restart and everything should work. :]
```sh
$ sudo service uwsgi restart
$ sudo service nginx restart
```

## If you are getting `505 error Bad Gateway`, run:
`sudo chown YOUR_USER:www-data /tmp/PROJECT_NAME.sock`

Your sock file must be like this:
```sh
$ ls -l /tmp
srw-rw-r--  1 userver www-data    0 Mai 18 13:28 PROJECT_NAME.sock=
```
