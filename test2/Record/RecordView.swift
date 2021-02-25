//
//  RecordView.swift
//  test2
//
//  Created by Wittawin Muangnoi on 16/2/2564 BE.
//

import Foundation
import Combine
import UIKit

protocol RecordViewLogic : class {
    func displayRecord(viewModel: Record.Cell.ViewModel)
}

class RecordView : UIViewController, Storyboarded, RecordViewLogic {
    
    
    weak var coordinator : RecordCoordinator?
    var interactor : RecordBuisinessLogic?
    var viewModel : RecordVM!
    var subscription = Set<AnyCancellable>()
    var records = [Record.Cell.ViewModel.Item]()
    private lazy var dataSource = makeDataSource()
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var marginLeft : CGFloat!
    private var marginRight : CGFloat!
    override func viewDidLoad() {
        interactor?.fetch(request: Record.Cell.Request())
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        layout.itemSize = CGSize(width: 128, height: 128)
        marginLeft = (view.frame.width - (view.frame.width * 0.4 * 2) - 20 ) / 2
        marginRight = marginLeft
        collectionView.collectionViewLayout = layout
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
}

extension RecordView : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: marginLeft, bottom: 20, right: marginRight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width * 0.4, height: 128)
    }
    
    func makeDataSource() -> UICollectionViewDiffableDataSource<Record.RecordSection,AnyHashable> {
        return UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecordCell", for: indexPath) as! RecordCollectionViewCell
                cell.contentView.layer.cornerRadius = 15
                cell.contentView.layer.borderWidth = 0.5
                cell.contentView.layer.borderColor = UIColor.systemGray3.cgColor
                cell.title.text = self.records[indexPath.row].title
                cell.value.text = self.records[indexPath.row].value
                return cell
            })
    }
    
    func update(animate : Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Record.RecordSection, AnyHashable>()
        snapshot.appendSections(Record.RecordSection.allCases)
        snapshot.appendItems(records, toSection: .record)
        dataSource.apply(snapshot,animatingDifferences: animate)
    }
    
    func displayRecord(viewModel: Record.Cell.ViewModel) {
        records = viewModel.items
        update(animate: true)
    }
    
    func setup() {
        let viewController = self
        let interactor = RecordInteractor()
        let presenter = RecordPresenter()
//        let router = HomeRouter()
        viewController.interactor = interactor
//        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
//        router.viewController = viewController
//        router.dataStore = interactor
    }
}

