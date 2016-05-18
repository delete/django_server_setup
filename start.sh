#!/bin/bash

# Global variables
PROJECT_NAME=$1
USER=$2

# Test if the user is root. This script can't run as root.
if [ "$EUID" -eq 0 ]; then
  echo "Do not run this script as root!!" 2>&1
  exit 1
fi

# Check is the names was given.
if [ "$PROJECT_NAME" == "" ] || [ "$USER" == "" ]; then
  echo "Give the project's name as the first argument and your user name as second." 2>&1
  exit 1
fi

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

# If uwsgi.service file does not exits, create it.
if [ ! -s /etc/systemd/system/uwsgi.service ]; then
  sudo cp uwsgi.service /etc/systemd/system/uwsgi.service
fi

sudo service uwsgi start

## Setting virtualenvwrapper up
echo "export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3" >> ~/.bashrc
echo "export WORKON_HOME=~/Env" >> ~/.bashrc
echo "source /usr/local/bin/virtualenvwrapper.sh" >> ~/.bashrc
