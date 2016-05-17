# Script to Setting up Django with uWsgi and Nginx

>Theses scripts was created following the amazing [Digital Ocean tutorial](https://www.digitalocean.com/community/tutorials/how-to-serve-django-applications-with-uwsgi-and-nginx-on-ubuntu-14-04).

> Was used Python 3.x version.

## First: Change the config files to your environment:

* nginx-example, uwsgi.conf, uwsgi-example.ini
Change all the uppercase word to your data.

## Second: Setting uwsgi and nginx up:

* Run `uwsgi_nginx.sh` (DO NOT run as root) giving the project name as the first argument and your user name as second.

```sh
$ chmod +x uwsgi_nginx.sh
$ ./uwsgi_nginx.sh PROJECT_NAME MY_USER
```
## Third: Updating session:

### As was installed virtualenvwrapper, it is necessary reload the session.
```sh
$ source ~/.bashrc
```

## Fourth: Everything should be fine, so create the Django project as usual.

#### Create the virtual environment givin the name of your project:
```sh
$ mkvirtualenv PROJECT_NAME
```

#### Now, the Django process...

* Create a directory at home with the same name of your project:
```sh
$ mkdir ~/PROJECT_NAME

$ pip install django

$ django-admin.py startproject PROJECT_NAME .
```

#### Setting up static directory which will be serve by nginx.

* Add to your `settings.py`:

`STATIC_ROOT = os.path.join(BASE_DIR, "static/")`

* Then run:

`$PYTHON_PATH $MANAGE collectstatic`

## Last one: Restart and everything should work. :]
```sh
$ sudo service uwsgi restart
$ sudo service nginx restart
```
