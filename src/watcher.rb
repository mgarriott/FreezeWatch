$:.unshift File.join(__dir__, ".")

require 'date'
require 'weather'
require 'notifier'
require 'syslog'

MIN_SAFE_TEMP = 38
SLEEP_TIME = 3600

TO = ['matt.garriott@gmail.com', 'ashley.erin.roberts@gmail.com']

def log(msg)
  unless Syslog.opened?
    Syslog.open("FreezeWatch", Syslog::LOG_PID)
  end

  Syslog.log(Syslog::LOG_INFO, msg)
  Syslog.close()
end

log("Started successfully")

below_freezing = false
last_date = Date.today()
while(true)
  min_temp = Weather.get_min_temp('82801')
  today = Date.today()

  log("Weather data gathered. Minimum temperature = #{min_temp}")

  if (last_date != today)
    log("New day beginning...")
    # We are on to a new day reset the variable
    below_freezing = false
  end

  if min_temp.to_i < MIN_SAFE_TEMP && !below_freezing
    log("Temperature below safe minimum. Sending alert email...")

    notifier = Notifier.new(:auth_file => AuthenticationFile.new('auth_file'))
    notifier.send(TO, 'FreezeWatch: Frost Warning!',
      "The prospective minimum temperature has dropped below safe limits.\n" +
      "Prospective temperature: #{min_temp} degrees at #{Time.now}")
    below_freezing = true
  elsif min_temp.to_i >= MIN_SAFE_TEMP && below_freezing
    log("Temperature now above safe minimum. Sending info email...")

    notifier = Notifier.new({ :auth_file => AuthenticationFile.new('auth_file')})
    notifier.send(TO, 'FreezeWatch: Temperature Raised',
      "You might be off the hook. The predicted minimum temperature has " +
      "climbed above your minimum safe temperature.\n" +
      "Prospective temperature: #{min_temp} degrees at #{Time.now}")
    below_freezing = false
  end

  last_date = today

  sleep(SLEEP_TIME)
end
