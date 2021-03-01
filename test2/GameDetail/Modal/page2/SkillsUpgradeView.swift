//
//  SkillsUpgradeView.swift
//  test2
//
//  Created by Wittawin Muangnoi on 1/3/2564 BE.
//

import Foundation
import UIKit

class SkillsUpgradeView : UIView {
    @IBOutlet var collectionView: UICollectionView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    func initView() {
        if let nib = Bundle(for: type(of: self)).loadNibNamed("SkillUpgrade", owner: self, options: nil)?.first as? UIView {
            nib.frame = bounds
            nib.autoresizingMask = [.flexibleWidth,.flexibleHeight]
            addSubview(nib)
            initCollectionView()
        }
    }
    
    func initCollectionView() {
        let nib = UINib(nibName: "SkillsUpgradeCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "SkillsCell")
        collectionView.layer.cornerRadius = 15
        collectionView.backgroundColor = .clear
    }
}
