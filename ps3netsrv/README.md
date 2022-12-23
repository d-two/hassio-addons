# Docker container for ps3netsrv (or ps3netsvr)
This is a Docker container for ps3netsrv (or ps3netsvr).

---

ps3netsrv for WebMAN-MOD by [aldostools](https://github.com/aldostools). Binaries built from the latest sources.

---
## Supported Architectures

The architectures supported by this image are:

| Architecture | Status |
| :----: | ------ |
| x86-64 | untested |
| x86 | untested |
| arm64 | working |
| armv7 |  untested |
| armhf | untested |

## Quick Start

  - `media/ps3netsrv`: This location contains files from your host that need to be accessible by the application.

### Ports

| Port | Mapping to host | Description |
|------|-----------------|-------------|
| 38008 | Mandatory | Port used for ps3netsrv. |
