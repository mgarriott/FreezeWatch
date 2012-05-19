#!/usr/bin/ruby

require 'net/smtp'

class Notifier

  def initialize(login = nil, password = nil, domain = 'Hazmatt', auth_file = nil)
    if (login.nil? || password.nil?) && auth_file.nil?
      raise ArgumentException "You must either provide a login, " +
                    "and password or an authentication file."
    end

    if not auth_file.nil?
      @login, @password = auth_file.parse
    else
      @login = login
      @password = password
    end
    @domain = domain
  end

  def send(to, subject, body)
    msg = "Subject: #{subject}\n\n#{body}"
    smtp = Net::SMTP.new 'smtp.gmail.com', 587
    smtp.enable_starttls
    smtp.start(@domain, @login, @password, :login) do
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
      File.expand_path(File.join(File.dirname(__FILE__), path))
    end
  end

  def AuthenticationFile.make_file(path, name, password)
    user = `whoami`.chomp

    if user != 'root'
      raise SecurityError, 'Only root can make an authentication file.'
    end

    whitespace = /\s/
    if name =~ whitespace || password =~ whitespace
      raise 'User names and passwords cannot contain whitespace.'
    end

    parsed_path = parse_path(path)
    
    File.open(path, 'w') { |f| f.write("#{name} #{password}") }
    
    File.chmod(0600, path)
    File.chown(0, 0, path)
  end

  def parse
    s = File.open(@path) { |f| f.readline }

    s.rstrip.split
  end
  
end

#n = Notifier.new('matt.garriott@gmail.com', 'ProtestTheH3r0')
#n.send({
#  :subject => 'TestMessage',
#  :body => 'This is a test message',
#  :to => 'matt.garriott@gmail.com'
#})
