//
//  PeersPresenter.swift
//  test2
//
//  Created by Wittawin Muangnoi on 16/3/2564 BE.
//

import Foundation

protocol PeersPresentLogic {
    func presentPeers(response: Peers.Cell.Response)
}

class PeersPresenter : PeersPresentLogic {
    weak var viewController : PeersViewLogic?
    
    func presentPeers(response: Peers.Cell.Response) {
        var viewModels = [Peers.Cell.ViewModel.PeerItems]()
        
        for peer in response.peers {
            let viewModel = Peers.Cell.ViewModel.PeerItems(
                playerImg: peer.avatar == nil ? nil : NSURL(string: peer.avatar!),
                playerName: peer.personaname ?? "Anonymous",
                games: String(peer.with_games ?? 0),
                winWith: String(peer.with_win ?? 0)
            )
            viewModels.append(viewModel)
        }
        
        self.viewController?.displayPeersList(viewModel: Peers.Cell.ViewModel(peers: viewModels))
    }
}
