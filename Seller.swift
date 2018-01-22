class Seller: Object, Mappable {
		@objc dynamic var id: Int = 0
		@objc dynamic var name: String = ""
		@objc dynamic var email: String = ""
		@objc dynamic var phone_number: String = ""
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
		
		}
}

