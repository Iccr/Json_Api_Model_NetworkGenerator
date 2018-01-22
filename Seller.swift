class Seller: Object, Mappable {
		@objc dynamic var id: Int = 0
		@objc dynamic var name: String = ""
		@objc dynamic var email: String = ""
		@objc dynamic var phoneNumber: String = ""
		@objc dynamic var verified: Bool = false
		@objc dynamic var rating: Int = 0
		@objc dynamic var address: Address?

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
				email <- map["email"]
				phoneNumber <- map["phone_number"]
				verified <- map["verified"]
				rating <- map["rating"]
				address <- map["address"]

		}
}

