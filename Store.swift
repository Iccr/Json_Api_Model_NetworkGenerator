class Store: Mappable {
		var links: Links?
		var data: Data?

		init?(map: Map) {
				self.init()
		}

		func mapping(map: Map) {
				links <- map["links"]
				data <- map["data"]

		}
}

