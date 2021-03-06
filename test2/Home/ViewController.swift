//
//  ViewController.swift
//  test2
//
//  Created by Wittawin Muangnoi on 17/10/2563 BE.
//

import UIKit
import CoreData
import Alamofire
import Combine

protocol HomeViewLogic: class {
    func displayFetched(viewModel : Home.TableViewCell.ViewModel)
}

class ViewController: UIViewController , HomeViewLogic{
    var interactor : HomeInteractor?
    var router : (HomeRouterLogic & HomeRouterDataPassing)?
    var matches = [DisplayItems]()
    var heroesStat = [DisplayItems]()
    @IBOutlet weak var listTable: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityView: UIView!
    let search = UISearchController()
    var subscription = Set<AnyCancellable>()
    private lazy var dataSource = makeDataSource()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        activityIndicator.startAnimating()
        interactor?.fetch(request: Home.TableViewCell.Request())
        listTable.delegate = self
        listTable.dataSource = dataSource
        
        
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

extension ViewController : UITableViewDelegate {
    func makeDataSource() -> UITableViewDiffableDataSource<Home.HomeSection, AnyHashable> {
        return UITableViewDiffableDataSource(
            tableView: listTable,
            cellProvider: {[unowned self] tableView, indexPath, item in
                if item is Home.TableViewCell.ViewModel.MatchCell {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "listItemCell", for: indexPath) as! FixtureTableViewCell
                    let match = self.matches[indexPath.row] as! Home.TableViewCell.ViewModel.MatchCell
                    let image = ImageResize.shared.resized(image: UIImage(named: match.heroImg)!,scale: 0.2)
                    cell.heroImg.image = image
                    cell.result.text = match.result
                    cell.result.textColor = cell.result.text == "Won" ? .systemGreen : .red
                    cell.bracket.text = match.bracket
                    cell.gameMode.text = match.gameMode
                    cell.kda.text = match.kda
                    return cell
                }
                else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "heroesCell", for: indexPath) as! MyHeoresTableViewCell
                    let stat = self.heroesStat[indexPath.row] as! Home.TableViewCell.ViewModel.HeroStatCell
                    let image = ImageResize.shared.resized(image: UIImage(named: stat.heroImg)!,scale: 0.2)
                    cell.heroImg.image = image
                    cell.heroName.text = stat.heroName
                    cell.matchPlayed.text = stat.matchPlayed
                    cell.matchPlayProg.setProgress(stat.matchPlayProg, animated: true)
                    cell.winrate.text = stat.winrate
                    cell.winrateProg.setProgress(stat.winrateProg, animated: true)
                    return cell
                }
            }
        );
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        switch section {
        case 0 :
            let header = HeaderView(title: "Recent Matches",section: section)
            header.delegate = self
            return header
        case 1:
            let header = HeaderView(title: "Hero Stat",section: section)
            header.delegate = self
            return header
        default:
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            router?.routeToGame()
        case 1:
            router?.routeToAllGamesByHero()
        default:
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func update(animate : Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Home.HomeSection,AnyHashable>()
        snapshot.appendSections(Home.HomeSection.allCases)
        snapshot.appendItems(Array(self.matches.prefix(5)) as! [Home.TableViewCell.ViewModel.MatchCell], toSection: .matches)
        snapshot.appendItems(Array(self.heroesStat.prefix(5)) as! [Home.TableViewCell.ViewModel.HeroStatCell], toSection: .heroes)
        dataSource.apply(snapshot,animatingDifferences: animate)
    }
    
    func displayFetched(viewModel: Home.TableViewCell.ViewModel) {
        matches = viewModel.matches
        heroesStat = viewModel.stats
        update(animate: false)
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        activityView.isHidden = true
    }
    
    func setup() {
        let viewController = self
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let router = HomeRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}

extension ViewController : HeaderViewDelegate {
    func headerViewDidSelect(section: Int) {
        switch section {
        case 0:
            router?.routeToAllGames()
        case 1:
            router?.routeToHeroStat()
        default:
            return
        }
        
    }
}

