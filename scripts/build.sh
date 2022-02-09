# Build docker image from parent repo
export docker_file="Dockerfile"
export image_name="dockerdev"

# if the dockerfile exists in parent directory
if [ -f "../$docker_file" ]; then
    docker build -f ../$docker_file -t $image_name ..
else
    echo "$docker_file not found in parent directory"
fi