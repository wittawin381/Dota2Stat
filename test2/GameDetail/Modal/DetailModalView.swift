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
    
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var heroImg: UIImageView!
    @IBOutlet var items: [UIImageView]!
    @IBOutlet var heroName: UILabel!
    @IBOutlet var playerName: UILabel!
    @IBOutlet var kda: UILabel!
    
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
        let playerStatView = PlayerStatView(frame: CGRect(x:0 , y: 0, width: stackView.frame.width, height: 390))
        let playerStatView2 = PlayerStatView(frame: CGRect(x:0, y: 0, width: stackView.frame.width, height: 390))
        stackView.addArrangedSubview(playerStatView)
        stackView.addArrangedSubview(playerStatView2)
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
    }
}


extension DetailModalView {
    
}
