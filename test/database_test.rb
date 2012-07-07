$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'test/unit'
require 'flexmock'
require 'subito/database'
require 'fakeweb'
require 'flexmock/test_unit'

include Subito
class FakeDb
  attr_accessor :filename
  def populate_db(args, proc)
    return Hash[*args.collect{|v| proc.call(v)}.flatten]
  end

  def find_id(name)
     { "foo" => "0",
      "bar" => "2", 
      "foobar" => "56"}[name]
  end

  def process proc
    {
      "fubar"=>12, 
      "fobar"=>15,
      "fooobar"=>19,
      "toto"=>1 }.select do |k,v|
      proc.call(k)
    end
  end
end

class TestDatabase < Test::Unit::TestCase
  include FlexMock::TestCase

  def setup
    flexmock(Verbose).new_instances(:instance).should_receive(:msg).with_any_args.and_return(nil)
    flexmock(Kernel).should_receive(:send).with(:gem,'sqlite3').and_raise(Gem::LoadError)
  end
  
  def test_database_must_be_yaml_based_if_sqlite_cant_be_required
    require 'subito/databases/yml_database'
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
    flexmock(SConfig).new_instances(:instance).should_receive('database_data_xpath').and_return("//select/option")
    flexmock(FileUtils).should_receive(:rm_f).with_any_args
    Database.instance.db= FakeDb.new
    assert_equal(
                  { "foo" => "0",
                    "bar" => "2", 
                    "foobar" => "56"},
                  Database.instance.write )
   end

  def test_get_must_return_an_id
    Database.instance.db= FakeDb.new
    flexmock(File).should_receive(:exists?).with_any_args.and_return(true)
    assert_equal("0", Database.instance.get('foo'))
  end
  def test_must_return_all_show_similar_toa_given_one
    assert_equal( 
                 {"fubar"=>12, 
                   "fobar"=>15,
                   "fooobar"=>19}, 
                 Database.instance.get_shows_similar_to("foobar", 0.8))
  end
  
end
