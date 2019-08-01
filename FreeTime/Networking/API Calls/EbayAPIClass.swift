//
//  File.swift
//  FreeTime
//
//  Created by Mohamed on 03/04/2019.
//  Copyright © 2019 OriginLines. All rights reserved.
//

import UIKit

final class EbayAPIClass: NSObject {

    typealias avargePrice = (_ error: Error?, _ avargePrice: Int?, _ min: Item?, _ max: Item?, _ item: [Item]?) -> Void

    typealias suggestedKeyword = (Error?, String?) -> Void

    var viewController: UIViewController

    init(viewController: UIViewController) {
        self.viewController = viewController
        super.init()
    }

    func getAvaragePrice(with keyWord: String, countryId: String? = "EBAY-US",  completion: @escaping avargePrice) {
        let request = APIRequest(method: .get, path: "services/search/FindingService/v1")
        request.queryItems = [
            URLQueryItem(name: "SECURITY-APPNAME", value: Constants.ebaySecurityAppName),
            URLQueryItem(name: "OPERATION-NAME", value: "findItemsByKeywords"),
            URLQueryItem(name: "SERVICE-VERSION", value: "1.0.0"),
            URLQueryItem(name: "RESPONSE-DATA-FORMAT", value: "JSON"),
            URLQueryItem(name: "REST-PAYLOAD", value: nil),
            URLQueryItem(name: "keywords", value: keyWord),
            URLQueryItem(name: "paginationInput.entriesPerPage", value: "100"),
            URLQueryItem(name: "GLOBAL-ID", value: countryId),
            URLQueryItem(name: "siteid", value: "0"),
            URLQueryItem(name: "HideDuplicateItems", value: "True")
        ]

        APIClient().perform(request) { (result) in
            switch result {
            case .success(let response):
                if let response = try? response.decode(to: _cb_findItemsByKeywords.self) {
                    guard let items = response.body.findItemsByKeywordsResponse.first?.searchResult.first?.item else {return}

                    // remove duplicate items
                    let uniqueItems = items.unique(map: {$0.itemId[0] + $0.sellingStatus[0].currentPrice[0].__value__})

                    // get minmum and maximum prices
                    let maxItem = uniqueItems.max { Double($0.sellingStatus[0].currentPrice[0].__value__) ?? 0 < Double($1.sellingStatus[0].currentPrice[0].__value__) ?? 0 }
                    let minItem = uniqueItems.min { Double($0.sellingStatus[0].currentPrice[0].__value__) ?? 0 < Double($1.sellingStatus[0].currentPrice[0].__value__) ?? 0 }

                    let currentPrices = uniqueItems.map({$0.sellingStatus.first?.currentPrice.first})
                    let itemPrices = currentPrices.map({($0?.__value__ ?? "")})
                    let itemsDouble = itemPrices.map({Double($0) ?? 0})
                    let itemsTotal = itemsDouble.reduce(0, +)
                    let count = Double(itemPrices.count)

                    if itemsTotal > count {
                        let avarge = Int(itemsTotal / count)
                        completion(nil, avarge, minItem, maxItem, uniqueItems)
                    } else {
                        completion(nil, nil, minItem, maxItem, uniqueItems)
                    }
                } else {
                    print("Failed to decode response")
                }
            case .failure(let error):
                completion(error, nil, nil, nil, nil)
            }
        }
    }

    func getWordRecommendation(with keyWord: String, completion: @escaping suggestedKeyword) {
        let request = APIRequest(method: .get, path: "services/search/FindingService/v1")
        request.queryItems = [
            URLQueryItem(name: "SECURITY-APPNAME", value: Constants.ebaySecurityAppName),
            URLQueryItem(name: "OPERATION-NAME", value: "getSearchKeywordsRecommendation"),
            URLQueryItem(name: "SERVICE-VERSION", value: "1.0.0"),
            URLQueryItem(name: "RESPONSE-DATA-FORMAT", value: "JSON"),
            URLQueryItem(name: "REST-PAYLOAD", value: nil),
            URLQueryItem(name: "keywords", value: keyWord),
        ]
        APIClient().perform(request) { (result) in
            switch result {
            case .success(let result):
                do {
                    let response = try result.decode(to: RecommendedKeyword.self)
                    completion(nil, response.body.getSearchKeywordsRecommendationResponse[0].keywords[0])
                } catch let error {
                     completion(error, nil)
                }
            case .failure(let error):
                completion(error, nil)
            }
        }
    }
}
