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

    git clone https://github.com/mgarriott/FreezeWatch.git
    cd FreezeWatch/
    bundle install
    bundle exec rake install

*If you experience any issues with installation please read the sections
below*

### Compatibility ###

FreezeWatch was designed on arch linux and little concern was given to cross
platform compatibility. I'm not opposed to supporting other platforms, but I
have no intention to do so unless people express an interest.

### Users With Systemd ###

During the `rake install` process a systemd service file will be created. You
can move this file into your systemd services directory and use it as you would any
other systemd service.

    sudo mv /path/to/FreezeWatch/systemd/freezewatch.service /usr/lib/systemd/system/

    # Start the freezewatch service
    sudo systemctl start freezewatch.service

    # Enable freezewatch startup on boot
    sudo systemctl enable freezewatch.service

Barring unforeseen problems, the application should work on most platforms.
Please open an issue if you experience difficulties.

### Users Without Systemd ###

If you are not using systemd, the daemon must be started manually. This can be
done with the following:

    bundle exec ruby /path/to/FreezeWatch/src/freezewatch_daemon.rb start

FreezeWatch can be started automatically on login by adding the following line
to your `~/.profile` file.

    bundle exec ruby /path/to/FreezeWatch/src/freezewatch_daemon.rb start

You can see examples of other daemon commands by running:

    bundle exec ruby /path/to/FreezeWatch/src/freezewatch_daemon.rb -h

## Uninstalling ##

If you copied the systemd service file into your systemd service directory you
can delete it.

If you previously enabled the service with:

    systemctl enable freezewatch.service

Then you need to disable the service with:

    systemctl disable freezewatch.service

That's it, other than the systemd file, the application runs entirely from the
directory you clone it into.

## Contributing ##

If you are interesting in contributing to FreezeWatch please ensure your
commits follow a few simple guidelines.

- Avoid trailing whitespace.
- Format commit messages in the imperative present tense.

## License ##

BSD 2-Clause (see LICENSE file).
