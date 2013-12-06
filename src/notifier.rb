#!/usr/bin/ruby

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

  end

  def send(to, subject, body)
    msg = "Subject: #{subject}\n\n#{body}"
    smtp = Net::SMTP.new 'smtp.gmail.com', 587
    smtp.enable_starttls
    smtp.start('Hazmatt', @login, @password, :login) do
      smtp.send_message(msg, @login, to)
    end
  end

end

class AuthenticationFile

  def initialize(path)
    @path = AuthenticationFile.parse_path(path)
  end

  def AuthenticationFile.parse_path(path)
    if path.start_with?('/')
      path
    else
      File.expand_path(File.join(__dir__, '..', path))
    end
  end

  def AuthenticationFile.make_file(path, name, password)
    user = Process::Sys.getuid

    if user != 0
      raise SecurityError, 'Only root can make an authentication file.'
    end

    whitespace = /\s/
    if name =~ whitespace || password =~ whitespace
      raise 'User names and passwords cannot contain whitespace.'
    end

    parsed_path = parse_path(path)
    
    File.open(parsed_path, 'w') { |f| f.write("#{name} #{password}") }
    
    File.chmod(0600, parsed_path)
    File.chown(0, 0, parsed_path)
  end

  def parse
    s = File.open(@path) { |f| f.readline }

    s.rstrip.split
  end
  
end
