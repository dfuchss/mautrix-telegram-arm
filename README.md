:warning: **This Fork is discontinued! The images will be outdated!** :warning:

# mautrix-telegram-arm (Fork)
[![Docker Push ARM & Other](https://github.com/dfuchss/mautrix-telegram-arm/actions/workflows/deploy-docker.yml/badge.svg)](https://github.com/dfuchss/mautrix-telegram-arm/actions/workflows/deploy-docker.yml)

This fork aims to provide an arm docker image (e.g. for Raspberry Pi).
Therefore, it uses a modified version of the original Dockerfile to build the image from scratch.

The image is build as `:latest` using Github Actions from the current [master branch](https://github.com/dfuchss/mautrix-telegram-arm/tree/master).

The [image](https://github.com/dfuchss/mautrix-telegram-arm/pkgs/container/mautrix-telegram) will be build once a week (or if triggered manually because I see that there's an update).
The main branch will be kept up to date via cron with upstream.

Use the following as image name: `ghcr.io/dfuchss/mautrix-telegram`

The original README follows ...

# mautrix-telegram
![Languages](https://img.shields.io/github/languages/top/mautrix/telegram.svg)
[![License](https://img.shields.io/github/license/mautrix/telegram.svg)](LICENSE)
[![Release](https://img.shields.io/github/release/mautrix/telegram/all.svg)](https://github.com/mautrix/telegram/releases)
[![GitLab CI](https://mau.dev/mautrix/telegram/badges/master/pipeline.svg)](https://mau.dev/mautrix/telegram/container_registry)

A Matrix-Telegram hybrid puppeting/relaybot bridge.

## Sponsors
* [Joel Lehtonen / Zouppen](https://github.com/zouppen)

### Documentation
All setup and usage instructions are located on
[docs.mau.fi](https://docs.mau.fi/bridges/python/telegram/index.html).
Some quick links:

* [Bridge setup](https://docs.mau.fi/bridges/python/setup/index.html?bridge=telegram)
  (or [with Docker](https://docs.mau.fi/bridges/python/setup/docker.html?bridge=telegram))
* Basic usage: [Authentication](https://docs.mau.fi/bridges/python/telegram/authentication.html),
  [Creating chats](https://docs.mau.fi/bridges/python/telegram/creating-and-managing-chats.html),
  [Relaybot setup](https://docs.mau.fi/bridges/python/telegram/relay-bot.html)

### Features & Roadmap
[ROADMAP.md](https://github.com/mautrix/telegram/blob/master/ROADMAP.md)
contains a general overview of what is supported by the bridge.

## Discussion
Matrix room: [`#telegram:maunium.net`](https://matrix.to/#/#telegram:maunium.net)

Telegram chat: [`mautrix_telegram`](https://t.me/mautrix_telegram) (bridged to Matrix room)

## Preview
![Preview](preview.png)
