class Links: Object, Mappable {
		@objc dynamic var self: String = ""
		@objc dynamic var next: String = ""
		@objc dynamic var last: String = ""

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

