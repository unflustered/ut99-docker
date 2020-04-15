# ut99 docker
### Dedicated server image for Unreal Tournament

### Simple usage
To start up a server quickly, run a new container using the image:

```
docker run -p 7777-7780:7777-7780/udp -p 8777:8777/udp -p 7770:7770/tcp --name ut slapt/ut99
```

The server will start up on port 7777, with the web admin UI available on port 7770.

### Environment variables

A number of environment variables control how the server is started or configured. Some of these env vars become part of the command line passed to `ucc server`, but others are set in the configuration files on startup. Not all configuration properties have been exposed as environment variables, those that have not been exposed can be set manually by editing the relevant file in `/ut-server`.

Modification of the configuration files on startup can be disabled by setting LEAVE_CONFIG=True

| Environment variable        | Default value          | Modifies config |
| --------------------------- | ---------------------- | --------------- |
| STARTUP_MAP                 | DM-Turbine             | No              |
| GAME_MODE                   | Botpack.DeathMatchPlus | No              |
| MUTATORS                    |                        | No              |
| SERVER_NAME                 | Another UT Server      | Yes             |
| SERVER_SHORT_NAME           | UT Server              | Yes             |
| ADMIN_NAME                  |                        | Yes             |
| ADMIN_EMAIL                 |                        | Yes             |
| REGION                      | 7                      | Yes             |
| MOTD_LINE1                  |                        | Yes             |
| FASTDL_URL                  |                        | Yes             |
| FASTDL_USE_COMPRESSION      |                        | Yes             |
| NET_MAX_CLIENT_RATE         | 5000                   | Yes             |
| NET_INITIAL_CONNECT_TIMEOUT | 30.0                   | Yes             |
| MAX_PLAYERS                 | 8                      | Yes             |
| MIN_PLAYERS                 | 0                      | Yes             |
| MAX_SPECTATORS              | 2                      | Yes             |
| GAME_PASSWORD               |                        | Yes             |
| ADMIN_PASSWORD              |                        | Yes             |
| WEB_ADMIN_USER              |                        | Yes             |
| WEB_ADMIN_PASSWORD          |                        | Yes             |
| ADVERTISE_SERVER            | True                   | Yes             |
| LEAVE_CONFIG                |                        | No (n/a)        |

---
In addition to packaging the Unreal Tournament server files, the UTPG v451 patch and the "bonus pack" content, this repository also contains code taken from [abfackeln's Server Utilities (ASU)](https://github.com/abfackeln/ut) with modifications to run on Perl 5. ASU is licensed under the GNU General Public License version 3.
