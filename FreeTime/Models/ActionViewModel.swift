//
//  ActionViewModel.swift
//  FreeTime
//
//  Created by Mohamed Ibrahim on 05/12/2018.
//  Copyright © 2018 OriginLines. All rights reserved.
//

import IGListKit

final class ActionViewModel: ListDiffable {
    
    let views: String
    let id: [String]
    
    init(views: String, id: [String]) {
        self.views = views
        self.id = id
    }
    
    // MARK: ListDiffable
    
    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? ActionViewModel else { return false }
        return id == object.id
    }
}


