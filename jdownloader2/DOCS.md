# Home Assistant Add-on: JDownloader 2

JDownloader is a free, open-source download management tool with a huge community of developers that makes downloading as easy and fast as it should be. Users can start, stop or pause downloads, set bandwith limitations, auto-extract archives and much more. It's an easy-to-extend framework that can save hours of your valuable time every day!

## Installation

The installation of this add-on is pretty straightforward and not different in
comparison to installing any other Home Assistant add-on.

1. Search for the "JDownloader 2" add-on in the Supervisor add-on store and
   install it.
1. Check the Configuration
1. Start the "JDownloader 2" add-on.
1. Check the logs of the "JDownloader 2" to see if everything went well.
1. Ready to go!

## Configuration

**Note**: _Remember to restart the add-on when the configuration is changed._

Example add-on configuration:

```yaml
email: home@assistant.de
password: fancy
device_name: JD2 by HomeAssistant
```

**Note**: _This is just an example, don't copy and paste it! Create your own!_

### Option: `email`

The MyJDownloader account e-mail. Is written automatically to config-file.

### Option: `password`

The MyJDownloader account password. Is written automatically to config-file.

### Option: `device_name`

The device name that will appear on MyJdownloader portal
