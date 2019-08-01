//
//  SelfSizingSectionController.swift
//  FreeTime
//
//  Created by Mohamed Ibrahim on 04/12/2018.
//  Copyright © 2018 OriginLines. All rights reserved.
//

import UIKit
import IGListKit

final class SelfSizingSectionController: ListBindingSectionController<Item>,
ListBindingSectionControllerDataSource, ListSupplementaryViewSource {
    
    override init() {
        super.init()
        dataSource = self
        supplementaryViewSource = self
    }

    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, viewModelsFor object: Any) -> [ListDiffable] {
        guard let object = object as? Item else { fatalError() }
        let results: [ListDiffable] = [
            PostViewModel(title: object.title[0], id: object.itemId),
            ActionViewModel(views: object.sellingStatus[0].currentPrice[0].__value__, id: object.itemId + object.globalId)
        ]
        return results
    }
    
    
    func sectionController(
        _ sectionController: ListBindingSectionController<ListDiffable>,
        sizeForViewModel viewModel: Any,
        at index: Int
        ) -> CGSize {
        guard let width = collectionContext?.containerSize.width else { fatalError() }
        let height: CGFloat
        switch viewModel {
        case is ActionViewModel: height = 35
        default: height = 50
        }
        return CGSize(width: width, height: height)
    }
    
    
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, cellForViewModel viewModel: Any, at index: Int) -> UICollectionViewCell & ListBindable {
        var cell = UICollectionViewCell()
        switch viewModel {
        case is PostViewModel:
            guard let manualCell = collectionContext?.dequeueReusableCell(of: FullWidthSelfSizingCell.self,
                                                                          for: self,
                                                                          at: index) as? FullWidthSelfSizingCell else {
                                                                            fatalError()
            }
            cell = manualCell
        default: guard let nibCell = collectionContext?.dequeueReusableCell(withNibName: "InteractionCell", bundle: nil, for: self, at: index) as? InteractionCell else {fatalError()}
            cell = nibCell
            
        }
        return cell as! UICollectionViewCell & ListBindable
    }

    // MARK: ListSupplementaryViewSource

    func supportedElementKinds() -> [String] {
        return [UICollectionView.elementKindSectionHeader]
    }

    func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
            return userHeaderView(atIndex: index)

    }

    func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 40)
    }

    // MARK: Private
    private func userHeaderView(atIndex index: Int) -> UICollectionReusableView {
        guard let view = collectionContext?.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                             for: self,
                                                                             nibName: "UserHeaderView",
                                                                             bundle: nil,
                                                                             at: index) as? UserHeaderView else {
                                                                                fatalError()
        }
//        view.handle = "@" + feedItem.user.handle
//        view.name = feedItem.user.name
        return view
    }

}
