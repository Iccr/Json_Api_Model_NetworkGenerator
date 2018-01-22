require 'json'
require 'pp'
require 'pry'

class Parser

  def initialize
    json = File.read('new_input.json')
    @json = JSON.parse(json)
  end

  def json
    @json
  end
end


def attribute_type attribute
  result = ""
  if attribute.is_a? String
    result = "String"
  elsif attribute.is_a? Integer
    result = "Int"
  elsif attribute.is_a? Float
    result = "Double"
  elsif !!attribute == attribute
    result = "Bool"
  end
  result
end



def create_file filename, content
  _filename = filename + ".swift"
      File.open(_filename,  "w") do |file|
          file.write content
          puts "created file #{_filename}"
      end
    # end
end




parser = Parser.new
json = parser.json

# binding.pry
@realm = true
@parsed = {}

def get_attribute_literal_prefix
  @realm ? "@objc dynamic " : ""
end

def get_array_attribute_literal name
  @realm ? " = List<#{name.capitalize}>()" : ": [#{name.capitalize}] = []"
end

class Attribute
  attr_accessor :name, :type, :is_array
  def initialize name, type, is_array=false
    @name = name
    @type = type
    @is_array = is_array
  end

  def default_value
    result = nil
    case @type
    when "String"
      result = "\"\""
    when "Int"
      result = 0
    when "Double"
      result = 0.0
    when "Bool"
      result = false
    end
    result
  end
end

def generate_attributes_literals json
  swiftClassAttributes = []
  swiftClass = ""
  if json.is_a? Hash
    json.each do |key, value|
      if !(value.is_a? Array) && !(value.is_a? Hash)
        #  string = "#{get_attribute_literal_prefix}var #{key}: #{attribute_type value} = #{default_value value}\n"
        # swiftClass =  swiftClass + string
        attribute = Attribute.new(key, "#{attribute_type value}")
        swiftClassAttributes.push(attribute)
      elsif value.is_a? Hash
        newSwiftClass = generate_attributes_literals value
        @parsed.store(key.capitalize, newSwiftClass)
        # string = "#{get_attribute_literal_prefix}var #{key}: #{key.capitalize}?\n"
        # swiftClass = swiftClass + string
        attribute = Attribute.new(key, "#{key.capitalize}")
        swiftClassAttributes.push(attribute)
      elsif value.is_a? Array
        if value.first.is_a? Hash
          newSwiftClass = generate_attributes_literals value.first
          @parsed.store(key.capitalize, newSwiftClass)
          # string = "var #{key}#{get_array_attribute_literal key}\n"
          # swiftClass = swiftClass + string
          attribute = Attribute.new(key, "#{key.capitalize}", true)
          swiftClassAttributes.push(attribute)
        else
          # string = "var #{key}: [#{attribute_type value.first}] = []\n"
          # swiftClass = swiftClass + string
          attribute = Attribute.new(key, "#{attribute_type value.first}", true)
          swiftClassAttributes.push(attribute)
        end
      end
    end
  end
  # swiftClass
  swiftClassAttributes
end

swiftClass = generate_attributes_literals json
if json.is_a? Hash
  @parsed.store("Container", swiftClass)
end

@parsed.each do |class_name, attributes|
  realm_funcs = <<-REALMCLASS
\t\trequired convenience init?(map: Map) {
\t\t\t\tself.init()
\t\t}

\t\toverride class func primaryKey() -> String? {
\t\t\t\t// change according to your requirement
\t\t\t\treturn "id"
\t\t}
REALMCLASS

  non_realm_funcs = <<-DEFAULT
\t\tinit?(map: Map) {
\t\t\t\tself.init()
\t\t}
DEFAULT

  attribute_literals = ""

  attributes.each do |attribute|
    attribute_literal = ""
    if attribute.is_array
      attribute_literal = "\t\tvar #{attribute.name}#{get_array_attribute_literal attribute.type}\n"
    else
      default_value = attribute.default_value
      default_value = default_value.nil? ? "?" : " = #{default_value}"
      attribute_literal = "\t\t#{get_attribute_literal_prefix}var #{attribute.name}: #{attribute.type}#{default_value}\n"
      if attribute.type == "User"
        binding.pry
      end
    end
    attribute_literals += attribute_literal
  end


  class_model = <<-CLASS
class #{class_name}:#{@realm? " Object," : ""} Mappable {
#{attribute_literals}
#{@realm? realm_funcs : non_realm_funcs}
\t\tfunc mapping(map: Map) {
\t\t
\t\t}
}\n
CLASS
  create_file class_name, class_model
end

pp @parsed