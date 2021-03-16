//
//  PeersView.swift
//  test2
//
//  Created by Wittawin Muangnoi on 16/3/2564 BE.
//

import Foundation
import UIKit

protocol PeersViewLogic : class {
    func displayPeersList(viewModel: Peers.Cell.ViewModel)
}

class PeersView : UIViewController, PeersViewLogic {
    var interactor : PeersBusinessLogic?
    var router : (PeersRoutingLogic & PeersDataPassing)?
    var peers = [Peers.Cell.ViewModel.PeerItems]()
    private lazy var dataSource = makeDataSource()
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        setup()
        tableView.delegate = self
        tableView.dataSource = dataSource
        interactor?.fetchPeer(request: Peers.Cell.Request())
    }
    
    func setup() {
        let viewController = self
        let interactor = PeersInteractor()
        let presenter = PeersPresenter()
        let router = PeersRouter()
        viewController.router = router
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    func displayPeersList(viewModel: Peers.Cell.ViewModel) {
        peers = viewModel.peers
        update()
    }
}

extension PeersView : UITableViewDelegate {
    func makeDataSource() -> UITableViewDiffableDataSource<PeerSection, AnyHashable> {
        return UITableViewDiffableDataSource<PeerSection, AnyHashable>(
            tableView: tableView,
            cellProvider: { tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "PeerCell") as! PeerCell
                let item = item as! Peers.Cell.ViewModel.PeerItems
                cell.games.text = item.games
                cell.playerName.text = item.playerName
                cell.winWith.text = item.winWith
                cell.playerImg.layer.cornerRadius = 5
                if item.playerImg != nil {
                    ImageCache.shared.fetchItemImg(url: item.playerImg!) { image in
                        cell.playerImg.image = image
                    }
                }
                else {
                    cell.playerImg.image = UIImage(systemName: "square")
                }
                return cell
            })
    }
    
    func update(animate: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<PeerSection, AnyHashable>()
        snapshot.appendSections(PeerSection.allCases)
        snapshot.appendItems(peers,toSection: .peer)
        dataSource.apply(snapshot,animatingDifferences: animate)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return PeerHeader()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}
