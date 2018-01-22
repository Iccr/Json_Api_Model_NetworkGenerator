class Data: Object, Mappable {
		var productsItem = List<ProductsItem>()

		required convenience init?(map: Map) {
				self.init()
		}

		override class func primaryKey() -> String? {
				// change according to your requirement
				return "id"
		}

		func mapping(map: Map) {
				productsItem <- (map["products_item"], ListTransform<ProductsItem>())

		}
}

