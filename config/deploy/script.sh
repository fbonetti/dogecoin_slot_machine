git pull origin master
rake db:migrate
sudo touch /var/www/maroon/tmp/restart.txt
sudo /etc/init.d/nginx stop
sudo /etc/init.d/nginx start