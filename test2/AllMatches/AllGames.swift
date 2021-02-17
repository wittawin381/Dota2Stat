//
//  AllMatches.swift
//  test2
//
//  Created by Wittawin Muangnoi on 15/2/2564 BE.
//

import Foundation
import UIKit
import Combine

class AllGamesView : UIViewController, Storyboarded {
    weak var coordinator : MainCoordinator?
    var subscription = Set<AnyCancellable>()
    var viewModel : AllGamesVM?
    lazy var dataSource = makeDataSource()
    @IBOutlet weak var listTable: UITableView!
    override func viewDidLoad() {
        listTable.delegate = self
        listTable.dataSource = dataSource
        viewModel?.matches.sink(receiveCompletion: {_ in}, receiveValue: { value in
            self.update(animate: false)
        }).store(in: &subscription)
    }
    
}

extension AllGamesView : UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel?.matches.value.count ?? 0
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "listItemCell", for: indexPath) as! FixtureTableViewCell
//        let match = self.viewModel!.matches.value[indexPath.row]
//        let a = match.player_slot / 128 == 0
//        let b = match.radiant_win
//
//        let hero = Dota.shared.heroes.first(where: {$0.id == Int(match.hero_id)}) ?? Dota.shared.heroes[91]
//        let heroname = (hero.name ).lowercased().replacingOccurrences(of: "npc_dota_hero_", with: "")
//        cell.heroImg.image = UIImage(named: heroname + "_full")
//        cell.result.text = ( a && b || !a && !b ) ? "Won" : "Lost"
//        cell.result.textColor = cell.result.text == "Won" ? .systemGreen : .red
//        cell.bracket.text = Dota.lobbyType[match.lobby_type]
//        cell.gameMode.text = Dota.gameMode[match.game_mode]
//        cell.kda.text = String(match.kills) + " / " + String(match.deaths) + " / " + String(match.assists)
//        return cell
//    }
    
    func makeDataSource() ->  UITableViewDiffableDataSource<GameSection, AnyHashable> {
        return UITableViewDiffableDataSource(
            tableView: listTable,
            cellProvider: { tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "listItemCell", for: indexPath) as! FixtureTableViewCell
                let match = self.viewModel!.matches.value[indexPath.row]
                let a = match.player_slot! / 128 == 0
                let b = match.radiant_win!
                let hero = Dota.shared.heroes.first(where: {$0.id == Int(match.hero_id ?? 99)}) ?? Dota.shared.heroes[91]
                let heroname = (hero.name ?? "").lowercased().replacingOccurrences(of: "npc_dota_hero_", with: "")
                cell.heroImg.image = UIImage(named: heroname + "_full")
                cell.result.text = ( a && b || !a && !b ) ? "Won" : "Lost"
                cell.result.textColor = cell.result.text == "Won" ? .systemGreen : .red
                cell.bracket.text = Dota.lobbyType[match.lobby_type ?? 0]
                cell.gameMode.text = Dota.gameMode[match.game_mode ?? 0]
                cell.kda.text = String(match.kills ?? 0) + " / " + String(match.deaths ?? 0) + " / " + String(match.assists ?? 0)
                return cell
            })
    }
    
    func update(animate : Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<GameSection,AnyHashable>()
        snapshot.appendSections(GameSection.allCases)
        snapshot.appendItems(self.viewModel!.matches.value, toSection: .matches)
        dataSource.apply(snapshot,animatingDifferences: animate)
    }
    
}

extension AllGamesView : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = listTable.contentSize.height
        if offsetY > contentHeight - 100 - listTable.frame.height {
            guard !Dota.shared.isLoading else {
                print("LOADDDDed")
                return
            }
            viewModel?.loadMoreData()
            update(animate: true)
        }
    }
}
