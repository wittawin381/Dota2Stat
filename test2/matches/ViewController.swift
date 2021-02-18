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

class ViewController: UIViewController , Storyboarded{
    weak var coordinator: HomeCoordinator?
    @IBOutlet weak var listTable: UITableView!
    let search = UISearchController()
    let viewModel = MatchesVM()
    var subscription = Set<AnyCancellable>()
    private lazy var dataSource = self.makeDataSource()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.viewModel.matches.sink(receiveCompletion: {_ in }, receiveValue: { value in
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
    
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.destination is AllGamesView{
//            let viewController = segue.destination as! AllGamesView
//            
//        }
//    }
}

extension ViewController : UITableViewDelegate {
    func makeDataSource() -> UITableViewDiffableDataSource<MatchSection, AnyHashable> {
        return UITableViewDiffableDataSource(
            tableView: listTable,
            cellProvider: { tableView, indexPath, item in
                
                
                if item is Match {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "listItemCell", for: indexPath) as! FixtureTableViewCell
                    let match = self.viewModel.matches.value[indexPath.row]
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
                }
                else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "heroesCell", for: indexPath) as! MyHeoresTableViewCell
                    let myStat = self.viewModel.heroesStat.value[indexPath.row]
                    let hero = Dota.shared.heroes.first(where: {$0.id == Int(myStat.hero_id ?? "91")}) ?? Dota.shared.heroes[91]
                    let heroname = (hero.name ?? "").lowercased().replacingOccurrences(of: "npc_dota_hero_", with: "")
                    
                    let winrate = Double(myStat.win ?? 0) * 100.0 /  Double(myStat.games ?? 0)
                    cell.heroImg.image = UIImage(named: heroname + "_full")
                    cell.heroName.text = hero.localized_name
                    cell.matchPlayed.text = String(myStat.games ?? 0)
                    cell.matchPlayProg.progress = 0
                    cell.winrate.text = myStat.games == 0 ? "0 %" : String(format: "%.2f %%",winrate)
                    cell.winrateProg.progress = 0
                    UIView.animate(withDuration: 1.0, animations: {
                        cell.winrateProg.setProgress(Float(winrate/100), animated: true)
                        cell.winrateProg.progressTintColor = UIColor(hue: (CGFloat(winrate) / 100.0) / 3, saturation: 1.0, brightness: 1.0, alpha: 1.0)
                    })
                    UIView.animate(withDuration: 1.0, animations: {
                        cell.matchPlayProg.setProgress(Float(myStat.games ?? 0) / Float(self.viewModel.heroesStat.value[0].games ?? 0), animated: true)
                        cell.matchPlayProg.progressTintColor =  UIColor(hue: CGFloat(cell.matchPlayProg.progress) / 3, saturation: 1.0, brightness: 1.0, alpha: 1.0)
                    })
                    return cell
                }
            }
        );
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (indexPath.section == 0) {
            coordinator?.toAllGamesView()
            
        }
        else {
            coordinator?.toHeroStatView()
        }
    }
    
    func update(animate : Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<MatchSection,AnyHashable>()
        snapshot.appendSections(MatchSection.allCases)
        snapshot.appendItems(Array(self.viewModel.matches.value.prefix(5)), toSection: .matches)
        snapshot.appendItems(Array(self.viewModel.heroesStat.value.prefix(5)), toSection: .heroes)
        dataSource.apply(snapshot,animatingDifferences: animate)
    }
    
}


