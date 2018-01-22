class Specifications: Object, Mappable {
		@objc dynamic var key: String = ""
		@objc dynamic var value: String = ""

		required convenience init?(map: Map) {
				self.init()
		}

		override class func primaryKey() -> String? {
				// change according to your requirement
				return "id"
		}

		func mapping(map: Map) {
				key <- map["key"]
				value <- map["value"]

		}
}

