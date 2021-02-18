//
//  RecordView.swift
//  test2
//
//  Created by Wittawin Muangnoi on 16/2/2564 BE.
//

import Foundation
import Combine
import UIKit

class RecordView : UIViewController, Storyboarded {
    weak var coordinator : RecordCoordinator?
    var viewModel : RecordVM!
    var subscription = Set<AnyCancellable>()
    private lazy var dataSource = makeDataSource()
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var marginLeft : CGFloat!
    private var marginRight : CGFloat!
    override func viewDidLoad() {
        
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        layout.itemSize = CGSize(width: 128, height: 128)
        marginLeft = (view.frame.width - (view.frame.width * 0.4 * 2) - 20 ) / 2
        marginRight = marginLeft
        collectionView.collectionViewLayout = layout
        viewModel.record.sink(receiveCompletion: { _ in}, receiveValue: { value in
            self.update(animate: false)
        }).store(in: &subscription)
    }
}

extension RecordView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecordCell", for: indexPath)
        cell.contentView.layer.cornerRadius = 15
        cell.contentView.layer.borderWidth = 0.5
        cell.contentView.layer.borderColor = UIColor.systemGray3.cgColor
//        cell.layer.shadowColor = UIColor.lightGray.cgColor
//        cell.layer.shadowOffset = CGSize(width:0,height: 2.0)
//        cell.layer.shadowRadius = 10.0
//        cell.layer.shadowOpacity = 0.5
//        cell.layer.masksToBounds = false;
//        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        return cell
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: marginLeft, bottom: 20, right: marginRight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width * 0.4, height: 128)
    }
    
    func makeDataSource() -> UICollectionViewDiffableDataSource<RecordSection,AnyHashable> {
        return UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecordCell", for: indexPath) as! RecordCollectionViewCell
                let data = self.viewModel.record.value[indexPath.row]
                cell.title.text = data.field?.replacingOccurrences(of: "_", with: " ").capitalized
                cell.value.text = String(format: "%.0f", data.sum!)
                cell.contentView.layer.cornerRadius = 15
                cell.contentView.layer.borderWidth = 0.5
                cell.contentView.layer.borderColor = UIColor.systemGray3.cgColor
                return cell
            })
    }
    
    func update(animate : Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<RecordSection, AnyHashable>()
        snapshot.appendSections(RecordSection.allCases)
        snapshot.appendItems(self.viewModel.record.value, toSection: .record)
        dataSource.apply(snapshot,animatingDifferences: animate)
    }
    
}

extension String {
//    func uppercaseAfterSpace() -> String {
//
//    }
}
