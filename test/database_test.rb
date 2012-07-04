$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'test/unit'
require 'flexmock'
require 'subito/database'

require 'flexmock/test_unit'

include Subito
class TestDatabase < Test::Unit::TestCase
  include FlexMock::TestCase
  def test_database_must_be_yaml_based_if_sqlite_cant_be_required
    flexmock(Kernel).should_receive(:send).with(:gem,'sqlite3').and_raise(Gem::LoadError)
    assert_kind_of YamlDatabase, Database.instance.db
  end
end
