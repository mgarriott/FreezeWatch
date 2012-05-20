#!/usr/bin/ruby

require 'date'
require 'weather'
require 'notifier'

MIN_SAFE_TEMP = 40
SLEEP_TIME = 3600

while(true)
  min_temp = Weather.get_min_temp('82801')

  if min_temp.to_i < MIN_SAFE_TEMP
    notifier = Notifier.new({ :auth_file => AuthenticationFile.new('auth_file')})
    notifier.send('matt.garriott@gmail.com', 'FreezeWatch: Frost Warning!',
      "The prospective minimum temperature has dropped below safe limits.\n" +
      "Prospective temperature: #{min_temp} at #{Time.now}")
  end

  sleep(SLEEP_TIME)
end
