
# ruby generators.rb --m=cart --a=name:string --a=price:Int
# ruby generators.rb --m=ckart --a=price:String  --a=weight:String --a=quantity:String --a='price:[Int]'

require 'optparse'
require 'active_support/inflector'
require 'pry'


@file_base_path = "/Users/shishirsapkota/office/B2BOrderingiOS/B2BOrdering/Model"
@model_name = 'model'
@attributes = []
@to_one_relations =
@to_many_relations = []
@api_handler = true

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

  # api handler
  opt.on('-api HANDLER') { |o| @api_handler = true }


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
    v << "@objc dynamic var id: String? \n"
    v
  end



  def generate_required_infos attributes
    v = ""
    attributes.each do |a|

      # "totalPrice": Attribute().serializeAs("total-price")

      result = a.split(':').first

      output =  "\"#{result}\": " + " Attribute().serializeAs(\"#{result}\")" + "\n"
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
    v << "model.id = self.id ?? \"-1\" "  + "\n"
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
end








def realm_class

  def generate_realm_attributes attributes
    v = ""
    attributes.each do |a|

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
    v << "@objc dynamic var id: String = \"-1\" \n"
    v
  end

  # working
  def assignVariables attributes
    v = ""
    attributes.each do |a|
      # model.totalPrice = self.totalPrice ?? ""
      result = a.split(':').first
      output =  "model.#{result} = self.#{result}"  + "\n"
      v << output
    end
      v << "model.id = self.id"  + "\n"
    v
  end


  my_realm_class = <<-REALM
  class #{@model_name}RealmModel: Object {

    // Attributes
    #{generate_realm_attributes @attributes}

    override class func primaryKey() -> String? {
      return "id"
    }

    func resourceModel() -> #{@model_name} {
      let model = #{@model_name}()
      #{assignVariables @attributes}
      return model
    }

    func normalModel() -> #{@model_name}Model {
      let model = #{@model_name}Model()
      #{assignVariables @attributes}
      return model
    }

  }
  REALM
  my_realm_class
end





def model_class

  def generate_normal_attributes attributes
    v = ""
    attributes.each do |a|
      # ATTRIBUTEs   eg name:String?  price:Double?
      result = a.split(':')
      output = "var #{result.first}: #{result.last}? \n"
      v << output
    end
    v << "var id: String? \n"
    v
  end

  my_normal_model = <<-NORMALMODEL
  class #{@model_name}Model {
    #{generate_normal_attributes @attributes}
  }
  NORMALMODEL
  my_normal_model
end

def generate_module
  app = <<-APP


  import Foundation
  import RealmSwift

  // resource class

  #{resource_class}

  // realm class
  #{realm_class}

  // model class
  #{model_class}

  APP
  puts app
  app
end

code = generate_module
File.write(@file_base_path + "/#{@model_name}.swift", code)

if @api_handler
  generate_api
end


def generate_api
  api = <<-API
  import Foundation
  import Alamofire

  protocol #{@model_name}APIManager {
      var apiManager: ApiHandel<#{@model_name}> {get}
  }

  extension #{@model_name}APIManager {
      var apiManager: ApiHandel<#{@model_name}> {
          return ApiHandel<#{@model_name}>()
      }
  }

  protocol #{@model_name}Api: #{@model_name}APIManager, RealmPersistenceType {
      func add#{@model_name}(productId: String, unitId: String, quantity: Double, success: @escaping () -> (), failure: @escaping (Error) -> ())
  }

  extension AddToCartApi {
      func addToCart(productId: String, unitId: String, quantity: Double, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
          guard let product: ProductRealmModel = self.fetch(primaryKey: productId), let unit: UnitRealmModel = self.fetch(primaryKey: unitId) else {return}
          let model = Cartproduct()
          model.quantity = "\(quantity)"
          model.unit = unit.resourceModel()
          model.price = unit.markPrice
          model.product = product.resourceModel()
          model.weight = product.weight

          if NetworkReachabilityManager()?.isReachable == true {
              self.apiManager.addOrUpdate(model, success: { (model) in
                  self.save(models: [model.realmModel()])
                  success()
              }, failure: failure)
          } else {
              let error = GlobalConstants.Errors.internetConnectionOffline
              failure(error)
          }
      }
  }

  API
end
