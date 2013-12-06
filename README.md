# FreezeWatch #

FreezeWatch is a weather polling service designed to alert a user when the
outside temperature is going to drop below a preset safe limit.

## Uses ##

FreezeWatch was originally designed to assist me with gardening in the later
fall and early spring. It has saved me from losing my tomato plants to frost
several times.

I've also found a use for it in the deep winter. I configure my minimum
temperature to alert me if the temperature will drop below 0, so that I can
take measures to prevent the pipes in our house from freezing.

Pretty handy!

## Pre Requisites ##

- Ruby 2.0 or greater
- Bundler ruby gem

## Installation ##

A task is provided in the rakefile to make installation quick and easy. When
you run the rake task, you'll be prompted for the necessary information needed
to get FreezeWatch up and running. These settings can be changed at anytime
after the installation by editing the `freezewatch.yaml` file that will be
created by the installer.

    git clone https://github.com/mgarriott/freezewatch.git
    cd freezewatch/
    bundle install
    bundle exec rake install

*If you experience any issues with installation please read the sections
below*

### Compatibility ###

FreezeWatch was designed on arch linux and little concern was given to cross
platform compatibility. I'm not opposed to supporting other platforms, but I
have no intention to do so unless people express an interest.

### Users With Systemd ###

Barring unforeseen problems, the application should work on most platforms.
Please open an issue if you experience difficulties.

### Users Without Systemd ###

If your system isn't running systemd, expect to see an error when the
installer attempts to create the service file. However, this shouldn't affect
the applications configuration as a whole.

Because the systemd service file will not be installed, FreezeWatch must be
manually started. This can be done with the following:

    # We need to execute the program as root to read the authentication file
    sudo bundle exec ruby /path/to/freezewatch/src/freezewatch_daemon.rb start

FreezeWatch can be started automatically on login by adding the following line
to your `~/.profile` file. Most likely you'll need to add an entry to your
sudoers file to allow this to run without a password, or it will fail to read
the authentication file.

    sudo bundle exec ruby /path/to/freezewatch/src/freezewatch_daemon.rb start

## Uninstalling ##

A rake task is also provided for uninstalling.

    bundle exec rake uninstall

This will remove the systemd service file created during installation (if one
was created).

If you previously enabled the service with:

    systemctl enable freezewatch.service

Then you need to disable the service with:

    systemctl disable freezewatch.service

## Contributing ##

If you are interesting in contributing to FreezeWatch please ensure your
commits follow a few simple guidelines.

- Avoid trailing whitespace.
- Format commit messages in the imperative present tense.

## License ##

BSD 2-Clause (see LICENSE file).
