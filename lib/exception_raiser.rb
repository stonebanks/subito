
module ExceptionRaiser
  
  UnknownFileError = Class.new(StandardError)
  EmptyStringError = Class.new(StandardError)
  BadTypeError = Class.new (TypeError)
  NoMethodError = Class.new (NoMethodError)
  RuntimeError = Class.new (RuntimeError)
  
  def  raise_if_unknown_file(filename, options = {})
    options = {msg: "#{filename} does not exist"}
    raise UnknownFileError,options[:msg], caller unless File.exists? filename.to_s
  end

  def raise_if_empty_string(str, options = {})
    options = {msg: "Empty string is not accepted"}.merge (options)
    raise EmptyStringError, options[:msg], caller if str.to_s.empty?
  end

  def raise_if_bad_type(object, classname, options = {})
    options = {msg: "Argument must be a #{classname}"}.merge (options)
    raise BadTypeError, options[:msg], caller unless object.kind_of? classname
  end

  def raise_if_nomethod(arg, sym, options = {})
    options = {msg: "Undefined method #{sym}"}.merge (options)
    raise NoMethodError, options[:msg], caller unless arg.class.method_defined? sym
  end

  # Raise an ExceptionRaiser::RuntimeError if block condition on watchee is true
  #
  # @param [Object] watchee the object that is been watched
  # @optional [Hash] options the message (msg: "foobar")
  def raise_custom(watchee, options = {})
    options = {msg: "Something just happened", excpt_type: ExceptionRaiser::RuntimeError}.merge(options)
    raise options[:excpt_type], options[:msg], caller if yield watchee
  end
  
end
