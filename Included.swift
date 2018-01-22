class Included: Mappable {
		var type: String = ""
		var id: String = ""
		var attributes: Attributes?
		var links: Links?

		init?(map: Map) {
				self.init()
		}

		func mapping(map: Map) {
				type <- map["type"]
				id <- map["id"]
				attributes <- map["attributes"]
				links <- map["links"]

		}
}

