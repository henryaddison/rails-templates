# Landmrk Brain

This Rails app powers the CMS part of a the Landmrk Brain system used by clients and, via a Rails Engine, the End User API used by the public campaign apps.

## Dependencies

* Ruby
See `.ruby-version` and `Dockerfile` for version of Ruby.
Advise using `rbenv` to manage Ruby versions on local development machine.

* Bundler

* Redis and PostgreSQL databases
Use docker-compose config to manage these in development.

## Setup for development

0. Clone this repo

1. Configure:
  * mainly with environment variables (see [[#configuration-environment-variables]] for more details of environment variables).
  Create a suitable `.env` for your own machine based on committed `.env.example`.
  * some encrypted credentials in `config/credentials.yml.enc`.
  You will need a copy of the `master.key` file to decrypt these.

2. Clone down [landmrk-frontend](https://github.com/simpleweb/landmrk-frontend) into the root of this project

3. `script/setup`


### Configuration environment variables


* `API_BASE_URL` - where to find the API endpoint used by the campaign apps
* `CMS_TMP_PATH` - directory where CMS stores temp files
* `DATABASE_HOST`
* `DATABASE_PASSWORD`
* `DATABASE_PORT`
* `DATABASE_USER`
* `EU_APPS_CLOUDFRONT_DISTRIBUTION_ID` (not required for development) - distribution id of the CloudFront caching of the campaign apps
* `EU_APPS_PUBLIC_URL` - URL where the campaign apps are hosted
* `EU_APPS_PUBLIC_S3_BUCKET` (not required for development) - S3 bucket where campaign apps are 
* `EU_APPS_PUBLIC_S3_BUCKET_REGION` (not required for development) - region of S3 bucket above
* `EU_APPS_TEMPLATE_DOWNLOAD_URL` (not required for development) - where to find the campaign app template
* `LEEROY_TMP_PATH` - directory where generator pipeline stores temp files

## Basic Dev Usage

Most common tasks are automated with scripts in the [[script]] directory.
Please keep these up-to-date as the app changes or new tasks become common.

**Server**: `script/serve`

**Serve published frontend after it has built**: `script/start_frontend <campaign uuid>`

**Tests**: `script/test`

**Console**: `script/console`

**Update** (things like migrations):`script/update`

**Arbitrary commands**:
Prepend with `docker-compose run --rm web` for running against the main app
or `docker-compose run --rm -w /usr/src/app/end_user_api web` for running against the End User API engine.
(Or you can save some time using `exec` rather than `run` if you know what you're doing and already running the service).

## Debugging

To make use of **byebug** in conjunction with Docker, add the following to the `web:` section of [docker-compose.yml](docker-compose.yml):

```yaml
version: '3'
services:
  web:
    # <SNIP>
    # Keep STDIN open to interact with byebug
    stdin_open: true
    tty: true
```

You can then attach to the shell session by using;

```shell
$ docker attach landmrk-brain_web_1
```

To detach without killing the rails server, use <kbd>Ctrl</kbd> + <kbd>P</kbd>, <kbd>Ctrl</kbd> + <kbd>Q</kbd>

## Deployment

[See docs](docs/DevOps.md)

## Styleguides

The Ruby code uses [a modified version](.rubocop.yml) of the default Rubocop styleguide.

The bash scripts that make up leeroy attempt to follow the [Google shell script styleguide](https://google.github.io/styleguide/shell).

## Doc moar

[Would you like to know more?](docs/)
