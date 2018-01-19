class categories: Object, Mappable { 
 dynamic var id: String? =  ""
dynamic var name: String? =  ""
dynamic var displayOrder: String? =  ""
dynamic var parentId: String? =  ""
 

        required convenience init?(map: Map) {
            self.init()
        }

        override class func primaryKey() -> String? {
            return "id"
        }
        func mapping(map: Map) {
          id <- ["id"]
name <- ["name"]
displayOrder <- ["displayOrder"]
parentId <- ["parentId"]

          }
        }