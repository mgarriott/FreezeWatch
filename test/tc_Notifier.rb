#!/usr/bin/ruby

$:.unshift File.join(File.dirname(__FILE__), "..")

require 'Notifier'
require 'test/unit'

class NotifierTest < Test::Unit::TestCase
  
  def test_get_file_path
    abs_path = '/home/matt/test'
    assert_equal(abs_path, AuthenticationFile.parse_path(abs_path))

    assert_equal('/home/matt/programming/ruby/FreezeWatch/test', 
      AuthenticationFile.parse_path('test'))
  end

  def test_create_auth_file
    user = `whoami`.chomp
    file_name = 'test_auth_file'
    make_file = lambda { 
      AuthenticationFile.make_file(file_name, 'name', 'password')
    }

    if user == 'root'
      make_file.call
      assert(File.exist?(file_name))
      stat = File.stat(file_name)
      assert_equal(0, stat.gid)
      assert_equal(0, stat.uid)
      assert_equal('100600', stat.mode.to_s(8))
      assert_equal(1, File.delete(file_name))
    else
      assert_raise(SecurityError) { make_file.call }
    end
  end

  def test_create_bad_input
    file_name = 'test_auth_file'
    bad_name = 'test name'
    bad_pass = 'bad pass'

    assert_raise(RuntimeError) { 
      AuthenticationFile.make_file(file_name, bad_name, 'okaypass')
    }

    assert_raise(RuntimeError) { 
      AuthenticationFile.make_file(file_name, 'okayname', bad_pass)
    }

    assert_equal(false, File.exists?(file_name))
  end

  def test_create_and_parse_round_trip
    file_name = 'test_auth_file'
    name = 'testname'
    password = 'testpassword'

    AuthenticationFile.make_file(file_name, name, password)

    af = AuthenticationFile.new(file_name)

    actual_name, actual_pass = af.parse

    assert_equal(name, actual_name)
    assert_equal(password, actual_pass)
  end

end
