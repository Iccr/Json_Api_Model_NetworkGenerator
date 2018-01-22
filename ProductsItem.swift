class ProductsItem: Object, Mappable {
		@objc dynamic var id: Int = 0
		@objc dynamic var name: String = ""
		@objc dynamic var price: Int = 0
		@objc dynamic var warranty: Bool = false
		@objc dynamic var discount: Int = 0
		@objc dynamic var rating: Int = 0
		@objc dynamic var description: String = ""
		var specifications = List<Specifications>()
		@objc dynamic var seller: Seller?
		@objc dynamic var links: Links?

		required convenience init?(map: Map) {
				self.init()
		}

		override class func primaryKey() -> String? {
				// change according to your requirement
				return "id"
		}

		func mapping(map: Map) {
				id <- map["id"]
				name <- map["name"]
				price <- map["price"]
				warranty <- map["warranty"]
				discount <- map["discount"]
				rating <- map["rating"]
				description <- map["description"]
				specifications <- (map["specifications"], ListTransform<Specifications>())
				seller <- map["seller"]
				links <- map["links"]

		}
}

