svengo/docker-teamspeak
==================

docker image for TeamSpeak 3 Server
based off of alpine:3.6 and [mbentley/docker-teamspeak
](https://github.com/mbentley/docker-teamspeak)

Note: This Dockerfile will always install the very latest version of TS3 available.

----------
The image isn't pushed to docker hub **yet**.
----------


Example usage (no persistent storage; for testing only - you will lose your data when the container is removed):

`docker run -d --name teamspeak -p 9987:9987/udp -p 30033:30033 -p 10011:10011 svengo/teamspeak`

### Differences to mbentley/docker-teamspeak

 - The containers runs with Docker's [user namespace](https://docs.docker.com/engine/security/userns-remap/).  - This was the main reason for the fork.
 - ``/data``-permissions are handled by the container instead of the user.
 - The container uses an anonymous volume for ``/data``.
 - Changed base from ``debian:jessie`` to ``alpine:3.6``.
 - Uses ``tini`` and ``su-exec`` from alpine.
 - Uses [sgerrand/alpine-pkg-glibc](https://github.com/sgerrand/alpine-pkg-glibc) to get teamspeak running.

### Advanced usage with persistent storage:

1. The data is stored in an *anonymous volume* (see ``docker inspect`` for more information. 
2. You can use a *host volume* to store the data in a specific directory on the host. The directory could exist, the permissions are handled by the container.
3.  Start container:
    ```
    docker run -d --restart=always --name teamspeak \
      -p 9987:9987/udp -p 30033:30033 -p 10011:10011 \
      -v /data/teamspeak:/data \
      svengo/teamspeak
    ```

In order to get the credentials for your TS server, check the container logs as it will output the `serveradmin` password and your `ServerAdmin` privilege key.

For additional parameters, check the `(6) Commandline Parameters` section of the [TeamSpeak 3 Server Quickstart Guide](http://media.teamspeak.com/ts3_literature/TeamSpeak%203%20Server%20Quick%20Start.txt).  Either add the parameters to `ts3server.ini` or specify them after the Docker image name.

Example:
```
docker run -d --restart=always --name teamspeak \
  -p 9987:9987/udp -p 30033:30033 -p 10011:10011 \
  -v /data/teamspeak:/data \
  svengo/teamspeak \
  clear_database=1 \
  create_default_virtualserver=0
```
