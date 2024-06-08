
//ProfileRecommendItemsAPI

import Foundation
import SwiftyJSON

class ProfileRecommendItemsAPI: APIOperation<ProfileRecommendItemsResponse> {
    init(userId: Int) {
        super.init(request: APIRequest(name: "API recommend",
                                       baseURL: APIMainEnviroment().baseUrlV2,
                                       path: "cfrecommend/\(userId)",
                                       method: .get,
                                       parameters: .body([:])))
    }
}

struct ProfileRecommendItemsResponse: APIResponseProtocol {
    var data: [ProfileRecommendItemsProduct] = []
    init(json: JSON) {
        data = json["data"].arrayValue.map({ProfileRecommendItemsProduct(json: $0)})
    }
}

struct ProfileRecommendItemsProduct: Codable {
    let productId: Int?
    
    init(json: JSON) {
        productId = json["product_id"].int
    }
}


