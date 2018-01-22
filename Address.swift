class Address: Object, Mappable {
		@objc dynamic var latitude: Double = 0.0
		@objc dynamic var longitude: Double = 0.0
		@objc dynamic var streetName: String = ""
		@objc dynamic var userId: Int = 0

		required convenience init?(map: Map) {
				self.init()
		}

		override class func primaryKey() -> String? {
				// change according to your requirement
				return "id"
		}

		func mapping(map: Map) {
				latitude <- map["latitude"]
				longitude <- map["longitude"]
				streetName <- map["street_name"]
				userId <- map["user_id"]

		}
}

