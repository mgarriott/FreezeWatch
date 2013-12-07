require 'net/smtp'

class Notifier

  def initialize(params)
    if (params[:login].nil? || params[:password].nil?) && params[:auth_file].nil?
      raise ArgumentError, "You must either provide a login, " +
                    "and password or an authentication file."
    end

    if not params[:auth_file].nil?
      @login, @password = params[:auth_file].parse
    else
      @login = params[:login]
      @password = params[:password]
    end

    @server_address = params[:server_address]
    @port = params[:port]
  end

  def send(to, subject, body)
    msg = "Subject: #{subject}\n\n#{body}"
    smtp = Net::SMTP.new(@server_address, @port)
    smtp.enable_starttls
    smtp.start('FreezeWatch', @login, @password, :login) do
      smtp.send_message(msg, @login, to)
    end
  end
end
