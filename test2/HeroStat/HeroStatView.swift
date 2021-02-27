//
//  HeroStatView.swift
//  test2
//
//  Created by Wittawin Muangnoi on 16/2/2564 BE.
//

import Foundation
import UIKit
import Combine

protocol HeroStatViewLogic : class {
    func displayHeroStat(viewModel: HeroStat.Cell.ViewModel)
}

class HeroStatView : UIViewController, HeroStatViewLogic {
    var interactor : HeroStatBusinessLogic?
    var router : (HeroStatRouterLogic & HeroStatPassingData)?
    var subscription = Set<AnyCancellable>()
    var stats = [HeroStat.Cell.ViewModel.Item]()
    @IBOutlet weak var listTable: UITableView!
    
    private lazy var dataSource = makeDataSource()
    override func viewDidLoad() {
        listTable.delegate = self
        listTable.dataSource = dataSource
        interactor?.displayItems(request: HeroStat.Cell.Request())
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nil)
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    
    func setup() {
        let viewController = self
        let interactor = HeroStatInteractor()
        let presenter = HeroStatPresenter()
        let router = HeroStatRouter()
        viewController.interactor = interactor
        viewController.router = router
        router.dataStore = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        
    }
    
    func displayHeroStat(viewModel: HeroStat.Cell.ViewModel) {
        stats = viewModel.items
        update(animate: false)
    }
}

extension HeroStatView : UITableViewDelegate {
    
    func makeDataSource() -> UITableViewDiffableDataSource<HeroStat.HeroStatSection, AnyHashable> {
        return UITableViewDiffableDataSource(
            tableView: listTable,
            cellProvider: {[unowned self] tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "heroesCell", for: indexPath) as! MyHeoresTableViewCell
                let stat = self.stats[indexPath.row]
                let image = ImageResize.shared.resized(image: UIImage(named: stat.heroImg)!,scale: 0.2)
                cell.heroImg.image = image
                cell.heroName.text = stat.heroName
                cell.matchPlayed.text = stat.matchPlayed
                cell.winrate.text = stat.winrate
                cell.winrateProg.setProgress(stat.winrateProg, animated: true)
                cell.matchPlayProg.setProgress(stat.matchPlayProg, animated: true)
//                UIView.animate(withDuration: 1.0, animations: {
//
//                    cell.winrateProg.progressTintColor = UIColor(hue: (CGFloat(winrate) / 100.0) / 3, saturation: 1.0, brightness: 1.0, alpha: 1.0)
//                })
//                UIView.animate(withDuration: 1.0, animations: {
//
//                    cell.matchPlayProg.progressTintColor =  UIColor(hue: CGFloat(cell.matchPlayProg.progress) / 3, saturation: 1.0, brightness: 1.0, alpha: 1.0)
//                })
                return cell
            })
    }
    
    func update(animate : Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<HeroStat.HeroStatSection,AnyHashable>()
        snapshot.appendSections(HeroStat.HeroStatSection.allCases)
        snapshot.appendItems(stats, toSection: .stat)
        dataSource.apply(snapshot,animatingDifferences: animate)
    }
}

