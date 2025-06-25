source bash/definitions.sh

echo "-> Compiling Docker image: ${IMAGE_NAME}"
echo "-> Container name: ${CONTAINER_NAME}"
echo "-> Host port: ${HOST_PORT}"

echo "-> Checking if container exists"
# Check if a container with the same name exists and remove it
if [ "$(docker ps -aq -f name=${CONTAINER_NAME})" ]; then
    echo "-> Found and removing existing container: ${CONTAINER_NAME}"
    docker rm -f ${CONTAINER_NAME}
fi

# Build the Docker image
echo "-> Building Docker image: ${IMAGE_NAME}"
docker build -t ${IMAGE_NAME} .

# Run the Docker container
echo "-> Running new container: ${CONTAINER_NAME}"
docker run -d -p ${HOST_PORT}:80 --name ${CONTAINER_NAME} ${IMAGE_NAME}
