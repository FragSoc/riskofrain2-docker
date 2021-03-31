![Risk of Rain 2 Banner](https://britgamer.s3.eu-west-1.amazonaws.com/styles/full_width_image/s3/2020-03/risk-of-rain-2-banner.jpg)

<div align="center">
  <a href="https://travis-ci.com/github/FragSoc/riskofrain2-docker"><img src="https://img.shields.io/travis/com/FragSoc/riskofrain2-docker?style=flat-square"/></a>
  <a href="https://github.com/FragSoc/riskofrain2-docker"><img src="https://img.shields.io/github/license/fragsoc/riskofrain2-docker?style=flat-square"/></a>
  </br>
  <img src="https://img.shields.io/badge/BepInEx-5.3.1-blueviolet?style=flat-square"/>
  <img src="https://img.shields.io/badge/R2API-2.5.14-blueviolet?style=flat-square"/>
  <img src="https://img.shields.io/badge/EnigmaticThunder-0.1.1-blueviolet?style=flat-square"/>
</div>

---

# Usage

### Quickstart

```bash
$ docker build -t fragsoc/riskofrain2 .
$ docker run -p 27015:27015/udp -p 27016:27016/udp fragsoc/riskofrain2
```

### Building

The image takes several build args, passed with `--build-arg` to the `docker build` command:

Argument Key | Default Value | Description
---|---|---
`APPID` | `1180760` | The steam appid to install, there's little reason to change this
`STEAM_BETAS` | | A string to pass to `steamcmd` to download any beta versions of the game, eg. `-beta mybeta -betapassword letmein`
`UID` | `999` | The user ID to assign to the created user within the container
`GID` | `999` | The group ID to assign to the created user's primary group within the container
`GAME_PORT` | `27015` | The port to assign and expose for the game server
`STEAM_PORT` | `27016` | The port to assign and expose for the steam service

#### Subtargets

There are several [docker subtargets](https://docs.docker.com/develop/develop-images/multistage-build/) you can select to use different modifications to the game.
To select a target, add `--target=targetname` to your `docker build` command.

Target Name | Description
---|---
`vanilla` | A vanilla installation of the server.
`bepinex` | A server with only [BepInEx](https://github.com/BepInEx/BepInEx) installed. Takes an additional build argument, `BEPINEX_VERSION`.
`r2api` | A server with BepInEx and [R2API](https://github.com/risk-of-thunder/R2API) installed. Takes the argument from `bepinex` and an additional build argument `R2API_VERSION`.
`enigmaticthunder` | A server with BepInEx and [EnigmaticThunder](https://thunderstore.io/package/EnigmaDev/EnigmaticThunder/) installed. Takes the argument from `bepinex` and an additional argument `ENIGMATIC_THUNDER_VERSION`. **If you do not specify a target manually, this is the default version that will be built**.

If the `*_VERION` args are omitted, they will default to the versions shown in the badges above.

### Running

The container requires 2 ports, `27015` and `27016` over UDP (or whatever you overrode them to in the build args).

The container comes with one volume, `/plugins`, where you should place mod files (`.dll`s) in order to load them into the game.
See the [Risk of Rain 2 Modding Wiki](https://github.com/risk-of-thunder/R2Wiki/wiki) for more information.

The container takes several environment variables:

Variable Key | Default Value | Description
---|---|---
`GAME_NAME` | `A dockerised Risk of Rain 2 Server` | The name of the server to be displayed in the steam server list
`GAME_PASSWORD` | `letmein` | The password to connect to the server, set to blank to disable
`MAX_PLAYERS` | `4` | The maximum allowed number of players in the server

If you need more fine-grained control over the server configuration, you can bind mount over the `/server.cfg` file in the container, overriding anything you set with the environment vars.

# Licensing

The few files in this repo are licensed under the AGPL3 license.
However, Risk of Rain 2 and it's dedicated server are proprietary software licensed by [Hopoo Games](https://hopoogames.com/), no credit is taken for their software in this container.
See the [ROR2 EULA](https://store.steampowered.com/eula/632360_eula_0) for more information.
