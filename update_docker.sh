# Check date of Docker image and compare with date of Dockerfile

echo "Checking whether Docker image needs to be rebuilt"

#echo "Docker info:"
#docker inspect $1

imtime=`docker inspect -f '{{.Created}}' $DOCKER_IMAGE`
imtime_sec=`date -d $imtime +%s`

echo "Image timestamp: $imtime ($imtime_sec)"

filemtime=`stat -c %y Dockerfile`
filemtime_sec=`stat -c %Y Dockerfile`

echo "Dockerfile timestamp: $filemtime ($filemtime_sec)"

if [ $filemtime_sec -gt $imtime_sec ]; then
    echo "Dockerfile is newer; rebuilding image"
    docker build -t $DOCKER_IMAGE .
    # docker build -t shrdluk/pyocct-test2 .
    echo "Pushing image to Docker Hub"
    echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
    docker push $DOCKER_IMAGE
    #docker push shrdluk/pyocct-test2
    echo "Done"
    echo "This build will finish and a new one will be scheduled to use the new image"
    touch reschedule_required
else
    echo "Image is newer; nothing to do"
fi
