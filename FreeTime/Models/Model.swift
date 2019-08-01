//
//  Model.swift
//  FreeTime
//
//  Created by Mohamed on 01/04/2019.
//  Copyright © 2019 OriginLines. All rights reserved.
//

import Foundation
import IGListKit


class _cb_findItemsByKeywords:Decodable {
    let findItemsByKeywordsResponse: [FindItemsByKeywordsResponse]
}

class FindItemsByKeywordsResponse:Decodable {
    let timestamp: [String]
    let searchResult: [SearchResult]
}

class SearchResult:Decodable {
    let item: [Item]
}

class Item:Decodable, ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return (itemId[0] + sellingStatus[0].currentPrice[0].__value__) as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Item else { return false }
        return itemId[0] + sellingStatus[0].currentPrice[0].__value__ == object.itemId[0] + sellingStatus[0].currentPrice[0].__value__
    }

    let itemId: [String]
    let title: [String]
    let globalId: [String]
    let sellingStatus: [SellingStatus]
    let primaryCategory: [PrimaryCategory]
    let galleryURL: [String]
    let viewItemURL: [String]
    let location: [String]
    let country: [String]
    let condition: [Condition]

}

class SellingStatus: Decodable {
    let currentPrice : [CurrentPrice]
}

class CurrentPrice: Decodable {
    let __value__: String
}

class PrimaryCategory: Decodable {
    let categoryId: [String]
    let categoryName: [String]
}

class Condition: Decodable {
    let conditionId: [String]
    let conditionDisplayName: [String]
}

// Keyword recommendation model:

class RecommendedKeyword: Decodable {
    let getSearchKeywordsRecommendationResponse: [GetSearchKeywordsRecommendationResponse]
}

class GetSearchKeywordsRecommendationResponse: Decodable {
    let keywords: [String]
}
