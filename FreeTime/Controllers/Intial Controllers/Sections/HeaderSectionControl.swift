//
//  SelfSizingSectionController.swift
//  FreeTime
//
//  Created by Mohamed Ibrahim on 04/12/2018.
//  Copyright © 2018 OriginLines. All rights reserved.
//

import UIKit
import IGListKit

final class HeaderSectionControl: ListSectionController {

    private var object: Int?

    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext?.containerSize.width ?? 0, height: 100)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(withNibName: "HeaderCell", bundle: nil, for: self, at: index) as? HeaderCell else {
            return UICollectionViewCell()
        }
        cell.price.text = String(object ?? 0)
        return cell
    }

    override func didUpdate(to object: Any) {
        self.object = object as? Int
    }
}
