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
    
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet var myNavbar: UINavigationBar!
    let playerStatView = PlayerStatView()
    let playerStatView2 = PlayerStatView()
    let skillsUpgradeView = SkillsUpgradeView()
    var marginLeft : CGFloat!
    var marginRight : CGFloat!
    var scrollDirection : CGPoint!
    
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
        skillsUpgradeView.collectionView.delegate = self
        scrollView.delegate = self
        segmentControl.addTarget(self, action: #selector(switchSegment), for: .valueChanged)
        marginLeft = (view.frame.width - (view.frame.width * 0.15 * 4) - 5 ) / 2
        marginRight = marginLeft
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
        self.myNavbar.topItem!.title = viewModel.detail.playerName
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


extension DetailModalView : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func makeDataSource() -> UICollectionViewDiffableDataSource<DetailModal.SkillsSection, URLS> {
        return UICollectionViewDiffableDataSource<DetailModal.SkillsSection, URLS>(
            collectionView: skillsUpgradeView.collectionView,
            cellProvider: { collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkillsCell", for: indexPath) as! SkillsUpgradeCollectionViewCell
                let url = item
                cell.level.text = String(indexPath.row + 1)
                cell.skillImage.contentMode = .scaleAspectFill
                cell.layer.borderColor = UIColor.systemGray5.cgColor
                cell.layer.cornerRadius = 15
                cell.layer.borderWidth = 1
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width * 0.16, height: width * 0.15 + 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    }
    
}

extension DetailModalView {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollDirection = scrollView.contentOffset
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let index = scrollView.contentOffset.x / scrollView.bounds.size.width
        if scrollDirection.x - scrollView.contentOffset.x != 0 {
            segmentControl.selectedSegmentIndex = Int(index)
        }
        
    }
    
}


extension DetailModalView {
    @objc func switchSegment(_ segmentControl: UISegmentedControl) {
        var frame = scrollView.frame
        switch segmentControl.selectedSegmentIndex {
        case 0:
            frame.origin.x = frame.size.width * 0
            scrollView.scrollRectToVisible(frame, animated: true)
        case 1:
            frame.origin.x = frame.size.width * 1
            scrollView.scrollRectToVisible(frame, animated: true)
        default:
            return
        }
    }
}
