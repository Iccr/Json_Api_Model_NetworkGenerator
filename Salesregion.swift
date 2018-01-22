class Salesregion: Mappable {
		var links: Links?
		var data: ?

		init?(map: Map) {
				self.init()
		}

		func mapping(map: Map) {
				links <- map["links"]
				data <- map["data"]

		}
}

