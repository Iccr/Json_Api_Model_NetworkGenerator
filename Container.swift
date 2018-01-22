class Container: Mappable {
		var data: Data?
		var included: [Included] = []

		init?(map: Map) {
				self.init()
		}

		func mapping(map: Map) {
				data <- map["data"]
				included <- map["included"]

		}
}

