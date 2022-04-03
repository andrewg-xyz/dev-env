# dev-env

Development environment configuration and utilities. A collection of software gadgetry to make it easier to port my development environment. 

Suggestions and ideas are welcome! Start with reviewing existing or submitting an issue.

## Initial Setup
```shell
git clone https://github.com/andrewsgreene/dev-env.git
export DEVENV=`pwd`/dev-env
# !!!WARNING!!! running this script assumes things, make sure you read it and are okay with what it is doing.
./$DEVENV/configure.sh
```

Rerun `./$DEVENV/configure.sh` as much as you'd like, make changes to resources and rerun. 

## More details

### `configure.sh`

The `configure.sh` script is built to be ran independently and repeatably to setup or update your development environment. 

It uses:
- `osx/Brewfile` for apps to install/update
- `resources` directory for various configuration files (i.e. .zshrc)
- `resources/buzzbert` directory to hold 'sensitive' data like `/etc/hosts`, ssh config, or special aliases. DO NOT COMMIT HERE.