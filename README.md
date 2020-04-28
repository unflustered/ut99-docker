# ut99 docker
### Dedicated server image for Unreal Tournament

### Simple usage
To start up a server quickly, run a new container using the image:

```
docker run -p 7777-7781:7777-7781/udp -p 8777:8777/udp -p 7770:7770/tcp --name ut slapt/ut99
```

The server will start up on port 7777, with the web admin UI available on port 7770.

For persistently running servers, create a volume and attach it to the container at `/.loki/ut`. This is where configuration files and maps/mods need to be placed.

### Environment variables

There are three main environment variables that control the startup of the server. These are `STARTUP_MAP` (default: DM-Turbine), `GAME_MODE` (default: Botpack.DeathMatchPlus) and `MUTATORS` (default: empty string)

---
In addition to packaging the Unreal Tournament server files, the UTPG v451 patch and the "bonus pack" content, this repository also contains code taken from [abfackeln's Server Utilities (ASU)](https://github.com/abfackeln/ut) with modifications to run on Perl 5. ASU is licensed under the GNU General Public License version 3.
