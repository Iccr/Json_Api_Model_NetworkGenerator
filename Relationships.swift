class Relationships: Mappable {
		var store: Store?
		var salesregion: Salesregion?
		var salesrole: Salesrole?

		init?(map: Map) {
				self.init()
		}

		func mapping(map: Map) {
				store <- map["store"]
				salesregion <- map["salesregion"]
				salesrole <- map["salesrole"]

		}
}

