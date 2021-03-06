# Naginata [![Build Status](https://travis-ci.org/nikushi/naginata.svg?branch=master)](https://travis-ci.org/nikushi/naginata) [![Coverage Status](https://coveralls.io/repos/nikushi/naginata/badge.svg)](https://coveralls.io/r/nikushi/naginata) [![Gem Version](https://badge.fury.io/rb/naginata.svg)](http://badge.fury.io/rb/naginata)

Naginata is multi nagios server control tool. If you have multiple nagios servers and want to control them from single workstation host by CLI over ssh connection, Naginata is good for you.

Naginata includes `naginata` command executable. `naginata` command can be done by just single command execution from workstation host.

* Enable/Disable notifications of hosts and services.
* Display current host and service status.
* and more

If you already have nagios servers, it's easy to try out Naginata! It does not require to install ruby and Naginata on remote nagio servers.

## Requirements

* Ruby 2.0.0, 2.1.x, 2.2.x, 2.3.x
* Nagios 3.x, 4.x

## Installation

Install naginata on workstation host.

    $ gem install naginata

Or if you use bundler, add this line to your application's Gemfile:

```ruby
gem 'naginata'
```

And then execute:

    $ bundle


## Configuration

Next, create a configuration file from the template. The below command creates _Naginatafile_ on the current working directory.

    $ naginata init

And then edit Naginatafile

```
# Define nagios servers
nagios_server 'foo@nagios1.example.com'
nagios_server 'bar@nagios2.example.com'
nagios_server 'baz@nagios3.example.com'

# Global nagios server options 
set :nagios_server_options, {
  command_file: '/usr/local/nagios/var/rw/nagios.cmd',
  status_file: '/usr/local/nagios/var/status.cmd',
  # If you want to change run user for external commands execution after login
  # to nagios servers, uncomment below and set a proper user name. This is
  # usefull if a login user does not have write or read permission to
  # command_file or status_file.
  run_command_as: 'nagios',
}

# Global SSH options
set :ssh_options, {
  # Currently Naginata only supports remote login with no passphrase.
  keys: %w(/home/nikushi/.ssh/id_rsa),
}
```

## Usage

### Notification

#### Enable(Disable) host and service notifications for specific host

```
$ naginata notification server001 -[e|d]
```

#### Enable(Disable) host and specific service notifications for specific host

```
$ naginata notification server001 -s cpu -[e|d]
```

#### Enable(Disable) host and service notifications for all hosts

```
$ naginata notification -a -[e|d] 
```

#### With regular expression host filter

```
$ naginata notification '^web\d+.+.example.com$' -[e|d]
```

#### Enable(Disable) specific service notifications

```
$ naginata notification -a -s cpu -[e|d] 
```

#### With regular expression service filters

```
$ naginata notification -a -[e|d] -s 'disk.+' -s 'https?'
```

### Active Checks Control

You can enable or disable active checks of hosts and services.

```
$ naginata activecheck [hostpattern...] [OPTIONS]
```

Optinos are same as `naginata notification`. See above examples.

### View service status (Experimental)

#### View service status for all hosts

```
$ naginata services -a
```

Output example:

```
$ naginata services -a
NAGIOS   HOST                 SERVICE          STATUS   FLAGS  OUTPUT
nagios0  localhost            HTTP             WARNING  AC,nt  HTTP WARNING: HTTP/1.1 403 Forbidden - 5152 bytes ...
nagios0  localhost            Current Load     OK       AC,NT  OK - load average: 0.00, 0.00, 0.00
nagios0  localhost            PING             OK       AC,NT  PING OK - Packet loss = 0%, RTA = 0.04 ms
nagios0  redis01.tokyo.local  Load             CRITICAL AC,NT  Too high load average 15
nagios0  redis01.tokyo.local  PING             OK       ac,NT  PING OK - Packet loss = 0%, RTA = 0.04 ms
nagios0  redis01.tokyo.local  SSH              OK       AC,NT  SSH OK - OpenSSH_5.3 (protocol 2.0)
nagios0  web01.tokyo.local    Load             OK       AC,NT  OK - load average: 0.01, 0.00, 0.00
nagios0  web01.tokyo.local    PING             OK       AC,NT  PING OK - Packet loss = 0%, RTA = 0.04 ms
nagios0  web01.tokyo.local    SSH              OK       AC,NT  SSH OK - OpenSSH_5.3 (protocol 2.0)
nagios1  redis01.osaka.local  Load             OK       AC,NT  OK - load average: 0.00, 0.00, 0.00
nagios1  redis01.osaka.local  PING             OK       AC,NT  PING OK - Packet loss = 0%, RTA = 0.04 ms
nagios1  redis01.osaka.local  SSH              OK       AC,NT  SSH OK - OpenSSH_5.3 (protocol 2.0)
...
```


#### View service status for specific hosts

```
$ naginata services web01.example.com db01.example.com
```

#### View service status filtering by services

```
$ naginata services -a -s PING,SWAP
```

### View host status (Experimental)

#### View all host status

```
$ naginata hosts -a
```

Output example:

```
$ naginata hosts -a
NAGIOS   HOST                 STATUS  FLAGS  OUTPUT
nagios0  localhost            OK      AC,NT  PING OK - Packet loss = 0%, RTA = 0.01 ms
nagios0  redis01.tokyo.local  OK      AC,NT  PING OK - Packet loss = 0%, RTA = 0.03 ms
nagios0  web01.tokyo.local    OK      AC,NT  PING OK - Packet loss = 0%, RTA = 0.04 ms
nagios1  localhost            OK      AC,NT  PING OK - Packet loss = 0%, RTA = 0.04 ms
nagios1  redis01.osaka.local  OK      AC,NT  PING OK - Packet loss = 0%, RTA = 0.05 ms
nagios1  web01.osaka.local    OK      AC,NT  PING OK - Packet loss = 0%, RTA = 0.04 ms
```

#### View host status for specific hosts

```
$ naginata hosts web01.example.com db01.example.com
```


### Nagios server filter

You can filter targeted nagios servers with `--nagios=nagiosserver1,..` (or `-N=` shortly) option.

For example:

```
$ naginata notification -a --nagios=nagios1.example.com,nagios2.example.com -e
```

### Global Options

#### Dry run mode

naginata command with `-n` or `--dry-run` runs as dry run mode.

#### Debug output

naginata command with `--debug`

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `bundle exec rake console` for an interactive prompt that will allow you to experiment.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/naginata/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
