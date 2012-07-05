$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'test/unit'
require 'flexmock'
require 'subito/database'
require 'fakeweb'
require 'flexmock/test_unit'

include Subito
class FakeDb
  def populate_db(args, proc)
    return Hash[*args.collect{|v| proc.call(v)}.flatten]
  end
end

class TestDatabase < Test::Unit::TestCase
  include FlexMock::TestCase

  def setup
    flexmock(Verbose).new_instances(:instance).should_receive(:msg).with_any_args.and_return(nil)
  end
  
  def test_database_must_be_yaml_based_if_sqlite_cant_be_required
    flexmock(Kernel).should_receive(:send).with(:gem,'sqlite3').and_raise(Gem::LoadError)
    assert_kind_of YamlDatabase, Database.instance.db
  end

  def test_must_organize_the_information_in_the_page
    page= <<-EOF
<body>
<select id="qsShow" onchange="showChange(0);" name="qsShow">
<option value="0">     
foo</option>
<option value="2">bar</option>
<option value="56">foobar      </option>
</select>
</body>
EOF
    FakeWeb.register_uri(:get, "http://www.foo.com", :body => page, :content_type =>"text/html" )
    flexmock(SConfig).new_instances(:instance).should_receive(:ressources_subsite_name).and_return("http://www.foo.com")
    flexmock(SConfig).new_instances(:instance).should_receive('yaml_database_data_xpath').and_return("//select/option")
    Database.instance.db= FakeDb.new
    assert_equal(
                  { "foo" => "0",
                    "bar" => "2", 
                    "foobar" => "56"},
                  Database.instance.write )
   end
end
