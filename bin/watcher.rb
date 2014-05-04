$:.unshift File.join(__dir__, "..", 'lib')

require 'bundler/setup'
require 'notifier'
require 'date'
require 'weather'
require 'syslog'
require 'yaml'

config = YAML.load_file(File.join(__dir__, '..', 'freezewatch.yaml'))

def log(msg)
  unless Syslog.opened?
    Syslog.open("FreezeWatch", Syslog::LOG_PID)
  end

  Syslog.log(Syslog::LOG_INFO, msg)
  Syslog.close()
end

log("Started successfully, Min Temp = #{config[:min_safe_temp]}, " +
    "Sleep Time = #{config[:sleep_time]}, ZipCode = #{config[:zip_code]}, " +
    "To = #{config[:to].join(' ')}")

below_freezing = false
last_date = Date.today()
while(true)
  min_temp = Weather.get_min_temp(config[:zip_code])
  today = Date.today()

  log("Weather data gathered. Minimum temperature = #{min_temp}")

  if (last_date != today)
    log("New day beginning...")
    # We are on to a new day reset the variable
    below_freezing = false
  end

  notifier = Notifier.new(
    auth_file: AuthenticationFile.new(File.join(__dir__, '..', '.auth_file')),
    server_address: config[:server_address],
    port: config[:port]
  )

  if min_temp.to_i < config[:min_safe_temp].to_i && !below_freezing
    log("Temperature below safe minimum. Sending alert email...")

    notifier.send(config[:to], 'FreezeWatch: Frost Warning!',
      "The prospective minimum temperature has dropped below safe limits.\n" +
      "Prospective temperature: #{min_temp} degrees at #{Time.now}")
    below_freezing = true
  elsif min_temp.to_i >= config[:min_safe_temp].to_i && below_freezing
    log("Temperature now above safe minimum. Sending info email...")

    notifier.send(config[:to], 'FreezeWatch: Temperature Raised',
      "You might be off the hook. The predicted minimum temperature has " +
      "climbed above your minimum safe temperature.\n" +
      "Prospective temperature: #{min_temp} degrees at #{Time.now}")
    below_freezing = false
  end

  last_date = today

  sleep(config[:sleep_time])
end
