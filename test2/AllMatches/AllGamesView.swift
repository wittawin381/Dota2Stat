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

class AllGamesView : UIViewController, AllGamesViewLogic{
    
    
    var interactor : AllGamesBusinessLogic?
    var subscription = Set<AnyCancellable>()
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
        update(animate: false)
    }
    
}

extension AllGamesView : UITableViewDelegate {
    func makeDataSource() ->  UITableViewDiffableDataSource<AllGames.GameSection, AnyHashable> {
        return UITableViewDiffableDataSource(
            tableView: listTable,
            cellProvider: {[unowned self] tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "listItemCell", for: indexPath) as! FixtureTableViewCell
                let match = self.games[indexPath.row]
                let image = ImageResize.shared.resized(image: UIImage(named: match.heroImg)!,scale: 0.2)
                cell.heroImg.image = image
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let matchID = games[indexPath.row].matchID
        router?.routeToGame(matchID: matchID)
    }
}

extension AllGamesView : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = listTable.contentSize.height
        if offsetY > contentHeight + 100 - listTable.frame.height {
            guard !interactor!.isLoading else {
                return
            }
            interactor?.fetchMore(request: AllGames.Cell.Request())
            update(animate: true)
        }
    }
}
