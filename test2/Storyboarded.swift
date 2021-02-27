////
////  Storyboarded.swift
////  test2
////
////  Created by Wittawin Muangnoi on 16/2/2564 BE.
////
//
//import Foundation
//import UIKit
//
//protocol Storyboarded {
//    static func instantiate() -> Self
//}
//
//
////extension UIViewController : Storyboarded {
////    static func instantiate() -> Self{
////        let id = String(describing : self)
////        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
////        return storyboard.instantiateViewController(identifier: id) as! Self
////    }
////}
//
//extension Storyboarded where Self : UIViewController {
//    static func instantiate() -> Self{
//        let id = String(describing : self)
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        return storyboard.instantiateViewController(identifier: id) as! Self
//    }
//}
