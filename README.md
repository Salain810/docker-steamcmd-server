# SteamCMD Docker Server with Steam Guard Support

A Docker container that provides a SteamCMD server with integrated Steam Guard support using [steamguard-cli](https://github.com/dyc3/steamguard-cli). This container supports automatic 2FA code generation during login and server updates.

## Example Env params for CS:Source
| Name | Value | Example |
| --- | --- | --- |
| STEAMCMD_DIR | Folder for SteamCMD | /serverdata/steamcmd |
| SERVER_DIR | Folder for gamefile | /serverdata/serverfiles |
| GAME_ID | The GAME_ID that the container downloads at startup. If you want to install a static or beta version of the game change the value to: '232330 -beta YOURBRANCH' (without quotes, replace YOURBRANCH with the branch or version you want to install). | 232330 |
| GAME_NAME | SRCDS gamename | cstrike |
| GAME_PARAMS | Values to start the server | -secure +maxplayers 32 +map de_dust2 |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| GAME_PORT | Port the server will be running on | 27015 |
| VALIDATE | Validates the game data | blank |
| USERNAME | Leave blank for anonymous login | blank |
| PASSWRD | Leave blank for anonymous login | blank |
| STEAM_SHARED_SECRET | Steam Guard shared secret for 2FA | ABC123... |
| STEAM_IDENTITY_SECRET | Steam Guard identity secret for 2FA | DEF456... |

## Steam Guard Authentication
To use Steam Guard authentication:
1. Set your Steam username and password using `USERNAME` and `PASSWRD`
2. Set your Steam Guard secrets using `STEAM_SHARED_SECRET` and `STEAM_IDENTITY_SECRET`
3. The container will automatically generate and use Steam Guard codes during login

If Steam Guard secrets are not provided, the container will attempt to log in without 2FA.

## Run Examples

### Without Steam Guard (anonymous login)
```bash
docker run --name CSSource -d \
    -p 27015:27015 -p 27015:27015/udp \
    --env 'GAME_ID=232330' \
    --env 'GAME_NAME=cstrike' \
    --env 'GAME_PORT=27015' \
    --env 'GAME_PARAMS=-secure +maxplayers 32 +map de_dust2' \
    --env 'UID=99' \
    --env 'GID=100' \
    --volume /path/to/steamcmd:/serverdata/steamcmd \
    --volume /path/to/cstrikesource:/serverdata/serverfiles \
    Salain810/steamcmd:latest
```

### With Steam Guard Authentication
```bash
docker run --name CSSource -d \
    -p 27015:27015 -p 27015:27015/udp \
    --env 'GAME_ID=232330' \
    --env 'GAME_NAME=cstrike' \
    --env 'GAME_PORT=27015' \
    --env 'GAME_PARAMS=-secure +maxplayers 32 +map de_dust2' \
    --env 'UID=99' \
    --env 'GID=100' \
    --env 'USERNAME=your_username' \
    --env 'PASSWRD=your_password' \
    --env 'STEAM_SHARED_SECRET=your_shared_secret' \
    --env 'STEAM_IDENTITY_SECRET=your_identity_secret' \
    --volume /path/to/steamcmd:/serverdata/steamcmd \
    --volume /path/to/cstrikesource:/serverdata/serverfiles \
    Salain810/steamcmd:latest
```

## Credits and Attribution

- Original SteamCMD Docker server by [ich777](https://github.com/ich777/docker-steamcmd-server)
- Steam Guard support using [steamguard-cli](https://github.com/dyc3/steamguard-cli)

## License

This project is licensed under the MIT License - see the LICENSE file for details.