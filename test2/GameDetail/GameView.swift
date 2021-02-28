//
//  GameView.swift
//  test2
//
//  Created by Wittawin Muangnoi on 26/2/2564 BE.
//

import Foundation
import UIKit

protocol GameViewLogic : class {
    func displayGame(viewModel : Game.Cell.ViewModel)
    func initGame(viewModel : Game.Init.ViewModel)
}

class GameView : UIViewController, GameViewLogic {
    var interactor : GameBusinessLogic?
    var router : (GameRouterLogic & GameDataPassing)?
    var dire = [Game.Cell.ViewModel.Stat]()
    var radiant = [Game.Cell.ViewModel.Stat]()
    var matchID : String!
    private lazy var dataSource = makeDataSource()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func viewDidLoad() {
        tableView.delegate = self
        activityIndicator.startAnimating()
        interactor?.initGame(request: Game.Init.Request())
        interactor?.fetchGame(request: Game.Cell.Request())
        title = "Match ID \(matchID ?? "No matchID")"
    }
    
    
        
    func setup () {
        let viewController = self
        let interactor = GameInteractor()
        let presenter = GamePresenter()
        let router = GameRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    func displayGame(viewModel: Game.Cell.ViewModel) {
        dire = viewModel.dire
        radiant = viewModel.radiant
        update()
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        activityView.isHidden = true
    }
    
    func initGame(viewModel: Game.Init.ViewModel) {
        matchID = viewModel.matchID
    }
}

extension GameView : UITableViewDelegate {
    func makeDataSource() -> UITableViewDiffableDataSource<Game.GameSection,AnyHashable> {
        return UITableViewDiffableDataSource<Game.GameSection,AnyHashable>(
            tableView: tableView,
            cellProvider: {[unowned self] tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "StatCell", for: indexPath) as! StatCell
                var player : Game.Cell.ViewModel.Stat
                switch indexPath.section {
                case 1:
                    player = self.radiant[indexPath.row]
                case 0:
                    player = self.dire[indexPath.row]
                default:
                    player = self.dire[indexPath.row]
                }
                let image = ImageResize.shared.resized(image: UIImage(named: player.heroImg)!,scale: 0.2)
                cell.heroImg.image = image
                cell.playerName.text = player.playerName
                cell.kda.text = player.kda
                for i in 0...5 {
                    cell.itemsImg[i].contentMode = .scaleAspectFill
                    cell.itemsImg[i].layer.cornerRadius = 3
                    if player.items[i] != nil {
                        ImageCache.shared.fetchItemImg(url: player.items[i]) { image in
                            cell.itemsImg[i].image = image
                        }
                    }
                    else {
                        cell.itemsImg[i].backgroundColor = .systemGray5
                    }
                }
                return cell
            })
    }
    
    func update(animate: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Game.GameSection, AnyHashable>()
        snapshot.appendSections(Game.GameSection.allCases)
        snapshot.appendItems(dire,toSection: .radiant)
        snapshot.appendItems(radiant,toSection: .dire)
        dataSource.apply(snapshot,animatingDifferences: animate)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 2:
            return
        default:
            router?.presentDetailModal()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let header = HeaderView(title: "Dire", section: section, showDisclosure: false)
            header.label.textColor = .systemRed
            return header
        case 1:
            let header = HeaderView(title: "Radiant", section: section, showDisclosure: false)
            header.label.textColor = .systemGreen
            return header
        default:
            return HeaderView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}
