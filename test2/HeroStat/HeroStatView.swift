//
//  HeroStatView.swift
//  test2
//
//  Created by Wittawin Muangnoi on 16/2/2564 BE.
//

import Foundation
import UIKit
import Combine


class HeroStatView : UIViewController, Storyboarded {
    weak var coordinator : MainCoordinator?
    var viewModel : HeroStatVM?
    var subscription = Set<AnyCancellable>()
    @IBOutlet weak var listTable: UITableView!
    
    private lazy var dataSource = makeDataSource()
    override func viewDidLoad() {
        listTable.delegate = self
        listTable.dataSource = dataSource
        self.viewModel?.myStat.sink(receiveCompletion: {_ in}, receiveValue: { value in
            self.update(animate: false)
        }).store(in: &subscription)
    }
    
}

extension HeroStatView : UITableViewDelegate {
    
    func makeDataSource() -> UITableViewDiffableDataSource<HeroStatSection, AnyHashable> {
        return UITableViewDiffableDataSource(
            tableView: listTable,
            cellProvider: { tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "heroesCell", for: indexPath) as! MyHeoresTableViewCell
                let myStat = self.viewModel!.myStat.value[indexPath.row]
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
                    cell.matchPlayProg.setProgress(Float(myStat.games ?? 0) / Float(self.viewModel?.myStat.value[0].games ?? 0), animated: true)
                    cell.matchPlayProg.progressTintColor =  UIColor(hue: CGFloat(cell.matchPlayProg.progress) / 3, saturation: 1.0, brightness: 1.0, alpha: 1.0)
                })
                return cell
            })
    }
    
    func update(animate : Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<HeroStatSection,AnyHashable>()
        snapshot.appendSections(HeroStatSection.allCases)
        snapshot.appendItems(self.viewModel!.myStat.value, toSection: .stat)
        dataSource.apply(snapshot,animatingDifferences: animate)
    }
}

