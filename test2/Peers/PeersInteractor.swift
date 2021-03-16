//
//  PeersInteractor.swift
//  test2
//
//  Created by Wittawin Muangnoi on 16/3/2564 BE.
//

import Foundation
import Combine

protocol PeersBusinessLogic {
    func fetchPeer(request : Peers.Cell.Request)
}

protocol PeersDataStore {
    
}

class PeersInteractor : PeersBusinessLogic, PeersDataStore {
    var presenter : PeersPresentLogic?
    var subscription = Set<AnyCancellable>()
    var peers = [Peer]()
    func fetchPeer(request: Peers.Cell.Request) {
        OpenDota.shared.get(.peer, params: [:], withType: [Peer].self).sink(receiveCompletion: {_ in}, receiveValue: {[unowned self] peers in
            self.peers = peers
            self.presenter?.presentPeers(response: Peers.Cell.Response(peers: self.peers))
        }).store(in: &subscription)
    }
}
