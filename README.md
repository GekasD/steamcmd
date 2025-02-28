# SteamCMD

This is a simple [SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD) image for Docker based on Debian 12 (slim image).

## Usage

Build the image from this repository:

```bash
docker build -t gekasd/steamcmd:latest https://github.com/GekasD/steamcmd.git
```

The default unprivileged user is called `steam`, SteamCMD is installed inside `/home/steam/Steam`.

In addition to `~/Steam`, 2 extra directories get created inside `/home/steam`, `server` and `demos`.
The `server` directory is where you want to mount your game server volume, `demos` is just an extra directory I
bind mount to in order to record .dem files on CS servers (`tv_record /home/steam/demos/demo.dem`), they are created
in order to avoid any permission issues that occur when Docker creates the directories while mounting.

To persist all of SteamCMD's data, you should create a volume and mount it on `/home/steam/Steam` inside the container, this will [copy all existing data](https://docs.docker.com/engine/storage/volumes/#populate-a-volume-using-a-container) and populate the volume when mounted on a container.

```bash
docker volume create steamcmd_data
```

To install a game server (for example CS2), you can make a volume for the server's files, mount it, and run an `AutoRemove` container like so:

```bash
docker volume create cs2_server_data
docker run --rm -v cs2_server_data:/home/steam/server -v steamcmd_data:/home/steam/Steam gekasd/steamcmd:latest +force_install_dir +login anonymous +app_update 730 validate +quit
```