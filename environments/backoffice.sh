echo "123456" | sudo -S ls

echo # 
echo # Initializing Backoffice Docker Container
echo #

currentFile=$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")

environment=`basename "${currentFile%.*}"`

container="$(sudo docker run -ti --detach --name ${environment} -v /home/$USER/projects:/home/httpd/html ubuntu.php53)"; sudo docker exec ${container} /etc/init.d/apache2 start
