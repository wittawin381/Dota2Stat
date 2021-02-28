//
//  PlayerStatView.swift
//  test2
//
//  Created by Wittawin Muangnoi on 27/2/2564 BE.
//

import Foundation
import UIKit

class PlayerStatView : UIView {
    
    @IBOutlet var container: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    func initView() {
        if let nib = Bundle(for: type(of: self)).loadNibNamed("PlayerStat", owner: self, options: nil)?.first as? UIView {
            nib.frame = bounds
            nib.autoresizingMask = [.flexibleWidth,.flexibleHeight]
            addSubview(nib)
        }
        container.layer.cornerRadius = 20
    }
}
