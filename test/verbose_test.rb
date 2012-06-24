$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'test/unit'
require 'subito/verbose'

include Subito 
class VerboseTest < Test::Unit::TestCase
  def test_must_output_a_message_if_message_has_to_be_displayed_by_default_and_enable_if_false
    r, w = IO.pipe
    Verbose.enable = false
    Verbose.io = w
    Verbose.logger = Logger.new nil
    verbose = Verbose.instance
    verbose.msg('hello world',:default)
    w.close
    ret = r.read
    r.close
    Verbose.reset_instance
    assert_equal  "hello world\n", ret
  end
  
  def test_must_not_display_anything_if_settings_isnt_default_and_enable_is_false
    r, w = IO.pipe
    Verbose.enable = false
    Verbose.io = w
    Verbose.logger = Logger.new nil
    verbose = Verbose.instance
    verbose.msg('hello world')
    w.close
    ret = r.read
    r.close 
    Verbose.reset_instance
    assert_not_equal  "hello world\n", ret
  end


  def test_must_display_an_info_message_if_enable_is_set_and_setting_is_info
    r, w = IO.pipe
    Verbose.enable = true
    Verbose.io = w
    Verbose.logger = Logger.new w
    verbose = Verbose.instance
    verbose.msg('hello world', :info)
    w.close
    ret = r.read
    r.close
    Verbose.reset_instance
    assert_match %r|^I,\s*\[.*\]\s*INFO.*hello\sworld.*|, ret
  end 

  def test_must_display_a_warning_message_if_enable_is_set_and_setting_is_warn
    r, w = IO.pipe
    Verbose.enable = true
    Verbose.io = w
    Verbose.logger = Logger.new w
    verbose = Verbose.instance
    verbose.msg('hello world', :warn)
    w.close
    ret = r.read
    r.close
    Verbose.reset_instance
    assert_match %r|^W,\s*\[.*\]\s*WARN.*hello\sworld.*|, ret
  end
 
end
