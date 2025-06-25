source bash/definitions.sh

# The docker flags are:
# -d: Run the container in detached mode
# -p: Map the container port to the host port
# --name: Name the container
# ${IMAGE_NAME}: The name of the image to run

echo "-> Running new container: ${CONTAINER_NAME}"
docker run -d -p ${HOST_PORT}:80 --name ${CONTAINER_NAME} ${IMAGE_NAME}
echo "-> Container running: ${CONTAINER_NAME}"

echo "-> Getting container logs"
docker logs -f ${CONTAINER_NAME}



