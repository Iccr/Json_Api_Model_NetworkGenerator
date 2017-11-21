
# ruby generators.rb --m=cart --a=name:string --a=price:Int

require 'optparse'
require 'active_support/inflector'
require 'pry'

@model_name = 'model'
@attributes = []
@to_one_relations =
@to_many_relations = []


OptionParser.new do |opt|

  # MODELS
  opt.on('-m MODEL') { |o| @model_name = "#{o.capitalize}" }
  opt.on('--model MODEL') { |o| @model_name = "#{o.capitalize}" }

  # ATTRIBUTEs   eg name:String?  price:Double?
  opt.on('-a ATTRIBUTE') { |o| @attributes.push(o) }
  opt.on('--attribute ATTRIBUTE') { |o| @attributes.push(o) }

  #to_one_relations
  opt.on('-r RELATON') { |o| to_one_relations.push(o) }
  opt.on('--relations RELATON') { |o| to_one_relations.push(o) }

  #to_many_relations
  opt.on('-r RELATON') { |o| to_many_relations.push(o) }
  opt.on('--relations RELATON') { |o| to_many_relations.push(o) }

end.parse!



# create attributes for resource class



def resource_class

  def generate_attributes attributes
    v = ""
    attributes.each do |a|
      # ATTRIBUTEs   eg name:String?  price:Double?
      result = a.split(':')
      output = "@objc dynamic var #{result.first}: #{result.last}? \n"
      v << output
    end
    v
  end



  def generate_required_infos attributes
    v = ""
    attributes.each do |a|

      # "totalPrice": Attribute().serializeAs("total-price")

      result = a.split(':').first

      output =  "\"#{result}\": " + ' Attribute().serializeAs("key-value")' + "\n"
      v << output
    end
    v
  end





  def generate_realm_resource_function_attributes attributes
    v = ""
    attributes.each do |a|
      # model.totalPrice = self.totalPrice ?? ""
      result = a.split(':').first
      output =  "model.#{result} = self.#{result} ?? \"\" "  + "\n"
      v << output
    end
    v
  end


  my_resource_class = <<-RESOURCE
  class #{@model_name}: Resource {

    // Attributes
    #{generate_attributes @attributes}


    // required blocks

    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    required init() { super.init() }

    override class var resourceType: ResourceType {
      return "#{@model_name.downcase.pluralize}"
    }


    override class var fields: [Field] {
      return fieldsFromDictionary([
        #{generate_required_infos @attributes}
        ])
      }


      func realmModel() -> #{@model_name}RealmModel {
      let model = #{@model_name}RealmModel()
      #{generate_realm_resource_function_attributes @attributes}
      return model
    }

  }
  RESOURCE
  my_resource_class
  puts my_resource_class
end


def generate_realm_attributes attributes
  v = ""
  attributes.each do |a|

    # @objc dynamic var totalPrice: String = ""

    #bug its ouptutting totalPrice:String? = ""

    result = a.split(':')
    attribute_name = result.first
    type_name = result.last
    if(
      attribute_name.include?("Int") || attribute_name.include?("Double") ||
      attribute_name.include?("String") || attribute_name.include?("NSNumber")
    )
    attribute_name[-1] = ''
    end

    output = ""
    if type_name.include? "]"
      output = "@objc dynamic var #{attribute_name}: #{type_name} = [] \n"
    elsif type_name.include? "Int"
      output = "@objc dynamic var #{attribute_name}: #{type_name} = 0 \n"
    elsif type_name.include? "Double"
      output = "@objc dynamic var #{attribute_name}: #{type_name} = 0.0 \n"
    elsif type_name.include? "NSNumber"
      output = "@objc dynamic var #{attribute_name}: #{type_name} = 0.0 \n"
    else
      output = "@objc dynamic var #{attribute_name}: #{type_name} = \"\" \n"
    end
    v << output
  end
  puts v
end


def generate_realm_class
  my_realm_class = <<-REALM
  class #{@model_name}RealmModel: Object {
    @objc dynamic var totalPrice: String = ""
    @objc dynamic var id: String = ""
    override class func primaryKey() -> String? {
      return "id"
    }

    func resourceModel() -> Cart {
      let model = resourceModel()
      model.totalPrice = self.totalPrice
      return model
    }

    func normalModel() -> CartModel {
      let model = CartModel()
      model.totalPrice = self.totalPrice
      return model
    }

  }
  REALM

end


# app = <<-MY_CODE
#
#
# import Foundation
# import RealmSwift
#
# #{resource_class}
#
#
# class CartRealmModel: Object {
#   @objc dynamic var totalPrice: String = ""
#   @objc dynamic var id: String = ""
#   override class func primaryKey() -> String? {
#     return "id"
#   }
#
#   func resourceModel() -> Cart {
#     let model = resourceModel()
#     model.totalPrice = self.totalPrice
#     return model
#   }
#
#   func normalModel() -> CartModel {
#     let model = CartModel()
#     model.totalPrice = self.totalPrice
#     return model
#   }
#
# }
#
#
# class CartModel {
#   var totalPrice: String?
# }
#
# MY_CODE
# end

generate_realm_attributes @attributes
# resource_class
