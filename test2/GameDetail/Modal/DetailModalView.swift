//
//  DetailModalView.swift
//  test2
//
//  Created by Wittawin Muangnoi on 26/2/2564 BE.
//

import Foundation
import UIKit

protocol DetailModalViewLogic : class {
    
}

class DetailModalView : UIViewController, DetailModalViewLogic {
    var router : (DetailRouterLogic & DetailDataPassing)?
    var interactor : DetailInteractor?
    
    override func viewDidLoad() {
        
    }
    
    func setup() {
        
    }
}
