//
//  IntialViewController.swift
//  FreeTime
//
//  Created by Mohamed Ibrahim on 04/12/2018.
//  Copyright © 2018 OriginLines. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import IGListKit

final class IntialViewController: UIViewController, ListAdapterDataSource {

    public private(set) lazy var ebayAPI: EbayAPIClass = { EbayAPIClass(viewController: self) }()


    var data : [ListDiffable] = [ListDiffable]() {
        didSet {
            DispatchQueue.main.async {
                [unowned self] in
                self.adapter.performUpdates(animated: true, completion: nil)
            }
        }
    }

    var mimumItem: Item? {
        didSet {

        }
    }

    var maxmimumItem: Item? {
        didSet {

        }
    }
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 100, height: 40)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self

        let keyWord = "iphonex"

        ebayAPI.getWordRecommendation(with: keyWord) { [weak self] (error, keyword) in
            guard let self = self else {return}
            if let keyword = keyword, !keyword.isEmpty {
                self.getAvargePriceandItem(with: keyword)
            } else {
                self.getAvargePriceandItem(with: keyWord)
            }
        }
    }

    func getAvargePriceandItem(with keyword: String) {
        ebayAPI.getAvaragePrice(with: keyword) { [weak self] (error, avaragePrice, min, max, items) in
            guard let self = self else {return}
            if let error = error {
                self.alert(title: "", msg: error.localizedDescription, disableTime: 3)
            }
            guard let avargePrice = avaragePrice else {return}
            guard let min = min else {return}
            guard let max = max else {return}
            guard let items = items else {return}
            self.data = items
            self.data.insert(avargePrice as ListDiffable, at: 0)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return data
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is Int {
            return HeaderSectionControl()
        } else {
            return SelfSizingSectionController()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? { return nil }
}

extension IntialViewController: Alertable {}
