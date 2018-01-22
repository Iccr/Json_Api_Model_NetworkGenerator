class Attributes: Mappable {
		var storeName: String = ""
		var storeName1: ?
		var storeName2: String = ""
		var storeIndex: ?
		var postcode: String = ""
		var address: String = ""
		var address1: ?
		var address2: ?
		var storeBarCode: ?
		var phone: String = ""
		var fax: String = ""
		var storeCategoryCode: ?
		var storeCategoryName: ?
		var contactCode: String = ""
		var contactName: String = ""
		var createdAt: String = ""
		var updatedAt: String = ""

		init?(map: Map) {
				self.init()
		}

		func mapping(map: Map) {
				storeName <- map["store-name"]
				storeName1 <- map["store-name1"]
				storeName2 <- map["store-name2"]
				storeIndex <- map["store-index"]
				postcode <- map["postcode"]
				address <- map["address"]
				address1 <- map["address1"]
				address2 <- map["address2"]
				storeBarCode <- map["store-bar-code"]
				phone <- map["phone"]
				fax <- map["fax"]
				storeCategoryCode <- map["store-category-code"]
				storeCategoryName <- map["store-category-name"]
				contactCode <- map["contact-code"]
				contactName <- map["contact-name"]
				createdAt <- map["created-at"]
				updatedAt <- map["updated-at"]

		}
}

