$:.unshift File.join(__dir__, '..', 'src')

require 'notifier'
require 'authentication_file'
require 'test/unit'

class NotifierTest < Test::Unit::TestCase

  def test_get_file_path
    abs_path = '/home/matt/test'
    assert_equal(abs_path, AuthenticationFile.parse_path(abs_path))

    assert_equal(File.expand_path(File.join(__dir__, '..', 'test')),
      AuthenticationFile.parse_path('test'))
  end

  def test_create_auth_file
    file_name = 'test_auth_file'

    AuthenticationFile.make_file(file_name, 'name', 'password')

    actual_path = AuthenticationFile.parse_path(file_name)

    assert(File.exist?(actual_path))
    stat = File.stat(actual_path)
    assert_equal('100600', stat.mode.to_s(8))
    assert_equal(1, File.delete(actual_path))
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
