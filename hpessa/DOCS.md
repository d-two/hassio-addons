# Home Assistant Community Add-on: HPE Smart Storage Administrator

HPE Smart Storage Administrator (HPE SSA) offers a single interface that quickly sets up, configures and manages the HPE Smart Array controllers and the HPE SAS Host Bus Adapters (HBAs).

## Installation

The installation of this add-on is pretty straightforward and not different in
comparison to installing any other Home Assistant add-on.

1. Search for the "HPE Smart Storage Administrator" add-on in the Supervisor add-on store and install it.
1. Start the "HPE Smart Storage Administrator" add-on.
1. Check the logs of the "HPE Smart Storage Administrator" to see if everything went well.
1. Click the "OPEN WEB UI" button!

## Configuration

**Note**: _Remember to restart the add-on when the configuration is changed._

Example add-on configuration:

```yaml
ssl: true
certfile: fullchain.pem
keyfile: privkey.pem
```

**Note**: _This is just an example, don't copy and paste it! Create your own!_

### Option: `log_level`

The `log_level` option controls the level of log output by the addon and can
be changed to be more or less verbose, which might be useful when you are
dealing with an unknown issue. Possible values are:

- `trace`: Show every detail, like all called internal functions.
- `debug`: Shows detailed debug information.
- `info`: Normal (usually) interesting events.
- `warning`: Exceptional occurrences that are not errors.
- `error`:  Runtime errors that do not require immediate action.
- `fatal`: Something went terribly wrong. Add-on becomes unusable.

Please note that each level automatically includes log messages from a
more severe level, e.g., `debug` also shows `info` messages. By default,
the `log_level` is set to `info`, which is the recommended setting unless
you are troubleshooting.

### Option: `lang`

Supported languageCode/languages are:

- `en`: English (default)
- `ja`: Japanese
- `de`: German
- `es`: Spanish
- `fr`: French
- `it`: Italian
- `pt`: Portuguese
- `ru`: Russian
- `zh`: Simplified Chinese

### Option: `ssl`

Enables/Disables SSL (HTTPS) on the web interface.
Set it `true` to enable it, `false` otherwise.

### Option: `certfile`

The certificate file to use for SSL.

**Note**: _The file MUST be stored in `/ssl/`, which is the default_

### Option: `keyfile`

The private key file to use for SSL.

**Note**: _The file MUST be stored in `/ssl/`, which is the default_

### Option: `leave_front_door_open`

Adding this option to the add-on configuration allows you to disable
authentication on the Web Terminal by setting it to `true` and leaving the
username and password empty.

**Note**: _We STRONGLY suggest, not to use this, even if this add-on is
only exposed to your internal network. USE AT YOUR OWN RISK!_
