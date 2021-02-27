//
//  ImageCache.swift
//  test2
//
//  Created by Wittawin Muangnoi on 27/2/2564 BE.
//

import Foundation
import UIKit
import ImageIO

class ImageCache {
    public static let shared = ImageCache()
    var cachedImage = NSCache<NSURL, UIImage>()
    
    private init() {
        cachedImage.countLimit = 60
    }
    
    func fetchItemImg(url: NSURL?, completionHandler: @escaping (UIImage)->Void) {
        if let cachedImage = imageFromCached(url: url!) {
            DispatchQueue.main.async {
                completionHandler(cachedImage)
            }
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url! as URL) { data,response,error in
            if let data = data {
                DispatchQueue.main.async { [unowned self] in
                    let resizedImage = ImageResize.shared.resized(image: UIImage(data: data)!)
                    cachedImage.setObject(resizedImage, forKey: url!)
                    completionHandler(resizedImage)
                    
                }
            }
        }
        dataTask.resume()
    }
    
    func imageFromCached(url: NSURL) -> UIImage? {
        return cachedImage.object(forKey: url)
    }
    
    
}
