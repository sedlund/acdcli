# sedlund/acdcli

Alpine Linux base with [acd_cli](https://github.com/yadayada/acd_cli) and fuse installed

# Changelog

5/28/2017 Update to support acd_cli api 0.9.3 and use the git repo with the latest API to fix the auth issues

## Usage Opportunities:

### Pass your docker hosts local directory where your acd_cli oauth files are and run a listing

    docker run -it --rm -v /home/ubuntu/.cache/acd_cli:/home/user/.cache/acd_cli sedlund/acdcli ls

### Create a data volume and set permissions of the home directory

    docker run --rm -v acdcli_data:/home/user busybox chown -R 1000:1000 /home/user

### Generate an oauth token in that container and sync

    docker run -it --rm -v acdcli_data:/home/user sedlund/acdcli init

This will start eLinks browser for you to authorize the connection and create your token.  Save the file in ~/.cache/acd_cli/oauth_data

    docker run -it --rm -v acdcli_data:/home/user sedlund/acdcli sync
    
### Copy existing token inside the data container and set permissions

    docker cp ~/.cache/acd_cli acdcli_data:/home/user/.cache
    docker run --rm -v acdcli_data:/home/user busybox chown -R 1000:1000 /home/user

### Mounting via fuse inside the container

#### Option 1
    docker run -itd --privileged --name acdmount -v acdcli_data:/home/user --entrypoint=/bin/sh sedlund/acdcli -c "acdcli -v mount /mnt; sh"
#### Option 2
    docker run -itd --cap-add SYS_ADMIN --device /dev/fuse --name acdmount -v acdcli_data:/home/user --entrypoint=/bin/sh sedlund/acdcli -c "acdcli -v mount /mnt; sh"
----

* `--privileged` you can use the example with privileged which gives the container extra permission or you can use the second example which uses a cap-add and passes a device (more secure).
* `--entrypoint=/bin/sh` is needed to change the default entrypoint
* `--cap-add SYS_ADMIN` is needed for using FUSE
* `--device /dev/fuse` is needed for FUSE
* passing `-c "acdcli -v mount; sh"` to sh shows how to run a command that would fork (causing the container to exit), and running sh to keep it running.

**NOTE**: You cannot export a fuse mount as a volume from the container.  Check out `sedlund/acdcli-webdav` (based on this image) to mount ACD and provide a secure webdav share.  You could do other things like setup a sftp server in this container, but that is left as an excersize to the user.

### Using it to upload files from your Docker host
    docker run -it --privileged --rm --name acdmount --volumes-from acdcli-data -v "$(pwd)":/mnt --entrypoint=/bin/sh sedlund/acdcli

