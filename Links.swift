class Links: Mappable {
		var self: String = ""

		init?(map: Map) {
				self.init()
		}

		func mapping(map: Map) {
				self <- map["self"]

		}
}

