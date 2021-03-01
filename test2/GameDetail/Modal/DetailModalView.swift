//
//  DetailModalView.swift
//  test2
//
//  Created by Wittawin Muangnoi on 26/2/2564 BE.
//

import Foundation
import UIKit

protocol DetailModalViewLogic : class {
    func displayPlayerStat(viewModel : DetailModal.UI.ViewModel)
}

class DetailModalView : UIViewController, DetailModalViewLogic {
    var router : (DetailRouterLogic & DetailDataPassing)?
    var interactor : DetailInteractor?
    var urls = [URLS]()
    private lazy var dataSource = makeDataSource()
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var heroImg: UIImageView!
    @IBOutlet var items: [UIImageView]!
    @IBOutlet var heroName: UILabel!
    @IBOutlet var playerName: UILabel!
    @IBOutlet var kda: UILabel!
    
    let playerStatView = PlayerStatView()
    let playerStatView2 = PlayerStatView()
    let skillsUpgradeView = SkillsUpgradeView()
    
    private var detail : DetailModal.UI.ViewModel.Detail!
    private var page1 : DetailModal.UI.ViewModel.Page1!
    private var page2 : DetailModal.UI.ViewModel.Page2!
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func viewDidLoad() {
        initPageView()
        interactor?.getPlayerData(request: DetailModal.UI.Request())
    }
    
    func setup() {
        let viewController = self
        let interactor = DetailInteractor()
        let presenter = DetailPresenter()
        let router = DetailRouter()
        viewController.interactor = interactor
        viewController.router = router
        router.viewController = viewController
        router.dataStore = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        
    }
    
    func initPageView() {
        //scrollView.contentSize = CGSize(width: view.frame.width * 2, height: scrollView.frame.height)
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(playerStatView)
        stackView.addArrangedSubview(skillsUpgradeView)
        NSLayoutConstraint.activate([
            playerStatView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
        
    }
    
    func displayPlayerStat(viewModel: DetailModal.UI.ViewModel) {
        self.detail = viewModel.detail
        self.page1 = viewModel.page1
        self.page2 = viewModel.page2
        heroImg.layer.cornerRadius = 15
        heroImg.contentMode = .scaleAspectFill
        heroImg.image = UIImage(named: viewModel.detail.heroImg)
        playerName.text = viewModel.detail.playerName
        kda.text = viewModel.detail.kda
        heroName.text = viewModel.detail.heroName
        for i in 0...8 {
            items[i].contentMode = .scaleAspectFill
            items[i].layer.cornerRadius = 3
            if viewModel.detail.items[i] != nil {
                ImageCache.shared.fetchItemImg(url: viewModel.detail.items[i]) { [weak self] image in
                    self!.items[i].image = image
                }
            }
            else {
                items[i].backgroundColor = .systemGray5
            }
        }
        playerStatView.damage.text = viewModel.page1.damage
        playerStatView.denies.text = viewModel.page1.denies
        playerStatView.gpm.text = viewModel.page1.gpm
        playerStatView.lastHit.text = viewModel.page1.lastHit
        playerStatView.level.text = viewModel.page1.level
        playerStatView.towerDmg.text = viewModel.page1.towerDmg
        playerStatView.xpm.text = viewModel.page1.xpm
        urls = viewModel.page2.skills
        update(animate: false)
    }
}


extension DetailModalView : UICollectionViewDelegate {
    func makeDataSource() -> UICollectionViewDiffableDataSource<DetailModal.SkillsSection, URLS> {
        return UICollectionViewDiffableDataSource<DetailModal.SkillsSection, URLS>(
            collectionView: skillsUpgradeView.collectionView,
            cellProvider: { collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkillsCell", for: indexPath) as! SkillsUpgradeCollectionViewCell
                let url = item
                cell.level.text = String(indexPath.row + 1)
                if url.url != nil {
                    ImageCache.shared.fetchItemImg(url: url.url) { image in
                        cell.skillImage.image = image
                    }
                }
                else {
                    cell.skillImage.image = nil
                    cell.skillImage.backgroundColor = .systemGray5
                }
                return cell
            }
        )
    }
    
    func update(animate : Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<DetailModal.SkillsSection, URLS>()
        snapshot.appendSections(DetailModal.SkillsSection.allCases)
        snapshot.appendItems(urls)
        dataSource.apply(snapshot,animatingDifferences: animate)
    }
}
