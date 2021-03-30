![](https://britgamer.s3.eu-west-1.amazonaws.com/styles/full_width_image/s3/2020-03/risk-of-rain-2-banner.jpg)

![GitHub](https://img.shields.io/github/license/fragsoc/riskofrain2-docker?style=flat-square)

---

# Usage

## Quickstart

```bash
$ docker build -t fragsoc/riskofrain2 .
$ docker run -p 27015:27105 -p 27016:27016 fragsoc/riskofrain2
```

## Building

The image takes several build args, passed with `--build-arg` to the `docker build` command:

Argument Key | Default Value | Description
---|---|---
`APPID` | `1180760` | The steam appid to install, there's little reason to change this
`STEAM_BETAS` | | A string to pass to `steamcmd` to download any beta versions of the game
`UID` | `999` | The user ID to assign to the created user within the container
`GID` | `999` | The group ID to assign to the created user's primary group within the container
`GAME_PORT` | `27015` | The port to assign and expose for the game server
`STEAM_PORT` | `27016` | The port to assign and expose for the steam service

## Running

The container requires 2 ports, `27015` and `27016` (or whatever you overrode them to in the build args).

The container takes several environment variables:

Variable Key | Default Value | Description
---|---|---
`GAME_NAME` | `A dockerised Risk of Rain 2 Server` | The name of the server to be displayed in the steam server list
`GAME_PASSWORD` | `letmein` | The password to connect to the server
`MAX_PLAYERS` | `4` | The maximum allowed number of players in the server

# Modded Variant

A variant of the server with [BepInExPack]() and [R2API]() is available by building using `bepapi.Dockerfile`.
This variant comes with one volume, `/mods`, where you should place mod files in order to load them into the game.

See the [Risk of Rain 2 Modding Wiki](https://github.com/risk-of-thunder/R2Wiki/wiki) for more information.

# Licensing

The few files in this repo are licensed under the AGPL3 license.
However, Risk of Rain 2 and it's dedicated server are proprietary software licensed by [Hopoo Games](https://hopoogames.com/), no credit is taken for their software in this container.
See the [ROR2 EULA](https://store.steampowered.com/eula/632360_eula_0) for more information.
