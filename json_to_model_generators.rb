  #!/usr/bin/ruby
  require 'rubygems'
  require 'json'
  require 'pp'
  require 'pry'


  class Generator
    attr_accessor :json

  def create_file filename, content
    _filename = filename + ".swift"
    # puts File.exists?(filename)
      # unless File.exists?(filename)
        File.open(filename,  "w") do |file|
            file.write content.strip!
            puts "created file #{filename}"
        end
      # end
  end


  def generate_attributes childs
    response = childs.first
    childs.first.keys
  end



def write_to_file filename, content

end

def attribute_type attribute
  result = ""
  if attribute.is_a? String
    result = "String"
  elsif attribute.is_a? Integer
    result = "Int"
  elsif attribute.is_a? Float
    result = "Double"
  end
end

def default_value attribute
  if attribute.is_a? String
    @result = "\"\""
  elsif attribute.is_a? Integer
    @result = -1
  elsif attribute.is_a? Float
    @result = 0.0
  end
  @result
end


def generate_string_from_attribute  attributes

  if attributes.empty?
    puts "no attributes found"
  end
  @result = ""

  attributes.each do |attribute|
    @result = @result + "dynamic var #{attribute}: #{attribute_type attribute}? =  #{default_value attribute}" + "\n"
    # binding.pry
  end
  @result
end

def generate_mapper_from_attribute  attributes

  if attributes.empty?
    puts "no attributes found"
  end
  @result = ""

  attributes.each do |attribute|
    @result = @result + "#{attribute} <- [\"#{attribute}\"]" + "\n"
  end
  @result
end

  def generate_all_files files, json
    files.each do |model_name|
      filename = "#{model_name + ".swift"}"
      # binding.pry
      @attributes = generate_attributes json[model_name]
      # binding.pry
      content = generate_string_from_attribute(@attributes)
      class_model = <<-CLASS
      class #{model_name}: Object, Mappable { \n #{content} \n
        required convenience init?(map: Map) {
            self.init()
        }

        override class func primaryKey() -> String? {
            return "id"
        }
        func mapping(map: Map) {
          #{self.generate_mapper_from_attribute(@attributes)}
          }
        }\n
      CLASS
      create_file filename, class_model
    end
  end




  def get_keys json
    puts "empty json" if json.nil? and return
    json.keys
  end
end



  # read json
  json = File.read('input.json')
  jsonObj = JSON.parse(json)
    @json = jsonObj["data"]

  generator = Generator.new

models = generator.get_keys @json
generator.generate_all_files models, @json
