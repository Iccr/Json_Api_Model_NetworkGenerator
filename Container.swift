class Container: Object, Mappable {
		@objc dynamic var data: Data?

		required convenience init?(map: Map) {
				self.init()
		}

		override class func primaryKey() -> String? {
				// change according to your requirement
				return "id"
		}

		func mapping(map: Map) {
				data <- map["data"]

		}
}

