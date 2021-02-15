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

class ViewController: UIViewController {
    @IBOutlet weak var listTable: UITableView!
    let search = UISearchController()
    let viewModel = MatchesVM()
    var subscription = Set<AnyCancellable>()
    private lazy var dataSource = self.makeDataSource()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        viewModel.matches.sink(receiveCompletion: {_ in }, receiveValue: { value in
//            self.update(animate: true)
            self.viewModel.heroesStat.sink(receiveCompletion: {_ in }, receiveValue: { value in
                self.update(animate: true)
            }).store(in: &self.subscription)
        }).store(in: &subscription)
        
        listTable.delegate = self
        listTable.dataSource = dataSource
//        let headers : HTTPHeaders = [
//            "x-api-key" : "PMAK-60103ba8df1c5000529fa3d2-7e4d1114bc7efbc3b1029644c88dfffc4c",
//            "Accept" : "application/json"
//        ]
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.destination is ReminderListViewController{
//            let viewController = segue.destination as! ReminderListViewController
//            viewController.pageTitle = self.listItems![(listTable.indexPathForSelectedRow!.row)].title!
//        }
    }
}

extension ViewController : UITableViewDelegate {
    func makeDataSource() -> UITableViewDiffableDataSource<MatchSection, AnyHashable> {
        return UITableViewDiffableDataSource(
            tableView: listTable,
            cellProvider: { tableView, indexPath, item in
                if item is Match {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "listItemCell", for: indexPath) as! FixtureTableViewCell
                    let match = self.viewModel.matches.value[indexPath.row]
                    let a = match.player_slot / 128 == 0
                    let b = match.radiant_win
                    cell.result.text = ( a && b || !a && !b ) ? "Won" : "Lost"
                    cell.result.textColor = cell.result.text == "Won" ? .systemGreen : .red
                    cell.bracket.text = self.viewModel.lobbyType[match.lobby_type]
                    cell.gameMode.text = self.viewModel.gameMode[match.game_mode]
                    cell.kda.text = String(match.kills) + " / " + String(match.deaths) + " / " + String(match.assists)
                    return cell
                }
                else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "heroesCell", for: indexPath) as! MyHeoresTableViewCell
                    let myStat = self.viewModel.heroesStat.value[indexPath.row]
                    let hero = self.viewModel.heroes.first(where: {$0.id == Int(myStat.hero_id)}) ?? self.viewModel.heroes[91]
                    let heroname = (hero.name ).lowercased().replacingOccurrences(of: "npc_dota_hero_", with: "")
                    let winrate = Double(myStat.win) * 100.0 /  Double(myStat.games)
                    cell.heroImg.image = UIImage(named: heroname + "_full")
                    cell.heroName.text = hero.localized_name
                    cell.matchPlayed.text = String(myStat.games)
                    cell.matchPlayProg.progress = 0
                    cell.winrate.text = myStat.games == 0 ? "0 %" : String(format: "%.2f %%",winrate)
                    cell.winrateProg.progress = 0
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                        // your code here
                    UIView.animate(withDuration: 1.0, animations: {
                        cell.winrateProg.setProgress(Float(winrate/100), animated: true)
                    })
                    UIView.animate(withDuration: 1.0, animations: {
                        cell.matchPlayProg.setProgress(Float(myStat.games) / Float(self.viewModel.heroesStat.value[0].games), animated: true)
                    })
//                        
//                    }
                        
                    
                    
                    
                    return cell
                }
            }
        );
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func update(animate : Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<MatchSection,AnyHashable>()
        snapshot.appendSections(MatchSection.allCases)
        snapshot.appendItems(viewModel.matches.value, toSection: .matches)
        snapshot.appendItems(Array(viewModel.heroesStat.value.prefix(5)), toSection: .heroes)
        dataSource.apply(snapshot,animatingDifferences: animate)
    }
    
}


