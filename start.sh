#!/bin/bash

# Global variables
PROJECT_NAME=$1
USER=$2

# Update system
echo 'yes' | sudo apt-get update
echo 'yes' | sudo apt-get upgrade


# Install dependencies
sudo apt-get -y install python3-pip python3-dev nginx

## Now that we have pip installed, we can install virtualenv, virtualenvwrapper and uwsgi
sudo pip3 install virtualenv virtualenvwrapper uwsgi

## Add user to wwww-data group (required to uwsgi)
sudo usermod -a -G www-data $USER

## Setting uwsgi up
mkdir $HOME/logs
touch "/tmp/$PROJECT_NAME.sock"

## Add permissions
sudo chown $USER:www-data /tmp/$PROJECT_NAME.sock
chmod u+rw /tmp/$PROJECT_NAME.sock
chmod g+rw /tmp/$PROJECT_NAME.sock

sudo mkdir -p /etc/uwsgi/sites
sudo cp uwsgi-example.ini "/etc/uwsgi/sites/$PROJECT_NAME.ini"
sudo cp uwsgi.conf /etc/init/uwsgi.conf

## Setting nginx up
sudo cp nginx-example "/etc/nginx/sites-available/$PROJECT_NAME"

sudo ln -s "/etc/nginx/sites-available/$PROJECT_NAME" "/etc/nginx/sites-enabled/$PROJECT_NAME"

# Test if everything is all right
sudo service nginx configtest

# Force a stop to see the result
echo "Does everything is OK? Then go on! If does not, review the configs files."
echo "Press ENTER to continue"
read

sudo service nginx restart

sudo service uwsgi start

## Setting virtualenvwrapper up
echo "export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3" >> ~/.bashrc
echo "export WORKON_HOME=~/Env" >> ~/.bashrc
echo "source /usr/local/bin/virtualenvwrapper.sh" >> ~/.bashrc
