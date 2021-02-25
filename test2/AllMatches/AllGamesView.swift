//
//  AllMatches.swift
//  test2
//
//  Created by Wittawin Muangnoi on 15/2/2564 BE.
//

import Foundation
import UIKit
import Combine

protocol AllGamesViewLogic : class {
    func displayItem(viewModel : AllGames.Cell.ViewModel)
    func displayFetchedItem(viewModel : AllGames.Cell.ViewModel)
}

class AllGamesView : UIViewController, Storyboarded, AllGamesViewLogic{
    
    
    weak var coordinator : HomeCoordinator?
    var interactor : AllGamesBusinessLogic?
    var subscription = Set<AnyCancellable>()
    var viewModel : AllGamesVM!
    var games = [AllGames.Cell.ViewModel.Item]()
    var router : (AllGamesRouterLogic & AllGamesDataPassing)?
    lazy var dataSource = makeDataSource()
    @IBOutlet weak var listTable: UITableView!
    override func viewDidLoad() {
        listTable.delegate = self
        listTable.dataSource = dataSource
//        viewModel.matches.sink(receiveCompletion: {_ in}, receiveValue: { value in
//            self.update(animate: false)
//        }).store(in: &subscription)
        interactor?.showItems(request: AllGames.Cell.Request())
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
        let interactor = AllGamesInteractor()
        let presenter = AllGamesPresenter()
        let router = AllGamesRouter()
        viewController.interactor = interactor
        viewController.router = router
        router.viewController = viewController
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.dataStore = interactor
    }
    
    func displayFetchedItem(viewModel: AllGames.Cell.ViewModel) {
        games += viewModel.items
    }
    
    func displayItem(viewModel: AllGames.Cell.ViewModel) {
        games = viewModel.items
        print("DISPLAY")
        update(animate: true)
    }
    
}

extension AllGamesView : UITableViewDelegate {
    func makeDataSource() ->  UITableViewDiffableDataSource<AllGames.GameSection, AnyHashable> {
        return UITableViewDiffableDataSource(
            tableView: listTable,
            cellProvider: { tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "listItemCell", for: indexPath) as! FixtureTableViewCell
                let match = self.games[indexPath.row]
                cell.heroImg.image = UIImage(named: match.heroImg)
                cell.result.text = match.result
                cell.result.textColor = cell.result.text == "Won" ? .systemGreen : .red
                cell.bracket.text = match.bracket
                cell.gameMode.text = match.gameMode
                cell.kda.text = match.kda
                return cell
            })
    }
    
    func update(animate : Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<AllGames.GameSection,AnyHashable>()
        snapshot.appendSections(AllGames.GameSection.allCases)
        snapshot.appendItems(games, toSection: .matches)
        dataSource.apply(snapshot,animatingDifferences: animate)
    }
    
}

extension AllGamesView : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = listTable.contentSize.height
        if offsetY > contentHeight - 100 - listTable.frame.height {
            guard !interactor!.isLoading else {
                print("LOADDDDed")
                return
            }
            interactor?.fetchMore(request: AllGames.Cell.Request())
//            viewModel.loadMoreData()
            update(animate: true)
        }
    }
}
