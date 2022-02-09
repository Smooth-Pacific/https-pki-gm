export image_name="dockerdev"

# Launch container from new image
docker run -dit -v "$(pwd)/..":/home/dev/server:z $image_name bash