echo "Udt&2812" | sudo -S ls

echo #
echo # Initializing Portalpravaler Docker Container
echo #

currentFile=$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")

environment=`basename "${currentFile%.*}"`

container="$(sudo docker run -ti --detach --network docker-manager-network --ip 173.1.0.3 --name ${environment} -v /home/$USER/projects:/var/www ubuntu.php56:1.0)"; sudo docker exec ${container} /etc/init.d/apache2 start
