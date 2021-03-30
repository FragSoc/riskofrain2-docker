# Steam Dedicated Server Docker Template

A repo to save time setting up new docker images.

## Template Usage

1. Create a new repo from this template (see [here](https://docs.github.com/en/free-pro-team@latest/github/creating-cloning-and-archiving-repositories/creating-a-repository-from-a-template)).
2. Run `sed -i -e 's/GAME_NAME/<name of your game, or an abbreviation>/g' Dockerfile`
3. Go through the `Dockerfile` and address all the comments prepended with `REPO_SETUP:`
4. Rewrite this `README` file

## Build Args

This template comes with four build arguments:

- `APPID` for changing the steam appid, this might be desirable if your game has multiple distinct versions on steam
- `UID` and `GID` for changing the user and group IDs of the user inside the container, they both default to `999`
- `STEAM_BETAS` for specifying a steam beta string for the game, defaults to a blank string
