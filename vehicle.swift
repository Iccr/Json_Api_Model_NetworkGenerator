class vehicle: Object, Mappable { 
 dynamic var id: String? =  ""
dynamic var categoryId: String? =  ""
dynamic var name: String? =  ""
dynamic var code: String? =  ""
dynamic var displayOrder: String? =  ""
dynamic var thumbnail: String? =  ""
dynamic var images: String? =  ""
dynamic var about: String? =  ""
dynamic var specification: String? =  ""
dynamic var documents: String? =  ""
dynamic var compatibilities: String? =  ""
 

        required convenience init?(map: Map) {
            self.init()
        }

        override class func primaryKey() -> String? {
            return "id"
        }
        func mapping(map: Map) {
          id <- ["id"]
categoryId <- ["categoryId"]
name <- ["name"]
code <- ["code"]
displayOrder <- ["displayOrder"]
thumbnail <- ["thumbnail"]
images <- ["images"]
about <- ["about"]
specification <- ["specification"]
documents <- ["documents"]
compatibilities <- ["compatibilities"]

          }
        }