
# @author Allan SEYMOUR
# @see mailto:allan.seymour@thalesgroup.com

require 'exception_raiser'
module MyUtils
  include ExceptionRaiser
  extend self

  # # Convert a array of string ['foo','bar'] in a string "{foo,bar}"
  # #
  # # @param [Array<String>] stringarray list of strings to process
  # # @return [String] the array converted
  # def pattern_builder(stringarray)
  #   stringarray.inject("{"){|memo, obj| memo+obj+","}.chomp(',')+'}'
  # end

  # Get the last file modified in a list of files
  #
  # @param [Array<String>, String] list the list of existing filename
  # @return [String] last modified filename
  def get_last_modified(*list)
    #    list = ([]<< list) if list.kind_of? String
    #raise_if_nomethod list,:max_by
    #raise_if_bad_type list, Array
    #begin
    list.flatten!
    raise_custom list, excpt_type: BadTypeError, msg: "#{list} is not a valid argument" do 
      |k| k.any? {|item| !item.kind_of? String}
    end
    list.max_by do |file|
      raise_if_unknown_file file
      File.mtime (file)
    end
    # rescue  Errno::ENOENT
    #   raise ExceptionRaiser::UnknownFileError
    # end
  end

  # Search pattern in a string returning it in array or a Obj specified in the block 
  #
  # @param [String] str the string containing the useful infos
  # @param [Regexp] pattern the pattern to find in str
  # @yield a block to format the output in a custom way
  # @return [Array<Array<String> >] the array of infos
  # @return [Object] custom object specified in the block
  def search_infos_in_string(str, pattern)
    raise_if_empty_string str, msg: 'argument str should not be empty'
    raise_if_bad_type str, String
    raise_if_bad_type pattern, Regexp
    array = str.scan(pattern)
    
    result = (block_given?)? (yield array) : array
  end

  # Generate a regular expression from a list of string. If no argument is passed return nil
  #
  # @param [String, Array<String>] args  argument to transform in a regexp
  # @return [Regexp]
  def create_regexp(*args)
    args = args.flatten
    return nil if args.empty?
    raise_custom args, excpt_type: BadTypeError, msg: "#{args} is not a valid argument" do 
      |k| k.any? {|item| !item.kind_of? String}
    end
    str = args.join '|'
    str = yield(str) if block_given?
    Regexp.new str
  end

  # Generate a surrounded by brackets string from a list of string : "{foo,bar}"
  #
  # @param [String, Array<String>] args  argument to transform
  # @return [String] 
  def build_pattern(*args)
    args = args.flatten
    raise_custom args, excpt_type: BadTypeError, msg: "#{args} is not a valid argument" do 
      |k| k.any? {|item| !item.kind_of? String}
    end
    '{'+args.join(',') + '}'
  end

end
