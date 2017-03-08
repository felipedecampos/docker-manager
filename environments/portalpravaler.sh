echo "123456" | sudo -S ls

echo #
echo # Initializing Portalpravaler Docker Container
echo #

currentFile=$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")

environment=`basename "${currentFile%.*}"`

container="$(sudo docker run --net felipe --ip 173.1.0.3 -ti --detach --name ${environment} -v /var/www:/var/www ubuntu.php56)"; sudo docker exec ${container} /etc/init.d/apache2 start
