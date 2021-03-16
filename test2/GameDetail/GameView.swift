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
    var score = [Game.Cell.ViewModel.Score]()
    var matchID : String!
    private lazy var dataSource = makeDataSource()
    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var activityView: UIView!
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
        score = viewModel.score
        update()
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
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
                if item is Game.Cell.ViewModel.Stat {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "StatCell", for: indexPath) as! StatCell
                    var player : Game.Cell.ViewModel.Stat
                    switch indexPath.section {
                    
                    case 2:
                        player = self.radiant[indexPath.row]
                    case 1:
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
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath) as! ScoreCell
                cell.direScore.text = String(score[0].direScore)
                cell.direScore.textColor = .systemRed
                cell.radiantScore.text = String(score[0].radiantScore)
                cell.radiantScore.textColor = UIColor.systemGreen
                if score[0].radiantWin {
                    cell.radiantScore.textColor = cell.radiantScore.textColor.withAlphaComponent(0.3)
                }
                else {
                    cell.direScore.textColor = cell.direScore.textColor.withAlphaComponent(0.3)
                }
                return cell
            })
    }
    
    func update(animate: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Game.GameSection, AnyHashable>()
        snapshot.appendSections(Game.GameSection.allCases)
        snapshot.appendItems(score,toSection: .score)
        snapshot.appendItems(dire,toSection: .radiant)
        snapshot.appendItems(radiant,toSection: .dire)
        dataSource.apply(snapshot,animatingDifferences: animate)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            return
        default:
            router?.presentDetailModal()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1:
            var title = "Dire"
            if score[0].radiantWin {
                title += " Won"
            }
            else {
                title += " Lost"
            }
            let header = HeaderView(title: title, section: section, showDisclosure: false)
            header.label.textColor = .systemRed
            return header
        case 2:
            var title = "Radiant"
            if !score[0].radiantWin {
                title += " Won"
            }
            else {
                title += " Lost"
            }
            let header = HeaderView(title: title, section: section, showDisclosure: false)
            header.label.textColor = .systemGreen
            return header
        default:
            return HeaderView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 60
    }
}
